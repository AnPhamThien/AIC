abstract class AuthenticationStatus {
  const AuthenticationStatus();
}

class InitialAuthenticationStatus extends AuthenticationStatus {
  const InitialAuthenticationStatus();
}

class AuthenticationAuthenticated extends AuthenticationStatus {}

class AuthenticationUnactivated extends AuthenticationStatus {}

class AuthenticationUnauthenticated extends AuthenticationStatus {}
