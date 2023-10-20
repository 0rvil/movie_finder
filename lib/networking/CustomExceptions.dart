class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString(){
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
    : super(message, "Error during communication: ");
}
class BadRequestException extends CustomException{
  BadRequestException([message]): super(message, "Invalid Request: ");
}
class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}