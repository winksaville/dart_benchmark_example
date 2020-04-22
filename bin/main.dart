import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:benchmark_example/benchmark_example.dart';
import 'package:stats/stats.dart' as st;

class DoMeasurementArgs {
  DoMeasurementArgs(this.sendPort, this.runTimeInMilliSecs, this.loop);

  SendPort sendPort;
  int runTimeInMilliSecs;
  int loop;
}

Future<void> main(List<String> arguments) async {
  if (arguments.length != 2) {
    print('Usage: main.dart <runTimeInMilliSecs> <loops>');
    exit(1);
  }
  final int runTimeInMilliSecs = int.parse(arguments[0]);
  final int loops = int.parse(arguments[1]);

  List<double> measurements = <double>[];
  st.Stats<double> stats;

  for (int i = 0; i < loops; i++) {
      final ReceivePort receivePort = ReceivePort();

      final DoMeasurementArgs doma = DoMeasurementArgs(receivePort.sendPort, runTimeInMilliSecs, i);
      final Isolate isolate = await Isolate.spawn(doMeasurement, doma);

      await receivePort.first.then((dynamic value) {
        if (value is double) {
          measurements.add(value);
        }
      });

      isolate.kill();
  }
  stats = st.Stats<double>.fromData(measurements);
  print('spawned mesaurements: ${stats.withPrecision(6)}');

  measurements = <double>[];
  for (int i = 0; i < loops; i++) {
    measurements.add(doMeasurement(DoMeasurementArgs(null, runTimeInMilliSecs, i)));
  }
  stats = st.Stats<double>.fromData(measurements);
  print('direct mesaurements:  ${stats.withPrecision(6)}');

  exit(0);
}

double doMeasurement(DoMeasurementArgs doma) {
  const EmptyBenchmark bmark = EmptyBenchmark('empty');
  final double measurement = bmark.measureX(minRunInMillis: doma.runTimeInMilliSecs);
  if (doma.sendPort != null) {
    doma.sendPort.send(measurement);
  }
  stdout.write('${doma.loop}: ${measurement.toString().padLeft(20)}\r');
  return measurement;
}
