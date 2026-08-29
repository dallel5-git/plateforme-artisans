/// Statut de session global de l'app (FM-05d), distinct de `AuthFlowState`
/// (FM-05b) qui ne porte que la progression de l'écran de connexion.
/// `isProvider` reflète `user.roles` tel que renvoyé par le serveur (P4) —
/// jamais recalculé côté Dart.
enum AuthStatusKind { unknown, unauthenticated, authenticated }

class AuthStatus {
  const AuthStatus._({required this.kind, this.isProvider = false});

  const AuthStatus.unknown() : this._(kind: AuthStatusKind.unknown);

  const AuthStatus.unauthenticated()
    : this._(kind: AuthStatusKind.unauthenticated);

  const AuthStatus.authenticated({required bool isProvider})
    : this._(kind: AuthStatusKind.authenticated, isProvider: isProvider);

  final AuthStatusKind kind;
  final bool isProvider;

  bool get isAuthenticated => kind == AuthStatusKind.authenticated;
}
