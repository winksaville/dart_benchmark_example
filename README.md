Learn how to benchmark in Dart

The is a command line app allowing me to explore how to
do benchmarking with Dart.

# Help
```
$ dart bin/main.dart -h
Usage: main.dart
-h, --help                
-s, --spawn               
-d, --direct              
-W, --verboseWarmUp       
-E, --verboseExercise     
-w, --warmUpInMillis      (defaults to "250")
-e, --exerciseInMillis    (defaults to "2000")
-c, --sampleCount         (defaults to "100")
-l, --loops               (defaults to "5")
```

# Run

If no parameters are given we run a default `report`
```
$ dart bin/main.dart 
report:  {count: 100, average: 281.317ps  min: 278.067ps  max: 305.537ps  median: 279.643ps  standardDeviation: 4.691ps}
```

Alternatively you can use the --spawn (-s) and or --direct to
which will use the pased values or defaults if none given.

Here we run `--spawn` with 3 loops:
```
$ dart bin/main.dart --spawn -l 3
spawn:   {count: 100, average: 281.486ps  min: 278.963ps  max: 295.459ps  median: 280.765ps  standardDeviation: 2.805ps}
spawn:   {count: 100, average: 282.081ps  min: 278.961ps  max: 293.523ps  median: 281.379ps  standardDeviation: 2.342ps}
spawn:   {count: 100, average: 282.287ps  min: 278.647ps  max: 303.472ps  median: 281.060ps  standardDeviation: 4.207ps}
```

Here we run `--spawn` and `--direct` using the short options:
Notice that `direct` has a higher max and standardDeviation!
```
$ dart bin/main.dart -sd
spawn:   {count: 100, average: 283.061ps  min: 278.713ps  max: 353.000ps  median: 281.520ps  standardDeviation: 7.839ps}
spawn:   {count: 100, average: 282.954ps  min: 278.375ps  max: 320.991ps  median: 280.388ps  standardDeviation: 7.169ps}
spawn:   {count: 100, average: 281.565ps  min: 278.687ps  max: 304.383ps  median: 280.747ps  standardDeviation: 3.626ps}
spawn:   {count: 100, average: 280.625ps  min: 278.255ps  max: 292.101ps  median: 280.145ps  standardDeviation: 1.965ps}
spawn:   {count: 100, average: 286.866ps  min: 278.646ps  max: 380.121ps  median: 285.668ps  standardDeviation: 11.501ps}
direct:  {count: 100, average: 310.792ps  min: 278.462ps  max: 399.408ps  median: 306.723ps  standardDeviation: 25.222ps}
direct:  {count: 100, average: 303.227ps  min: 278.471ps  max: 377.560ps  median: 298.421ps  standardDeviation: 24.306ps}
direct:  {count: 100, average: 310.002ps  min: 278.532ps  max: 381.880ps  median: 307.436ps  standardDeviation: 24.154ps}
direct:  {count: 100, average: 308.014ps  min: 279.222ps  max: 374.938ps  median: 303.987ps  standardDeviation: 24.466ps}
direct:  {count: 100, average: 315.731ps  min: 279.614ps  max: 389.362ps  median: 316.107ps  standardDeviation: 25.557ps}
```

This happens even if both aren't run back to back. I installed
psensor on my Linux box and notice that in the direct mode the
tempature increases significantly where as the spawn mode is
much less. I believe this is because in direct everything is
running on one core, but in spawn the kernel is choosing a
different core each time thus spreading out the load.

