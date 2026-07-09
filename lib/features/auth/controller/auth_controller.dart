import 'package:get/get.dart';
import 'package:vyzi/core/services/auth_service.dart';
import 'package:vyzi/core/services/social_auth_service.dart';
import 'package:vyzi/core/services/storage_service.dart';
import 'package:vyzi/core/exceptions/app_exceptions.dart';
import 'package:vyzi/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _auth = AuthService();
  final SocialAuthService _socialAuth = SocialAuthService();

  var isLoading = false.obs;
  var error = ''.obs;

  /// Registers user and returns the response map on success.
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required String phone,
    required String role,
    String? referralCode,
  }) async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _auth.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: role,
        referralCode: referralCode,
      );
      return res;
    } on AppException catch (e) {
      error.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String code,
    required String type,
  }) async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _auth.verifyOtp(email: email, code: code, type: type);
      return res;
    } on AppException catch (e) {
      error.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _auth.login(email: email, password: password);

      // Persist tokens if present
      final data = res['data'] as Map<String, dynamic>?;
      if (data != null) {
        final accessToken = data['accessToken'] as String?;
        final refreshToken = data['refreshToken'] as String?;
        final user = data['user'] as Map<String, dynamic>?;

        final storage = Get.find<StorageService>();
        if (accessToken != null) await storage.setString(StorageKeys.authToken, accessToken);
        if (refreshToken != null) await storage.setString(StorageKeys.refreshToken, refreshToken);
        if (user != null) {
          if (user['id'] != null) await storage.setString(StorageKeys.userId, user['id'].toString());
          if (user['email'] != null) await storage.setString(StorageKeys.userEmail, user['email'].toString());
        }
        await storage.setBool(StorageKeys.isLoggedIn, true);
      }

      return res;
    } on AppException catch (e) {
      error.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Performs social login: provider sign-in -> Firebase ID token -> backend auth -> persist tokens.
  Future<void> socialLogin(SocialProvider provider) async {
    isLoading.value = true;
    error.value = '';
    try {
      final idToken = await _socialAuth.signIn(provider);
      final res = await _auth.socialLogin(idToken: idToken);

      final data = res['data'] as Map<String, dynamic>?;
      if (data != null) {
        final accessToken = data['accessToken'] as String?;
        final refreshToken = data['refreshToken'] as String?;
        final user = data['user'] as Map<String, dynamic>?;

        final storage = Get.find<StorageService>();
        if (accessToken != null) await storage.setString(StorageKeys.authToken, accessToken);
        if (refreshToken != null) await storage.setString(StorageKeys.refreshToken, refreshToken);
        if (user != null) {
          if (user['id'] != null) await storage.setString(StorageKeys.userId, user['id'].toString());
          if (user['email'] != null) await storage.setString(StorageKeys.userEmail, user['email'].toString());
        }
        await storage.setBool(StorageKeys.isLoggedIn, true);
      }
    } on AppException catch (e) {
      error.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _auth.forgotPassword(email: email);
      return res;
    } on AppException catch (e) {
      error.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _auth.resetPassword(email: email, code: code, newPassword: newPassword);
      return res;
    } on AppException catch (e) {
      error.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Revokes the refresh token on the server, clears all local auth data,
  /// and navigates to the sign-in screen.
  Future<void> logout() async {
    final storage = Get.find<StorageService>();
    final token = storage.getString(StorageKeys.refreshToken);
    if (token != null && token.isNotEmpty) {
      await _auth.logoutFromServer(refreshToken: token);
    }
    await _socialAuth.signOut();
    await storage.remove(StorageKeys.authToken);
    await storage.remove(StorageKeys.refreshToken);
    await storage.remove(StorageKeys.userId);
    await storage.remove(StorageKeys.userName);
    await storage.remove(StorageKeys.userEmail);
    await storage.setBool(StorageKeys.isLoggedIn, false);
    Get.offAllNamed(AppRoutes.signInScreen);
  }

  Future<Map<String, dynamic>> refreshToken({required String refreshToken}) async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _auth.refreshToken(refreshToken: refreshToken);

      // update stored tokens
      final data = res['data'] as Map<String, dynamic>?;
      if (data != null) {
        final accessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;
        final storage = Get.find<StorageService>();
        if (accessToken != null) await storage.setString(StorageKeys.authToken, accessToken);
        if (newRefreshToken != null) await storage.setString(StorageKeys.refreshToken, newRefreshToken);
      }

      return res;
    } on AppException catch (e) {
      error.value = e.message;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
