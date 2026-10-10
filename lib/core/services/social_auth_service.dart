import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../exceptions/app_exceptions.dart';

/// Supported social authentication providers.
enum SocialProvider { google, facebook, apple }

/// Handles provider-specific sign-in flows via Firebase Auth.
/// Returns the Firebase ID token string on success.
class SocialAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _googleInitialized = false;

  /// Signs in with the specified [provider] and returns a Firebase ID token.
  Future<String> signIn(SocialProvider provider) async {
    try {
      final UserCredential credential;
      switch (provider) {
        case SocialProvider.google:
          credential = await _signInWithGoogle();
        case SocialProvider.facebook:
          credential = await _signInWithFacebook();
        case SocialProvider.apple:
          credential = await _signInWithApple();
      }

      final idToken = await credential.user?.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw ServerException(
          'Impossibile ottenere il token di autenticazione',
        );
      }
      return idToken;
    } on AppException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Autenticazione social fallita');
    } catch (e) {
      throw ServerException('Autenticazione social fallita');
    }
  }

  /// Signs out from Firebase Auth and all social providers.
  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }

  // ── Google ──────────────────────────────────────────────

  Future<UserCredential> _signInWithGoogle() async {
    if (!_googleInitialized) {
      await GoogleSignIn.instance.initialize();
      _googleInitialized = true;
    }

    try {
      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw ServerException('Accesso con Google annullato');
      }
      rethrow;
    }
  }

  // ── Facebook ────────────────────────────────────────────

  Future<UserCredential> _signInWithFacebook() async {
    final result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.cancelled) {
      throw ServerException('Accesso con Facebook annullato');
    }
    if (result.status != LoginStatus.success || result.accessToken == null) {
      throw ServerException(
        result.message ?? 'Accesso con Facebook fallito',
      );
    }

    final credential = FacebookAuthProvider.credential(
      result.accessToken!.tokenString,
    );
    return _firebaseAuth.signInWithCredential(credential);
  }

  // ── Apple ───────────────────────────────────────────────

  Future<UserCredential> _signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    return _firebaseAuth.signInWithCredential(oauthCredential);
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
