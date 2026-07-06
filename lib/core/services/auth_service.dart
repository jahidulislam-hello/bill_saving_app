import 'package:dio/dio.dart';
import 'api_service.dart';
import '../constants/api_constants.dart';
import '../exceptions/app_exceptions.dart';

/// AuthService contains high-level auth API calls used by controllers.
/// Each method returns the parsed response map on success or throws AppException on error.
class AuthService {
  final ApiService _api = ApiService();

  /// Registers a new user.
  /// [role] should be either 'personal' or 'business'. [referralCode] is optional.
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
    final body = {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'role': role,
      if (referralCode != null && referralCode.isNotEmpty) 'referralCode': referralCode,
    };

    try {
      final resp = await _api.post(ApiConstants.authRegister, data: body);
      final data = resp.data as Map<String, dynamic>;

      if (data['success'] == true) {
        return data;
      }

      // API returned success=false — normalise error message
      final msg = _extractApiMessage(data);
      throw ServerException(msg, data['statusCode'] as int?);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  /// Verifies OTP (used for sign-up email verification and forgot-password flows)
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String code,
    required String type, // e.g. "email_verification"
  }) async {
    final body = {'email': email, 'code': code, 'type': type};
    try {
      final resp = await _api.post(ApiConstants.authVerifyOtp, data: body);
      final data = resp.data as Map<String, dynamic>;
      if (data['success'] == true) return data;
      final msg = _extractApiMessage(data);
      throw ServerException(msg, data['statusCode'] as int?);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  /// Login with email/password. Returns full response map including tokens on success.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final body = {'email': email, 'password': password};
    try {
      final resp = await _api.post(ApiConstants.authLogin, data: body);
      final data = resp.data as Map<String, dynamic>;
      if (data['success'] == true) return data;
      final msg = _extractApiMessage(data);
      throw ServerException(msg, data['statusCode'] as int?);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  /// Triggers forgot-password flow: sends reset code if email exists.
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final body = {'email': email};
    try {
      final resp = await _api.post(ApiConstants.authForgotPassword, data: body);
      final data = resp.data as Map<String, dynamic>;
      if (data['success'] == true) return data;
      final msg = _extractApiMessage(data);
      throw ServerException(msg, data['statusCode'] as int?);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  /// Reset password using code from forgot-password flow
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final body = {'email': email, 'code': code, 'newPassword': newPassword};
    try {
      final resp = await _api.post(ApiConstants.authResetPassword, data: body);
      final data = resp.data as Map<String, dynamic>;
      if (data['success'] == true) return data;
      final msg = _extractApiMessage(data);
      throw ServerException(msg, data['statusCode'] as int?);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  /// Calls backend to revoke the refresh token on logout.
  Future<void> logoutFromServer({required String refreshToken}) async {
    try {
      await _api.post(ApiConstants.authLogout, data: {'refreshToken': refreshToken});
    } catch (_) {
      // Best-effort — don't block local logout if server call fails
    }
  }

  /// Refreshes access token using refresh token
  Future<Map<String, dynamic>> refreshToken({required String refreshToken}) async {
    final body = {'refreshToken': refreshToken};
    try {
      final resp = await _api.post(ApiConstants.authRefreshToken, data: body);
      final data = resp.data as Map<String, dynamic>;
      if (data['success'] == true) return data;
      final msg = _extractApiMessage(data);
      throw ServerException(msg, data['statusCode'] as int?);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ParsingException(e.toString());
    }
  }

  /// Utility to extract message text from API error payloads.
  String _extractApiMessage(Map<String, dynamic> data) {
    try {
      final msg = data['message'];
      if (msg == null) return 'Unknown error';
      if (msg is String) return msg;
      if (msg is List) return msg.map((e) => e.toString()).join(', ');
      return msg.toString();
    } catch (_) {
      return 'Unknown error';
    }
  }
}
