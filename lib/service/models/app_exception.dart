class AppException implements Exception {
  final String? message;
  final String? prefix;
  
AppException([this.message, this.prefix]);
  
@override
  String toString() {
    return "$prefix, $message";
  }
}

class NoConnectionException extends AppException {
  NoConnectionException([String? message])
      : super(message, "Check your connection");
}

class TimeOutException extends AppException {
  TimeOutException([String? message])
      : super(message, "Request Timed Out");
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Error Occured");
}