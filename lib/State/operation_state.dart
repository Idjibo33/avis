/// État explicite et exhaustif d'une opération asynchrone.
sealed class OperationState {
  const OperationState();

  bool get isRunning => this is OperationRunning;

  String get message => switch (this) {
    OperationSucceeded(:final message) => message,
    OperationFailed(:final message) => message,
    _ => '',
  };

  String? get errorMessage => switch (this) {
    OperationFailed(:final message) => message,
    _ => null,
  };

  R when<R>({
    required R Function() idle,
    required R Function() running,
    required R Function(String message) succeeded,
    required R Function(String message) failed,
  }) => switch (this) {
    OperationIdle() => idle(),
    OperationRunning() => running(),
    OperationSucceeded(:final message) => succeeded(message),
    OperationFailed(:final message) => failed(message),
  };
}

final class OperationIdle extends OperationState {
  const OperationIdle();
}

final class OperationRunning extends OperationState {
  const OperationRunning();
}

final class OperationSucceeded extends OperationState {
  const OperationSucceeded(this.message);

  @override
  final String message;
}

final class OperationFailed extends OperationState {
  const OperationFailed(this.message);

  @override
  final String message;
}
