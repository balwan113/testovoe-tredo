abstract class Failure {
  final String message;

  Failure(this.message);
  }

  class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('нет подключения к интернету');
}