import 'package:benchmark_harness/benchmark_harness.dart' show ScoreEmitter;
import 'package:benchmark_base_x/benchmarkbasex.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockEmitter extends Mock implements ScoreEmitter {
  MockEmitter();

  @override
  void emit(String testName, double value) {
    expect(value > 0.0, equals(true));
  }
}

class MockBenchmark extends BenchmarkBaseX {
  MockBenchmark() : super('mock BenchmarkBaseX');

  int runCount = 0;

  @override
  void run() {
    runCount++;
  }
}

void main() {
  test('runIsCalled', () {
    final MockBenchmark mb = MockBenchmark();
    mb.measure(warmUpInMillis: 1, minExerciseInMillis: 1);
    expect(mb.runCount > 1, equals(true));
  });

  test('BenchmarkBaseX', () {
    final BenchmarkBaseX ebm =
        BenchmarkBaseX('empty', emitter: MockEmitter());
    ebm.report(warmUpInMillis: 1, minExerciseInMillis: 1);
  });
}
