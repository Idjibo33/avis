import 'package:serverpod/serverpod.dart';

/// Base locale pour les endpoints dont toutes les méthodes exigent une session
/// authentifiée. Serverpod 4.1.2 ne fournit pas de classe `LoggedInEndpoint`
/// prête à l'emploi : celle-ci reproduit simplement le garde-fou attendu.
abstract class LoggedInEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
}