```
$ dart bin/main.dart -d -l 10
direct:  {count: 100, average: 324.406ps  min: 278.093ps  max: 479.291ps  median: 307.389ps  standardDeviation: 51.204ps}
direct:  {count: 100, average: 311.920ps  min: 278.641ps  max: 438.658ps  median: 303.228ps  standardDeviation: 36.879ps}
direct:  {count: 100, average: 319.491ps  min: 278.740ps  max: 463.709ps  median: 307.937ps  standardDeviation: 40.831ps}
direct:  {count: 100, average: 311.794ps  min: 278.749ps  max: 430.259ps  median: 307.884ps  standardDeviation: 29.149ps}
direct:  {count: 100, average: 318.468ps  min: 278.734ps  max: 455.779ps  median: 309.504ps  standardDeviation: 38.723ps}
direct:  {count: 100, average: 311.851ps  min: 278.102ps  max: 493.778ps  median: 287.185ps  standardDeviation: 45.961ps}
direct:  {count: 100, average: 337.176ps  min: 278.104ps  max: 448.301ps  median: 326.294ps  standardDeviation: 55.423ps}
direct:  {count: 100, average: 326.438ps  min: 278.657ps  max: 495.761ps  median: 307.495ps  standardDeviation: 52.121ps}
direct:  {count: 100, average: 330.775ps  min: 278.648ps  max: 523.814ps  median: 307.232ps  standardDeviation: 55.159ps}
direct:  {count: 100, average: 331.734ps  min: 278.788ps  max: 474.371ps  median: 316.882ps  standardDeviation: 52.023ps}

$ dart bin/main.dart -s -l 10
spawn:   {count: 100, average: 284.843ps  min: 279.131ps  max: 327.505ps  median: 282.189ps  standardDeviation: 7.351ps}
spawn:   {count: 100, average: 281.260ps  min: 278.654ps  max: 303.439ps  median: 280.493ps  standardDeviation: 3.361ps}
spawn:   {count: 100, average: 281.982ps  min: 278.106ps  max: 316.634ps  median: 280.791ps  standardDeviation: 4.959ps}
spawn:   {count: 100, average: 281.117ps  min: 278.652ps  max: 293.950ps  median: 280.395ps  standardDeviation: 2.454ps}
spawn:   {count: 100, average: 281.459ps  min: 278.664ps  max: 292.817ps  median: 281.126ps  standardDeviation: 2.189ps}
spawn:   {count: 100, average: 282.303ps  min: 278.978ps  max: 307.071ps  median: 281.663ps  standardDeviation: 3.274ps}
spawn:   {count: 100, average: 289.569ps  min: 278.852ps  max: 462.471ps  median: 287.414ps  standardDeviation: 18.444ps}
spawn:   {count: 100, average: 281.189ps  min: 278.653ps  max: 295.061ps  median: 280.337ps  standardDeviation: 2.580ps}
spawn:   {count: 100, average: 281.473ps  min: 278.622ps  max: 288.264ps  median: 280.748ps  standardDeviation: 2.202ps}
spawn:   {count: 100, average: 282.409ps  min: 278.998ps  max: 296.446ps  median: 281.443ps  standardDeviation: 2.852ps}
```

Another solution is to lower the `--exerciseInMillis`, but then
the measurements aren't as good but less so with `--direct`:
```
$ dart bin/main.dart -d -l 10 --exerciseInMillis 20
direct:  {count: 100, average: 295.053ps  min: 278.104ps  max: 591.271ps  median: 294.468ps  standardDeviation: 34.659ps}
direct:  {count: 100, average: 278.967ps  min: 278.092ps  max: 299.603ps  median: 278.102ps  standardDeviation: 3.422ps}
direct:  {count: 100, average: 278.829ps  min: 278.091ps  max: 306.142ps  median: 278.101ps  standardDeviation: 3.898ps}
direct:  {count: 100, average: 284.393ps  min: 278.100ps  max: 514.303ps  median: 278.110ps  standardDeviation: 25.116ps}
direct:  {count: 100, average: 282.645ps  min: 278.091ps  max: 389.059ps  median: 278.103ps  standardDeviation: 13.639ps}
direct:  {count: 100, average: 284.220ps  min: 278.092ps  max: 556.219ps  median: 278.105ps  standardDeviation: 37.527ps}
direct:  {count: 100, average: 281.841ps  min: 278.091ps  max: 345.697ps  median: 278.104ps  standardDeviation: 10.830ps}
direct:  {count: 100, average: 278.856ps  min: 278.099ps  max: 307.662ps  median: 278.111ps  standardDeviation: 4.148ps}
direct:  {count: 100, average: 283.290ps  min: 278.092ps  max: 521.783ps  median: 278.101ps  standardDeviation: 28.834ps}
direct:  {count: 100, average: 280.950ps  min: 278.091ps  max: 430.591ps  median: 278.102ps  standardDeviation: 15.958ps}
wink@wink-desktop:~/prgs/dart/dart_benchmark_framework_x (WIP)
$ dart bin/main.dart -s -l 10 --exerciseInMillis 20
spawn:   {count: 100, average: 297.456ps  min: 278.113ps  max: 407.501ps  median: 303.403ps  standardDeviation: 16.137ps}
spawn:   {count: 100, average: 290.193ps  min: 278.090ps  max: 573.810ps  median: 278.102ps  standardDeviation: 44.719ps}
spawn:   {count: 100, average: 288.099ps  min: 278.093ps  max: 556.299ps  median: 278.104ps  standardDeviation: 38.894ps}
spawn:   {count: 100, average: 285.013ps  min: 278.090ps  max: 557.983ps  median: 278.104ps  standardDeviation: 28.771ps}
spawn:   {count: 100, average: 285.630ps  min: 278.096ps  max: 558.034ps  median: 278.109ps  standardDeviation: 29.067ps}
spawn:   {count: 100, average: 747.872ps  min: 307.805ps  max: 20.053ns  median: 308.484ps  standardDeviation: 2.569ns}
spawn:   {count: 100, average: 285.642ps  min: 278.091ps  max: 435.651ps  median: 278.102ps  standardDeviation: 22.140ps}
spawn:   {count: 100, average: 285.371ps  min: 278.093ps  max: 558.086ps  median: 278.107ps  standardDeviation: 29.733ps}
spawn:   {count: 100, average: 322.018ps  min: 303.387ps  max: 732.545ps  median: 303.402ps  standardDeviation: 71.026ps}
spawn:   {count: 100, average: 287.471ps  min: 278.092ps  max: 558.005ps  median: 278.107ps  standardDeviation: 29.553ps}
```
