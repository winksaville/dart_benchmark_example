import 'package:benchmark_framework_x/benchmark_framework_x.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockEmitter extends Mock implements StatsEmitter {
  MockEmitter();

  @override
  void emit(String testName, List<double> values) {
    for (int i = 0; i < values.length; i++) {
      expect(values[i] > 0.0, equals(true),
          reason:
              'Expected all values to be > 0.0, but values[$i]=${values[i]}');
    }
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
    final BenchmarkBaseX ebm = BenchmarkBaseX('empty', emitter: MockEmitter());
    ebm.report(warmUpInMillis: 1, minExerciseInMillis: 1);
  });
}
