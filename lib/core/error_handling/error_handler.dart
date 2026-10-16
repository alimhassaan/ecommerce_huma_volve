import 'package:dio/dio.dart';
import 'package:ecommerce_app_huma_volve/core/error_handling/failure.dart';

class ErrorHandler implements Exception {
  late final Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleDioError(error);
    } else {
      failure = Failure(
        failureMessage: 'An unexpected error occurred. Please try again later.',
      );
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure(
          failureMessage: 'The network connection timed out. Please try again.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return Failure(failureMessage: 'The request was cancelled.');

      case DioExceptionType.connectionError:
        return Failure(
          failureMessage: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badCertificate:
        return Failure(failureMessage: 'The security certificate is invalid.');

      case DioExceptionType.unknown:
      default:
        return Failure(failureMessage: 'A network error occurred.');
    }
  }

  Failure _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Use the API error message when one is available.
    String? serverMessage;
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message is String) {
        serverMessage = message;
      }
    }

    switch (statusCode) {
      case 400:
        return Failure(
          failureMessage: serverMessage ?? 'Invalid request.',
          statusCode: statusCode,
        );
      case 401:
        return Failure(
          failureMessage:
              serverMessage ??
              'Your session has expired. Please sign in again.',
          statusCode: statusCode,
        );
      case 403:
        return Failure(
          failureMessage:
              serverMessage ??
              'You do not have permission to access this resource.',
          statusCode: statusCode,
        );
      case 404:
        return Failure(
          failureMessage:
              serverMessage ?? 'The requested resource was not found.',
          statusCode: statusCode,
        );
      case 409:
        return Failure(
          failureMessage:
              serverMessage ?? 'Duplicate data or a request conflict.',
          statusCode: statusCode,
        );
      case 500:
      case 502:
      case 503:
        return Failure(
          failureMessage: 'A server error occurred. Please try again later.',
          statusCode: statusCode,
        );
      default:
        return Failure(
          failureMessage:
              serverMessage ?? 'An unexpected error occurred ($statusCode).',
          statusCode: statusCode,
        );
    }
  }
}
