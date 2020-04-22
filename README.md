Learn how to benchmark in Dart

The is a command line app allowing me to explore how to
do benchmarking with Dart.

# Help
```
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ dart bin/main.dart 
Error: expected command line options --spawn (-s) and or --direct (-d)
Usage: main.dart
-s, --spawn               
-d, --direct              
-W, --verboseWarmUp       
-E, --verboseExercise     
-w, --warmUpInMillis      (defaults to "250")
-e, --exerciseInMillis    (defaults to "2000")
-i, --innerLoops          (defaults to "10")
-l, --loops               (defaults to "5")
```

# Run

To run you must select either --spawn or --direct.
Spawn using Isolate.spawn to run the benchmark in a new isolate
for each loop, --loops.
```
$ dart bin/main.dart --spawn
spawn mesaurements: {count: 5, average:  0.006547 us  min:  0.006223 us  max:  0.007024 us  median:  0.006255 us  standardDeviation:  0.000376 us}
```

Note: I just noticed that running with -E has a lower standard
deviation but higher average. this might have to do with thermal
throttling, see below. I hadn't noticed that before because
I've always been use -E. Something to investigate.
```
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ dart bin/main.dart --spawn -E
time: 2.000000 s  loops: 27,701,752  elapsedTicks: 2,000,000,057  iter: 277,017,520  timePerInnerLoop: 0.072198 us  timePerIteraton: 0.007220 us
time: 2.000000 s  loops: 27,396,200  elapsedTicks: 2,000,000,065  iter: 273,962,000  timePerInnerLoop: 0.073003 us  timePerIteraton: 0.007300 us
time: 2.000000 s  loops: 27,522,746  elapsedTicks: 2,000,000,024  iter: 275,227,460  timePerInnerLoop: 0.072667 us  timePerIteraton: 0.007267 us
time: 2.000000 s  loops: 26,951,243  elapsedTicks: 2,000,000,044  iter: 269,512,430  timePerInnerLoop: 0.074208 us  timePerIteraton: 0.007421 us
time: 2.000000 s  loops: 27,653,372  elapsedTicks: 2,000,000,053  iter: 276,533,720  timePerInnerLoop: 0.072324 us  timePerIteraton: 0.007232 us
spawn mesaurements: {count: 5, average:  0.007288 us  min:  0.007220 us  max:  0.007421 us  median:  0.007267 us  standardDeviation:  0.000072 us}
```

# Lessons

Lesson 2: The measurements previously were in microsecs not milliseconds
so the precision wasn't nearly as bad as I thought.

Lesson 3: To raise the precision, i.e. lower the standard deviation, it
is critical that we increase the time spent in exercise() and have the
number of loops calling exerciseFunc in measureFor() be in the 100's or
1000's. With the default value of 10 in the original exercise function
the number of loops executed by measureFor() was about 30,000,000:

```
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ dart bin/main.dart --spawn -E -i 10 -l 8
time: 2.000000 s  loops: 28,490,012  elapsedTicks: 2,000,000,015  iter: 284,900,120  timePerInnerLoop: 0.070200 us  timePerIteraton: 0.007020 us
time: 2.000000 s  loops: 28,653,573  elapsedTicks: 2,000,000,032  iter: 286,535,730  timePerInnerLoop: 0.069799 us  timePerIteraton: 0.006980 us
time: 2.000000 s  loops: 28,655,438  elapsedTicks: 2,000,000,036  iter: 286,554,380  timePerInnerLoop: 0.069795 us  timePerIteraton: 0.006979 us
time: 2.000000 s  loops: 28,527,085  elapsedTicks: 2,000,000,012  iter: 285,270,850  timePerInnerLoop: 0.070109 us  timePerIteraton: 0.007011 us
time: 2.000000 s  loops: 32,039,707  elapsedTicks: 2,000,000,041  iter: 320,397,070  timePerInnerLoop: 0.062423 us  timePerIteraton: 0.006242 us
time: 2.000000 s  loops: 31,666,383  elapsedTicks: 2,000,000,042  iter: 316,663,830  timePerInnerLoop: 0.063158 us  timePerIteraton: 0.006316 us
time: 2.000000 s  loops: 28,522,554  elapsedTicks: 2,000,000,022  iter: 285,225,540  timePerInnerLoop: 0.070120 us  timePerIteraton: 0.007012 us
time: 2.000000 s  loops: 31,757,320  elapsedTicks: 2,000,000,013  iter: 317,573,200  timePerInnerLoop: 0.062978 us  timePerIteraton: 0.006298 us
spawn mesaurements: {count: 8, average:  0.006732 us  min:  0.006242 us  max:  0.007020 us  median:  0.006980 us  standardDeviation:  0.000347 us}
```

