Learn how to benchmark in Dart

Lesson 1: Currently BenchmarkBaseX doesn't produce results with enough
preceision to reliably detect changes in code which are less than X.
At the moment I'm going to declare X to be the **penultimate** maximum of
the standard deviation or about 1 to 2ms.

Basically this isn't good enough and all these runs took 11.5 hrs or
6.25 hrs if we choose just direct or spawned.

spawned: min: 71.3283ms max: 83.9484ms(134.821) minavg: 72.8615  maxavg: 76.5544(81.9310)
direct:  min: 71.3355ms max: 80.9694ms          minavg: 72.2415  maxavg: 76.8675

Averages
```
    Spawn     Spawn less outlier    Direct
     72.862      72.862             74.898
     73.375      73.375             72.242
     81.931      73.289             76.868
     73.289      73.238             72.361
     73.238      76.554             73.739
     76.554      73.078             72.298
     73.078      73.223             73.942
     73.223      73.531             74.521
     73.531      74.355             72.730
     74.355                         72.459
    --------------------------------------
avg: 74.544ms    73.723ms           73.606ms
```

Standard deviations
```
    Spawn     Spawn less outlier    Direct
     1.459        1.459              0.183
     1.738        1.738              0.197
    17.647        1.634              0.810
     1.634        1.757              0.235
     1.757        1.206              0.250
     1.206        1.435              0.375
     1.435        1.672              0.951
     1.672        1.641              0.805
     1.641        1.727              1.143
     1.727                           1.647
    --------------------------------------
avg: 3.191ms      1.585ms            0.660ms
```

Raw data
```
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ time for i in {1..10}; do time dart bin/main.dart 2000 1000; done
spawned mesaurements: {count: 1000, average: 0.0728615, min: 0.0713738, max: 0.0839484, median: 0.0724018, standardDeviation: 0.001458840}
direct mesaurements:  {count: 1000, average: 0.0748984, min: 0.0734090, max: 0.0767000, median: 0.0748673, standardDeviation: 0.000182698}

real	70m23.267s
user	70m39.299s
sys	0m5.974s
spawned mesaurements: {count: 1000, average: 0.0733749, min: 0.0713484, max: 0.0797478, median: 0.0728643, standardDeviation: 0.001737770}
direct mesaurements:  {count: 1000, average: 0.0722415, min: 0.0717987, max: 0.0740906, median: 0.0722193, standardDeviation: 0.000197311}

real	70m23.230s
user	70m39.170s
sys	0m6.016s
spawned mesaurements: {count: 1000, average: 0.0819310, min: 0.0715991, max: 0.1348210, median: 0.0744811, standardDeviation: 0.017646500}
direct mesaurements:  {count: 1000, average: 0.0768675, min: 0.0763241, max: 0.0809694, median: 0.0765418, standardDeviation: 0.000809650}

real	70m23.798s
user	70m40.173s
sys	0m5.918s
spawned mesaurements: {count: 1000, average: 0.0732885, min: 0.0713283, max: 0.0798178, median: 0.0730300, standardDeviation: 0.001633690}
direct mesaurements:  {count: 1000, average: 0.0723610, min: 0.0718921, max: 0.0744755, median: 0.0723115, standardDeviation: 0.000235367}

real	70m23.135s
user	70m38.951s
sys	0m6.131s
spawned mesaurements: {count: 1000, average: 0.0732383, min: 0.0713420, max: 0.0800241, median: 0.0725068, standardDeviation: 0.001756870}
direct mesaurements:  {count: 1000, average: 0.0737387, min: 0.0731032, max: 0.0760107, median: 0.0736698, standardDeviation: 0.000250369}

real	70m22.893s
user	70m38.701s
sys	0m5.721s
spawned mesaurements: {count: 1000, average: 0.0765544, min: 0.0752545, max: 0.0839047, median: 0.0761749, standardDeviation: 0.001205950}
direct mesaurements:  {count: 1000, average: 0.0722977, min: 0.0717504, max: 0.0773372, median: 0.0722014, standardDeviation: 0.000374994}

real	70m23.065s
user	70m38.998s
sys	0m5.750s
spawned mesaurements: {count: 1000, average: 0.0730777, min: 0.071345, max: 0.07892870, median: 0.0726733, standardDeviation: 0.001434790}
direct mesaurements:  {count: 1000, average: 0.0739421, min: 0.0731196, max: 0.0779211, median: 0.0736554, standardDeviation: 0.000951186}

real	70m22.914s
user	70m38.567s
sys	0m5.904s
spawned mesaurements: {count: 1000, average: 0.0732230, min: 0.0715114, max: 0.0812058, median: 0.0726269, standardDeviation: 0.001671680}
direct mesaurements:  {count: 1000, average: 0.0745207, min: 0.0740683, max: 0.0788120, median: 0.0742213, standardDeviation: 0.000804785}

real	70m23.218s
user	70m39.177s
sys	0m5.886s
spawned mesaurements: {count: 1000, average: 0.0735312, min: 0.0716955, max: 0.0801934, median: 0.0729409, standardDeviation: 0.001641000}
direct mesaurements:  {count: 1000, average: 0.0727296, min: 0.0718449, max: 0.0783213, median: 0.0723669, standardDeviation: 0.001143410}

real	70m23.033s
user	70m38.503s
sys	0m6.164s
spawned mesaurements: {count: 1000, average: 0.0743552, min: 0.0713925, max: 0.0804364, median: 0.0737159, standardDeviation: 0.001727300}
direct mesaurements:  {count: 1000, average: 0.0724592, min: 0.0713355, max: 0.0782232, median: 0.0718451, standardDeviation: 0.001647050}

real	70m23.433s
user	70m39.387s
sys	0m6.037s

real	703m51.986s
user	706m30.927s
sys	0m59.502s
```

