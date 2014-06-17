---
layout: default
title: "Spire. The miniboxed one."
newstitle: "Spire. The miniboxed one."
url: http://www.scaladays.org/#schedule/Miniboxing--Specialization-on-a-Diet
---

<!-- jekyll don't be stupid -->

The benchmarks for spire compiled with miniboxing are in! (generated from <a href="https://github.com/miniboxing/spire/tree/miniboxed" target="_blank">this branch</a>)

<b>So, why should you care about the miniboxing plugin? <a href="http://scaladays.org/#schedule/Miniboxing--Specialization-on-a-Diet" target="_blank">Join the ScalaDays talk to learn the three reasons!</a></b>

**ERRATA:** The benchmarking numbers were completely redone, after we found out we mixed the log files. The updated conclusions are more nuanced:

 * most benchmarks show miniboxing is close to specialization, even being faster in some cases
 * arrays do slow down miniboxing more than expected (10-20%) -- we will certainly look into this
 * in some cases generic is better than both specialization and miniboxing (`MapSemigroupBenchmarks`)
 * there are still 2 benchmarks miniboxing can't run, we'll be digging into those

Here are the numbers:

## FibBenchmarks

benchmark         | miniboxed(ns) | specialized (ns) | generic (ns)
------------------|---------------|------------------|--------------
       IntFibJava |             2 |                2 |             2
      IntFibScala |             2 |                2 |             2
        IntFibGen |            43 |                2 |           594
      LongFibJava |            68 |               68 |            70
     LongFibScala |            65 |               65 |            68
       LongFibGen |            66 |               66 |          1193
BigIntegerFibJava |         23149 |            23384 |         23847
 BigIntegerFibGen |         26402 |            26296 |         26614
   BigIntFibScala |         24114 |            24067 |         24130
     BigIntFibGen |         26056 |            26368 |         26424
    NaturalFibGen |         15116 |            15326 |         15133
         SpireFib |          6360 |             6382 |          6402

## Mo5Benchmarks

benchmark         | miniboxed(ms) | specialized (ms) | generic (ms)
------------------|---------------|------------------|--------------
            HBMo5 |          38.1 |             29.8 |          88.5
             MMo5 |          47.7 |             32.6 |         107.5

## PowBenchmarks

benchmark         | miniboxed(ms) | specialized (ms) | generic (ms)
------------------|---------------|------------------|--------------
     LongPowForInt|          1.90 |             1.89 |         1.94
   DoublePowForInt|         16.94 |            16.88 |        16.92
   BigIntPowForInt|         19.44 |            18.64 |        17.65
    LongPowForLong|          1.69 |             1.66 |         1.68
  DoublePowForLong|         16.76 |            16.86 |        16.84
  BigIntPowForLong|         23.05 |            22.63 |        22.70
DoublePowForDouble|         15.84 |            15.94 |        15.90

## ComplexAddBenchmarks

benchmark                | miniboxed(ms) | specialized (ms) | generic (ms)
-------------------------|---------------|------------------|--------------
      AddComplexesDirect |          4.19 |             3.68 |         7.69
     AddComplexesGeneric |          4.31 |             5.20 |         7.74
        AddFastComplexes |          1.56 |             1.57 |         1.55
  AddFloatComplexesBoxed |          2.44 |             2.42 |         2.25
AddFloatComplexesUnboxed |          1.58 |             1.58 |         1.58

## RexBenchmarks

pow  |         benchmark | miniboxed(us) | specialized (us) | generic (us)
-----|-------------------|---------------|------------------|--------------
 10  |            Direct |          45.5 |             45.8 |         47.9
 10  |           Generic |         229.6 |             57.9 |        396.4
 12  |            Direct |         152.8 |            111.5 |        170.3
 12  |           Generic |         704.8 |            156.4 |       1058.5
 14  |            Direct |         622.9 |            516.9 |        646.3
 14  |           Generic |        1253.0 |            531.4 |       3423.0
 16  |            Direct |        2076.0 |           2081.9 |       2723.9
 16  |           Generic |        4256.0 |           2024.4 |      12765.3
 18  |            Direct |        9499.6 |           9778.3 |       7361.9
 18  |           Generic |       17181.4 |           7720.6 |      48629.5

