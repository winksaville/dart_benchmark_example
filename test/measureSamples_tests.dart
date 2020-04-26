import 'package:stats/stats.dart' as st;
import 'package:intl/intl.dart';
import 'package:benchmark_example/benchmarkbasex.dart';
import 'package:test/test.dart';

class BenchmarkDelaySecs extends BenchmarkBaseX {
  BenchmarkDelaySecs(String name, double delaySecs) : super(name) {
    delayMicros = (delaySecs * 1e6).toInt();
  }

  int delayMicros;
  Stopwatch watch = Stopwatch();

  @override
  void run() {
    watch.reset();
    watch.start();
    while (watch.elapsedMicroseconds < delayMicros) {}
  }
}

void main() {
  test('measureSamples default', () {
    const BenchmarkBaseX bm = BenchmarkBaseX('one');

    final List<double> s = bm.measureSamples();

    expect(s, isNotNull);
    expect(s, isNotEmpty);

    // TODO(WINK): Add zero test in estimateInnerLoops_test
    void checker(double element) {
      //print('$element');
      expect(element > 0, isTrue);
    }

    s.forEach(checker);
    final st.Stats<double> stats = st.Stats<double>.fromData(s);
    print('${measurementToString(stats)}');
  });

  test('measureSamples expecting 1000 samples each > 100us', () {
    const double kDelay = 100e-6;
    final BenchmarkDelaySecs bm = BenchmarkDelaySecs('dm100', kDelay);

    final List<double> s = bm.measureSamples(samples: 1000);

    expect(s, isNotNull);
    expect(s.length == 1000, isTrue);

    for (int i = 0; i < s.length; i++) {
      expect(s[i] > kDelay, isTrue,
          reason: 'Error expecting s[$i]=${s[i]} > $kDelay, IT IS NOT');
    }
    final st.Stats<double> stats = st.Stats<double>.fromData(s);
    print('${measurementToString(stats)}');
  });
}

String measurementToString(st.Stats<double> stats) {
  final NumberFormat f6 = NumberFormat('#,##0.#E0');
  final NumberFormat f0 = NumberFormat('#,##0');
  const int pad = 9;
  return '{'
      'count: ${f0.format(stats.count)}, '
      'average: ${f6.format(stats.average).padLeft(pad)} s  '
      'min: ${f6.format(stats.min).padLeft(pad)} s  '
      'max: ${f6.format(stats.max).padLeft(pad)} s  '
      'median: ${f6.format(stats.median).padLeft(pad)} s  '
      'standardDeviation: ${f6.format(stats.standardDeviation).padLeft(pad)} s'
      '}';
}
