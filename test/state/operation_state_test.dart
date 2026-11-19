import 'package:avis/State/operation_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('l état initial est repos et sans message', () {
    const OperationState state = OperationIdle();

    expect(state.isRunning, isFalse);
    expect(state.message, isEmpty);
    expect(state.errorMessage, isNull);
  });

  test('les états terminalisés exposent leur message', () {
    const OperationState done = OperationSucceeded('Duel ajouté');
    const OperationState failed = OperationFailed('boom');

    expect(done.isRunning, isFalse);
    expect(done.message, 'Duel ajouté');
    expect(done.errorMessage, isNull);
    expect(failed.message, 'boom');
    expect(failed.errorMessage, 'boom');
  });

  test('when couvre les quatre états', () {
    String render(OperationState state) => state.when(
      idle: () => 'repos',
      running: () => 'encours',
      succeeded: (message) => 'ok:$message',
      failed: (message) => 'err:$message',
    );

    expect(render(const OperationIdle()), 'repos');
    expect(render(const OperationRunning()), 'encours');
    expect(render(const OperationSucceeded('ok')), 'ok:ok');
    expect(render(const OperationFailed('no')), 'err:no');
  });
}