## MapSemigroupBenchmarks

mapSize | mapType|     benchmark  | miniboxed(us) | specialized (us) | generic (us)
--------|--------|----------------|---------------|------------------|--------------
      2 | random | AlgebirdMapAdd |          54.7 |             54.4 |         54.3
      2 | random |     BulkMapAdd |          53.8 |             54.6 |         54.3
      2 | random |       SpireAdd |          64.0 |             64.2 |         48.3
      2 | sparse | AlgebirdMapAdd |          69.7 |             51.9 |         74.0
      2 | sparse |     BulkMapAdd |          39.5 |             62.6 |         63.6
      2 | sparse |       SpireAdd |          55.5 |             49.5 |         48.5
      2 |  dense | AlgebirdMapAdd |          79.9 |             80.3 |         79.7
      2 |  dense |     BulkMapAdd |          80.3 |             78.8 |         80.0
      2 |  dense |       SpireAdd |          78.6 |             78.6 |         61.1
      4 | random | AlgebirdMapAdd |         616.5 |            697.4 |        618.8
      4 | random |     BulkMapAdd |         701.6 |            697.3 |        700.2
      4 | random |       SpireAdd |         695.3 |            629.2 |        694.2
      4 | sparse | AlgebirdMapAdd |         233.9 |            230.4 |        231.9
      4 | sparse |     BulkMapAdd |         220.3 |            221.5 |        218.7
      4 | sparse |       SpireAdd |         228.4 |            226.9 |        232.3
      4 |  dense | AlgebirdMapAdd |         145.4 |            129.9 |        124.7
      4 |  dense |     BulkMapAdd |         143.0 |            125.6 |        125.4
      4 |  dense |       SpireAdd |         184.8 |            181.0 |        183.6
      8 | random | AlgebirdMapAdd |         852.9 |            716.3 |        672.2
      8 | random |     BulkMapAdd |         852.5 |            865.1 |        676.5
      8 | random |       SpireAdd |         839.0 |            777.5 |        638.3
      8 | sparse | AlgebirdMapAdd |         439.5 |            450.1 |        400.8
      8 | sparse |     BulkMapAdd |         495.6 |            438.3 |        452.8
      8 | sparse |       SpireAdd |         411.9 |            424.2 |        379.2
      8 |  dense | AlgebirdMapAdd |         726.9 |            714.9 |        682.9
      8 |  dense |     BulkMapAdd |         690.9 |            735.9 |        633.4
      8 |  dense |       SpireAdd |         687.0 |            685.4 |        642.7
     16 | random | AlgebirdMapAdd |        1941.6 |           1934.1 |       1537.1
     16 | random |     BulkMapAdd |        2265.5 |           2086.5 |       1810.5
     16 | random |       SpireAdd |        1824.1 |           1821.7 |       1432.6
     16 | sparse | AlgebirdMapAdd |         893.9 |            896.9 |        743.9
     16 | sparse |     BulkMapAdd |         836.9 |           1014.0 |        844.6
     16 | sparse |       SpireAdd |         872.7 |            843.4 |        728.8
     16 |  dense | AlgebirdMapAdd |        1545.4 |           1537.7 |       1469.0
     16 |  dense |     BulkMapAdd |        1489.0 |           1531.5 |       1251.8
     16 |  dense |       SpireAdd |        1540.8 |           1508.1 |       1435.2
     32 | random | AlgebirdMapAdd |        5548.6 |           5582.2 |       4503.9
     32 | random |     BulkMapAdd |        5922.9 |           6023.3 |       4711.5
     32 | random |       SpireAdd |        5081.6 |           5820.2 |       4683.2
     32 | sparse | AlgebirdMapAdd |        2632.4 |           2588.1 |       2578.4
     32 | sparse |     BulkMapAdd |        2545.8 |           2473.0 |       2101.0
     32 | sparse |       SpireAdd |        2517.0 |           2412.9 |       2093.6
     32 |  dense | AlgebirdMapAdd |        5435.3 |           5296.6 |       4817.5
     32 |  dense |     BulkMapAdd |        5284.4 |           5051.2 |       4815.8
     32 |  dense |       SpireAdd |        5427.0 |           5232.9 |       4598.0
     64 | random | AlgebirdMapAdd |        9630.8 |          11037.0 |       8966.1
     64 | random |     BulkMapAdd |       10637.3 |          11466.4 |       8941.8
     64 | random |       SpireAdd |        9511.1 |           9381.2 |       8697.1
     64 | sparse | AlgebirdMapAdd |        7029.0 |           6747.8 |       6692.3
     64 | sparse |     BulkMapAdd |        6865.1 |           6906.3 |       6459.0
     64 | sparse |       SpireAdd |        6598.4 |           6426.2 |       6431.1
     64 |  dense | AlgebirdMapAdd |       10568.5 |          10139.1 |       9545.6
     64 |  dense |     BulkMapAdd |       10228.1 |          11001.8 |       9246.6
     64 |  dense |       SpireAdd |       10443.0 |          10217.1 |       9800.8

