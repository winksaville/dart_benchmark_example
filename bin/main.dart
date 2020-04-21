import 'package:benchmark_example/benchmark_example.dart';

void main(List<String> arguments) {
  const EmptyBenchmark bmark = EmptyBenchmark('empty');
  print('EmptyBenchmark report:');
  bmark.report();
}
