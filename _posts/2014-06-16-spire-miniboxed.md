---
layout: default
title: "Spire. The miniboxed one."
newstitle: "Spire. The miniboxed one."
url: http://www.scaladays.org/#schedule/Miniboxing--Specialization-on-a-Diet
---

<!-- jekyll don't be stupid -->

The benchmarks for spire compiled with miniboxing are in! (generated from <a href="https://github.com/miniboxing/spire/tree/miniboxed" target="_blank">this branch</a>)
They show the miniboxed code is within a +/-5% margin compared to specialization, sometimes even beating specialization at its own game!

<b>So, why should you care about the miniboxing plugin? <a href="http://scaladays.org/#schedule/Miniboxing--Specialization-on-a-Diet" target="_blank">Join the ScalaDays talk to learn the three reasons!</a></b>


## ArrayOrderBenchmarks

pow |  benchmark  | miniboxed (ns) | specialized (ns) |    generic (ns)
----|-------------|----------------|------------------|----------------
  6 |  AddGeneric |             45 |               45 |             625
  6 | AddIndirect |             40 |               40 |             699
  6 |   AddDirect |             41 |               41 |              42
 10 |  AddGeneric |            413 |              420 |            8349
 10 | AddIndirect |            447 |              446 |            8836
 10 |   AddDirect |            425 |              426 |             425
 14 |  AddGeneric |           8682 |             8527 |          280648
 14 | AddIndirect |           8772 |             8630 |          285115
 14 |   AddDirect |           8516 |             8444 |            8485
 18 |  AddGeneric |         214928 |           213000 |         4549277
 18 | AddIndirect |         213492 |           212635 |         6210298
 18 |   AddDirect |         213408 |           212611 |          211514

## ComplexAddBenchmarks

benchmark                | miniboxed (ms) | specialized (ms) |    generic (ms)
-------------------------|----------------|------------------|----------------
      AddComplexesDirect |           3.82 |             3.67 |            7.54
     AddComplexesGeneric |           5.23 |             5.19 |            7.74
        AddFastComplexes |           1.61 |             1.58 |            1.58
  AddFloatComplexesBoxed |           2.50 |             2.47 |            2.29
AddFloatComplexesUnboxed |           1.68 |             1.60 |            1.58

## RexBenchmarks

pow  | benchmark | miniboxed (ms) | specialized (ms) |    generic (ms)
-----|-----------|----------------|------------------|----------------
 10  |  Direct   |             46 |               42 |              43
 10  | Generic   |             57 |               57 |             386
 12  |  Direct   |            115 |              116 |             113
 12  | Generic   |            168 |              156 |             984
 14  |  Direct   |            356 |              358 |             353
 14  | Generic   |            537 |              530 |            3291
 16  |  Direct   |           1316 |             1325 |            1319
 16  | Generic   |           2059 |             2061 |           12370
 18  |  Direct   |           5084 |             5113 |            5090
 18  | Generic   |           7702 |             7738 |           46307

In case you're interested, [the raw execution logs are here](2014-06-16-spire-miniboxed.raw).