## GcdBenchmarks

benchmark        | miniboxed(ms) | specialized (ms) | generic (ms)
-----------------|---------------|------------------|--------------
XorEuclidGcdLong |          98.6 |             97.3 |        101.1
XorBinaryGcdLong |          41.3 |             41.4 |         42.7

## AddBenchmarks

benchmark               | miniboxed(us) | specialized (us) | generic (us)
------------------------|---------------|------------------|--------------
         AddIntsDirect  |          93.2 |             65.3 |         88.5
        AddIntsGeneric  |          92.7 |             88.2 |       2345.4
        AddLongsDirect  |          66.3 |             64.5 |         64.2
       AddLongsGeneric  |          67.0 |             64.3 |       2673.5
       AddFloatsDirect  |         197.2 |            194.3 |        193.2
      AddFloatsGeneric  |         200.5 |            192.2 |        615.1
      AddDoublesDirect  |         201.8 |            193.4 |        192.1
     AddDoublesGeneric  |         203.8 |            194.1 |        649.1
 AddMaybeDoublesDirect  |        5372.9 |           5166.9 |       5163.9
    AddComplexesDirect  |        1594.0 |           1596.9 |       3303.5
   AddComplexesGeneric  |        1400.0 |           2262.4 |       3340.2
      AddFastComplexes  |         648.3 |            652.2 |        650.2

## ArrayOrderBenchmarks

pow |         benchmark | miniboxed(ns) | specialized (ns) | generic (ns)
----|-------------------|---------------|------------------|--------------
  6 |        AddGeneric |          45.7 |             45.0 |       1070.8
  6 |       AddIndirect |          40.0 |             40.1 |        680.9
  6 |         AddDirect |          37.6 |             37.2 |         36.0
 10 |        AddGeneric |        5288.4 |            435.4 |       8169.6
 10 |       AddIndirect |        5118.1 |            441.7 |       8321.1
 10 |         AddDirect |         406.2 |            406.6 |        415.2
 14 |        AddGeneric |       76713.4 |           8568.7 |     281031.8
 14 |       AddIndirect |       77018.1 |           8624.7 |     382331.1
 14 |         AddDirect |        8184.1 |           8553.9 |       8705.4
 18 |        AddGeneric |     1389458.0 |         211852.0 |    4471017.1
 18 |       AddIndirect |     1386325.8 |         208735.3 |    4452107.9
 18 |         AddDirect |      207802.0 |         207519.9 |     206465.8

In case you're interested, [the **updated** raw execution logs are here](/graphs/spire/2014-06-16-spire-miniboxed.raw).