Here is an example that that took 1min and produced similar results:
```
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ time for i in {1..10}; do time dart bin/main.dart 200 10; done
spawned mesaurements: {count: 10, average: 0.0715702, min: 0.0706508, max: 0.0740065, median: 0.0711108, standardDeviation: 0.00100427}
direct mesaurements:  {count: 10, average: 0.0736336, min: 0.0733089, max: 0.0739851, median: 0.0736901, standardDeviation: 0.000222118}

real	0m6.418s
user	0m6.687s
sys	0m0.112s
spawned mesaurements: {count: 10, average: 0.071522, min: 0.0707645, max: 0.0720146, median: 0.0716401, standardDeviation: 0.000409629}
direct mesaurements:  {count: 10, average: 0.073313, min: 0.0725132, max: 0.0748748, median: 0.0728286, standardDeviation: 0.000828974}

real	0m6.403s
user	0m6.699s
sys	0m0.080s
spawned mesaurements: {count: 10, average: 0.0737269, min: 0.0705701, max: 0.0771419, median: 0.0732883, standardDeviation: 0.00194909}
direct mesaurements:  {count: 10, average: 0.0738795, min: 0.0720482, max: 0.0788471, median: 0.073662, standardDeviation: 0.00179138}

real	0m6.426s
user	0m6.699s
sys	0m0.119s
spawned mesaurements: {count: 10, average: 0.0731409, min: 0.0715146, max: 0.075133, median: 0.0731578, standardDeviation: 0.000830966}
direct mesaurements:  {count: 10, average: 0.0723125, min: 0.0721231, max: 0.0727562, median: 0.0723028, standardDeviation: 0.00016626}

real	0m6.409s
user	0m6.691s
sys	0m0.096s
spawned mesaurements: {count: 10, average: 0.0713942, min: 0.0701263, max: 0.0753787, median: 0.0708006, standardDeviation: 0.00165241}
direct mesaurements:  {count: 10, average: 0.0706818, min: 0.0700512, max: 0.0718031, median: 0.0704246, standardDeviation: 0.000613779}

real	0m6.401s
user	0m6.661s
sys	0m0.106s
spawned mesaurements: {count: 10, average: 0.072048, min: 0.0706183, max: 0.0744843, median: 0.0718139, standardDeviation: 0.00127184}
direct mesaurements:  {count: 10, average: 0.0729631, min: 0.0723154, max: 0.0744815, median: 0.0725709, standardDeviation: 0.000718046}

real	0m6.402s
user	0m6.689s
sys	0m0.083s
spawned mesaurements: {count: 10, average: 0.0713472, min: 0.0704297, max: 0.0756114, median: 0.0707141, standardDeviation: 0.00148819}
direct mesaurements:  {count: 10, average: 0.0723701, min: 0.071794, max: 0.0760252, median: 0.0719044, standardDeviation: 0.00123149}

real	0m6.404s
user	0m6.685s
sys	0m0.096s
spawned mesaurements: {count: 10, average: 0.0738619, min: 0.073447, max: 0.0750071, median: 0.0737868, standardDeviation: 0.000433518}
direct mesaurements:  {count: 10, average: 0.0698915, min: 0.0693591, max: 0.0708234, median: 0.0699151, standardDeviation: 0.000388844}

real	0m6.406s
user	0m6.673s
sys	0m0.090s
spawned mesaurements: {count: 10, average: 0.0734611, min: 0.0708402, max: 0.0753292, median: 0.0735808, standardDeviation: 0.00160857}
direct mesaurements:  {count: 10, average: 0.0697972, min: 0.0695612, max: 0.0701205, median: 0.0697697, standardDeviation: 0.000196482}

real	0m6.403s
user	0m6.674s
sys	0m0.097s
spawned mesaurements: {count: 10, average: 0.0737495, min: 0.0728399, max: 0.0767808, median: 0.073266, standardDeviation: 0.00115453}
direct mesaurements:  {count: 10, average: 0.0718126, min: 0.070406, max: 0.0732368, median: 0.0717298, standardDeviation: 0.000653855}

real	0m6.401s
user	0m6.646s
sys	0m0.126s

real	1m4.074s
user	1m6.804s
sys	0m1.007s
```
