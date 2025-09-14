import 'package:chat_app/app/core/errors/failure.dart';
import 'package:dio/dio.dart';

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure("Connection Timeout");
      case DioExceptionType.sendTimeout:
        return ServerFailure("Send Timeout");
      case DioExceptionType.receiveTimeout:
        return ServerFailure("Receive Timeout");
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response!.statusCode!,
          dioException.response!.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure("Request Cancelled");
      case DioExceptionType.unknown:
        if (dioException.message!.contains("SocketException")) {
          return ServerFailure("No Internet Connection");
        }
        return ServerFailure("Unknown Error");
      case DioExceptionType.badCertificate:
        return ServerFailure("Bad Certificate");
      case DioExceptionType.connectionError:
        return ServerFailure("Connection Error");
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response["error"]["message"]);
    } else if (statusCode == 404) {
      return ServerFailure("Your request not found, please try again later!");
    } else if (statusCode == 500) {
      return ServerFailure("Internal Server Error, please try again later!");
    } else {
      return ServerFailure("Something went wrong, please try again later!");
    }
  }
}