And the standard deviation is 399 pico seconds for the do nothing run()
function. At first blush that isn't too bad but watch what happens as
we increase the number of loops from 10 to 1,000,000. We see the standard
deviation reduced from 400ps to 2ps and the average reduced from 6,700ps to
282ps:
```
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ dart bin/main.dart --spawn -E -i 10 -l 8
time: 2.000000 s  loops: 28,493,715  elapsedTicks: 2,000,000,007  iter: 284,937,150  timePerInnerLoop: 0.070191 us  timePerIteraton: 0.007019 us
time: 2.000000 s  loops: 27,610,059  elapsedTicks: 2,000,000,062  iter: 276,100,590  timePerInnerLoop: 0.072437 us  timePerIteraton: 0.007244 us
time: 2.000000 s  loops: 31,915,582  elapsedTicks: 2,000,000,055  iter: 319,155,820  timePerInnerLoop: 0.062665 us  timePerIteraton: 0.006267 us
time: 2.000000 s  loops: 32,011,927  elapsedTicks: 2,000,000,033  iter: 320,119,270  timePerInnerLoop: 0.062477 us  timePerIteraton: 0.006248 us
time: 2.000000 s  loops: 31,615,797  elapsedTicks: 2,000,000,046  iter: 316,157,970  timePerInnerLoop: 0.063260 us  timePerIteraton: 0.006326 us
time: 2.000000 s  loops: 31,889,897  elapsedTicks: 2,000,000,030  iter: 318,898,970  timePerInnerLoop: 0.062716 us  timePerIteraton: 0.006272 us
time: 2.000000 s  loops: 30,988,676  elapsedTicks: 2,000,000,000  iter: 309,886,760  timePerInnerLoop: 0.064540 us  timePerIteraton: 0.006454 us
time: 2.000000 s  loops: 27,530,765  elapsedTicks: 2,000,000,056  iter: 275,307,650  timePerInnerLoop: 0.072646 us  timePerIteraton: 0.007265 us
spawn mesaurements: {count: 8, average:  0.006637 us  min:  0.006248 us  max:  0.007265 us  median:  0.006390 us  standardDeviation:  0.000427 us}
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ dart bin/main.dart --spawn -E -i 100 -l 8
time: 2.000000 s  loops: 16,628,605  elapsedTicks: 2,000,000,049  iter: 1,662,860,500  timePerInnerLoop: 0.120275 us  timePerIteraton: 0.001203 us
time: 2.000000 s  loops: 15,621,709  elapsedTicks: 2,000,000,028  iter: 1,562,170,900  timePerInnerLoop: 0.128027 us  timePerIteraton: 0.001280 us
time: 2.000000 s  loops: 15,644,201  elapsedTicks: 2,000,000,074  iter: 1,564,420,100  timePerInnerLoop: 0.127843 us  timePerIteraton: 0.001278 us
time: 2.000000 s  loops: 16,912,388  elapsedTicks: 2,000,000,107  iter: 1,691,238,800  timePerInnerLoop: 0.118257 us  timePerIteraton: 0.001183 us
time: 2.000000 s  loops: 15,668,669  elapsedTicks: 2,000,000,123  iter: 1,566,866,900  timePerInnerLoop: 0.127643 us  timePerIteraton: 0.001276 us
time: 2.000000 s  loops: 15,681,215  elapsedTicks: 2,000,000,079  iter: 1,568,121,500  timePerInnerLoop: 0.127541 us  timePerIteraton: 0.001275 us
time: 2.000000 s  loops: 17,079,620  elapsedTicks: 2,000,000,047  iter: 1,707,962,000  timePerInnerLoop: 0.117099 us  timePerIteraton: 0.001171 us
time: 2.000000 s  loops: 17,954,237  elapsedTicks: 2,000,000,100  iter: 1,795,423,700  timePerInnerLoop: 0.111394 us  timePerIteraton: 0.001114 us
spawn mesaurements: {count: 8, average:  0.001223 us  min:  0.001114 us  max:  0.001280 us  median:  0.001239 us  standardDeviation:  0.000060 us}
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ dart bin/main.dart --spawn -E -i 10000 -l 8
time: 2.000001 s  loops: 467,817  elapsedTicks: 2,000,001,136  iter: 4,678,170,000  timePerInnerLoop: 4.275178 us  timePerIteraton: 0.000428 us
time: 2.000000 s  loops: 467,943  elapsedTicks: 2,000,000,013  iter: 4,679,430,000  timePerInnerLoop: 4.274025 us  timePerIteraton: 0.000427 us
time: 2.000004 s  loops: 469,938  elapsedTicks: 2,000,003,998  iter: 4,699,380,000  timePerInnerLoop: 4.255889 us  timePerIteraton: 0.000426 us
time: 2.000009 s  loops: 470,118  elapsedTicks: 2,000,008,555  iter: 4,701,180,000  timePerInnerLoop: 4.254269 us  timePerIteraton: 0.000425 us
time: 2.000002 s  loops: 469,149  elapsedTicks: 2,000,001,509  iter: 4,691,490,000  timePerInnerLoop: 4.263041 us  timePerIteraton: 0.000426 us
time: 2.000003 s  loops: 465,658  elapsedTicks: 2,000,002,995  iter: 4,656,580,000  timePerInnerLoop: 4.295004 us  timePerIteraton: 0.000430 us
time: 2.000004 s  loops: 449,272  elapsedTicks: 2,000,003,557  iter: 4,492,720,000  timePerInnerLoop: 4.451654 us  timePerIteraton: 0.000445 us
time: 2.000004 s  loops: 469,495  elapsedTicks: 2,000,003,997  iter: 4,694,950,000  timePerInnerLoop: 4.259905 us  timePerIteraton: 0.000426 us
spawn mesaurements: {count: 8, average:  0.000429 us  min:  0.000425 us  max:  0.000445 us  median:  0.000427 us  standardDeviation:  0.000006 us}
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ dart bin/main.dart --spawn -E -i 1000000 -l 8
time: 2.000231 s  loops:  6,992  elapsedTicks: 2,000,231,149  iter: 6,992,000,000  timePerInnerLoop: 286.074249 us  timePerIteraton: 0.000286 us
time: 2.000152 s  loops:  7,101  elapsedTicks: 2,000,151,951  iter: 7,101,000,000  timePerInnerLoop: 281.671870 us  timePerIteraton: 0.000282 us
time: 2.000047 s  loops:  7,113  elapsedTicks: 2,000,047,095  iter: 7,113,000,000  timePerInnerLoop: 281.181934 us  timePerIteraton: 0.000281 us
time: 2.000021 s  loops:  7,116  elapsedTicks: 2,000,021,110  iter: 7,116,000,000  timePerInnerLoop: 281.059740 us  timePerIteraton: 0.000281 us
time: 2.000172 s  loops:  7,098  elapsedTicks: 2,000,172,352  iter: 7,098,000,000  timePerInnerLoop: 281.793794 us  timePerIteraton: 0.000282 us
time: 2.000217 s  loops:  7,095  elapsedTicks: 2,000,216,555  iter: 7,095,000,000  timePerInnerLoop: 281.919176 us  timePerIteraton: 0.000282 us
time: 2.000238 s  loops:  7,088  elapsedTicks: 2,000,238,164  iter: 7,088,000,000  timePerInnerLoop: 282.200644 us  timePerIteraton: 0.000282 us
time: 2.000039 s  loops:  7,110  elapsedTicks: 2,000,038,713  iter: 7,110,000,000  timePerInnerLoop: 281.299397 us  timePerIteraton: 0.000281 us
spawn mesaurements: {count: 8, average:  0.000282 us  min:  0.000281 us  max:  0.000286 us  median:  0.000282 us  standardDeviation:  0.000002 us}
```

