abstract class Failure implements Exception {
  String get message;
}

class ReceivedError extends Failure {
  final String message;
  ReceivedError({this.message});
}

class SendError extends Failure {
  final String message;
  SendError({this.message});
}

class GetError extends Failure {
  final String message;
  GetError({this.message});
}

class GetClientUidError extends Failure {
  final String message;
  GetClientUidError({this.message});
}
