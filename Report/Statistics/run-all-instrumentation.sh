#!/bin/bash
SCRIPT_PATH=`dirname $0`

if [ -x /usr/libexec/java_home ]   # usually on OS X, this tool is available
then
  SOM_DIR=/Users/smarr/Projects/SOM/SOMns
  AWFY_DIR="$SCRIPT_PATH/../../are-we-fast-yet/benchmarks/SOMns"
elif [ -x /usr/sbin/update-java-alternatives ]  ## that should be Ubuntu/Linux
then
  SOM_DIR=/home/smarr/Projects/RoarVM-buildslave/SOMns/build
  AWFY_DIR=/home/smarr/Projects/RoarVM-buildslave/are-we-fast-yet/build/benchmarks/SOMns
fi

function runBenchmark {
  BENCH=$1
  IT=$2
  HARNESS="$SOM_DIR/som -dm -Ddm.metrics=$SCRIPT_PATH/$BENCH-$IT \
    -G $AWFY_DIR/Harness.som"
  echo $HARNESS $@
  $HARNESS $@
}

function runSomBenchmark {
  BENCH=$1
  IT=$2
  HARNESS="$SOM_DIR/som -dm -Ddm.metrics=$SCRIPT_PATH/$BENCH-SOM-$IT \
    -G $SOM_DIR/core-lib/benchmarks/Harness.som"
  echo $HARNESS $@
  $HARNESS $@
}


runBenchmark CD 2 1000        &
runBenchmark Havlak 2 1       &

runBenchmark Mandelbrot 2 500      &
runBenchmark DeltaBlue  2 12000    &
runBenchmark Richards   2 100      &
runBenchmark Json       2 100      &
runBenchmark Bounce     2 1500     &
runBenchmark List       2 1500     &
runBenchmark NBody      2 250000   &
runBenchmark Permute    2 1000
runBenchmark Queens     2 1000     &
runBenchmark Sieve      2 3000     &
runBenchmark Storage    2 1000     &
runBenchmark Towers     2 600      &
runBenchmark GraphSearch 2 20      &

runBenchmark CD 3 1000             &
runBenchmark Havlak 3 1            &

runBenchmark Mandelbrot 3 500
runBenchmark DeltaBlue  3 12000    &
runBenchmark Richards   3 100      &
runBenchmark Json       3 100      &
runBenchmark Bounce     3 1500     &
runBenchmark List       3 1500     &
runBenchmark NBody      3 250000   &
runBenchmark Permute    3 1000     &
runBenchmark Queens     3 1000     &
runBenchmark Sieve      3 3000
runBenchmark Storage    3 1000     &
runBenchmark Towers     3 600      &

runBenchmark GraphSearch 3 20      &

runSomBenchmark Fannkuch    2 0 7  &

runSomBenchmark LanguageFeatures.Fibonacci    2 0 100  &
runSomBenchmark LanguageFeatures.Dispatch     2 0 1000 &
runSomBenchmark LanguageFeatures.Loop         2 0 1000 &
runSomBenchmark LanguageFeatures.Recurse      2 0 100  &
runSomBenchmark LanguageFeatures.IntegerLoop  2 0 1000 &
runSomBenchmark LanguageFeatures.FieldLoop    2 0 100

runSomBenchmark Sort.QuickSort  2 0 200  &
runSomBenchmark Sort.TreeSort   2 0 200  &
runSomBenchmark Sort.BubbleSort 2 0 200  &

runSomBenchmark Fannkuch    3 0 7        &

runSomBenchmark LanguageFeatures.Fibonacci    3 0 100   &
runSomBenchmark LanguageFeatures.Dispatch     3 0 1000  &
runSomBenchmark LanguageFeatures.Loop         3 0 1000  &
runSomBenchmark LanguageFeatures.Recurse      3 0 100   &
runSomBenchmark LanguageFeatures.IntegerLoop  3 0 1000  &
runSomBenchmark LanguageFeatures.FieldLoop    3 0 100   &

runSomBenchmark Sort.QuickSort  3 0 200 &
runSomBenchmark Sort.TreeSort   3 0 200
runSomBenchmark Sort.BubbleSort 3 0 200


# runSomBenchmark PageRank    2 0 1