You may have noticed that I'm useing --spawn dispatching of the
benchmark. I do this because the data is more consistent on my
linux desktop machine. This appears to have to do with the CPU
temperature raising and the CPU clock being throttled:
```
wink@wink-desktop:~/prgs/dart/benchmark_example (master)
$ dart bin/main.dart --direct -E -i 1000000 -l 8
time: 2.000358 s  loops:  6,759  elapsedTicks: 2,000,357,599  iter: 6,759,000,000  timePerInnerLoop: 295.954668 us  timePerIteraton: 0.000296 us
time: 2.000191 s  loops:  6,850  elapsedTicks: 2,000,191,473  iter: 6,850,000,000  timePerInnerLoop: 291.998755 us  timePerIteraton: 0.000292 us
time: 2.000372 s  loops:  5,143  elapsedTicks: 2,000,372,239  iter: 5,143,000,000  timePerInnerLoop: 388.950465 us  timePerIteraton: 0.000389 us
time: 2.000241 s  loops:  4,693  elapsedTicks: 2,000,240,747  iter: 4,693,000,000  timePerInnerLoop: 426.217930 us  timePerIteraton: 0.000426 us
time: 2.000325 s  loops:  4,702  elapsedTicks: 2,000,325,116  iter: 4,702,000,000  timePerInnerLoop: 425.420059 us  timePerIteraton: 0.000425 us
time: 2.000094 s  loops:  4,662  elapsedTicks: 2,000,094,404  iter: 4,662,000,000  timePerInnerLoop: 429.020679 us  timePerIteraton: 0.000429 us
time: 2.000171 s  loops:  4,672  elapsedTicks: 2,000,171,497  iter: 4,672,000,000  timePerInnerLoop: 428.118899 us  timePerIteraton: 0.000428 us
time: 2.000360 s  loops:  4,724  elapsedTicks: 2,000,360,127  iter: 4,724,000,000  timePerInnerLoop: 423.446259 us  timePerIteraton: 0.000423 us
direct mesaurements:  {count: 8, average:  0.000389 us  min:  0.000292 us  max:  0.000429 us  median:  0.000424 us  standardDeviation:  0.000056 us}
```
