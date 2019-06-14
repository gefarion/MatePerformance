#!/bin/bash
SCRIPT_PATH=`dirname $0`

SOM_DIR="$SCRIPT_PATH/../Setup/Implementations/TruffleMate/Standard"

function runAWFBenchmark {
  BENCHSDIR="$SCRIPT_PATH/../Setup/Benchmarks/AreWeFast/benchmarks/SOM"
  CORELIBDIR="$SCRIPT_PATH/../Setup/Benchmarks/Mate/Smalltalk"
  BENCH=$1
  IT=$2
  HARNESS="$SOM_DIR/som -cp $BENCHSDIR:$BENCHSDIR/CD:$BENCHSDIR/DeltaBlue:$BENCHSDIR/GraphSearch:$BENCHSDIR/Havlak:$BENCHSDIR/Json:$BENCHSDIR/LanguageFeatures:$BENCHSDIR/NBody:$BENCHSDIR/Richards:$CORELIBDIR \
  -dm -Ddm.metrics=$SCRIPT_PATH/../MetricResults/$BENCH-$IT \
    -G Harness"
  echo $HARNESS $@
  $HARNESS $@
}

function runOwnBenchmark {
  BENCHSDIR="$SCRIPT_PATH/../Setup/Benchmarks/Mate"
  BENCH=$1
  IT=$2
  HARNESS="$SOM_DIR/som -cp $BENCHSDIR/Examples/Benchmarks/:$BENCHSDIR/Examples/Benchmarks/CD:$BENCHSDIR/Examples/Benchmarks/DeltaBlue:$BENCHSDIR/Examples/Benchmarks/GraphSearch:$BENCHSDIR/Examples/Benchmarks/Havlak:$BENCHSDIR/Examples/Benchmarks/Json:$BENCHSDIR/Examples/Benchmarks/LanguageFeatures:$BENCHSDIR/Examples/Benchmarks/NBody:$BENCHSDIR/Examples/Benchmarks/Richards:$BENCHSDIR/Smalltalk \
  -dm -Ddm.metrics=$SCRIPT_PATH/../MetricResults/$BENCH-$IT \
    -G BenchmarkHarness"
  echo $HARNESS $@
  $HARNESS $@
}


runAWFBenchmark CD 2 1000        &
runAWFBenchmark Havlak 2 1       &

runAWFBenchmark Mandelbrot 2 500      &
runAWFBenchmark DeltaBlue  2 12000    &
runAWFBenchmark Richards   2 100      &
runAWFBenchmark Json       2 100      &
runAWFBenchmark Bounce     2 1500     &
runAWFBenchmark List       2 1500     &
runAWFBenchmark NBody      2 250000   &
runAWFBenchmark Permute    2 1000     & 
runAWFBenchmark Queens     2 1000     &
runAWFBenchmark Sieve      2 3000     &
runAWFBenchmark Storage    2 1000     &
runAWFBenchmark Towers     2 600      &
runAWFBenchmark GraphSearch 2 20      &

runAWFBenchmark CD 3 1000             &
runAWFBenchmark Havlak 3 1            &

runAWFBenchmark Mandelbrot 3 500
runAWFBenchmark DeltaBlue  3 12000    &
runAWFBenchmark Richards   3 100      &
runAWFBenchmark Json       3 100      &
runAWFBenchmark Bounce     3 1500     &
runAWFBenchmark List       3 1500     &
runAWFBenchmark NBody      3 250000   &
runAWFBenchmark Permute    3 1000     &
runAWFBenchmark Queens     3 1000     &
runAWFBenchmark Sieve      3 3000     &
runAWFBenchmark Storage    3 1000     &
runAWFBenchmark Towers     3 600      &
runAWFBenchmark GraphSearch 3 20      &

runOwnBenchmark Fannkuch     2 0 7    &
runOwnBenchmark Fibonacci    2 0 100  &
runOwnBenchmark Dispatch     2 0 1000 &
runOwnBenchmark Loop         2 0 1000 &
runOwnBenchmark Recurse      2 0 100  &
runOwnBenchmark IntegerLoop  2 0 1000 &
runOwnBenchmark FieldLoop    2 0 100  &

runOwnBenchmark QuickSort  2 0 200  &
runOwnBenchmark TreeSort   2 0 200  &
runOwnBenchmark BubbleSort 2 0 200  &

runOwnBenchmark Fannkuch     3 0 7      &
runOwnBenchmark Fibonacci    3 0 100   &
runOwnBenchmark Dispatch     3 0 1000  &
runOwnBenchmark Loop         3 0 1000  &
runOwnBenchmark Recurse      3 0 100   &
runOwnBenchmark IntegerLoop  3 0 1000  &
runOwnBenchmark FieldLoop    3 0 100   &

runOwnBenchmark QuickSort  3 0 200 &
runOwnBenchmark TreeSort   3 0 200 & 
runOwnBenchmark BubbleSort 3 0 200 &


#runOwnBenchmark PageRank    2 0 1
