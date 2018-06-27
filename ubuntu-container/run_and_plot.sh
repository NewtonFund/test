#!/bin/bash

# Build the docker image
docker build -t hello-timestamp .

# If the container milkyway already exists, remove it.
if [ ! "$(docker ps -q -f name=milkyway)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=milkyway)" ]; then
        # cleanup
        docker rm milkyway
    fi
    # run your container
    docker run --name milkyway -id -v $(pwd):/workspace hello-timestamp
fi

# Remove output files if already exist
echo "Removing previous outputs."
if [ -f io-time-output-docker.txt ] ; then
  rm io-time-output-docker.txt
fi

if [ -f io-time-output-host.txt ] ; then
  rm io-time-output-host.txt
fi

if [ -f cal-time-output-docker.txt ] ; then
  rm cal-time-output-docker.txt
fi

if [ -f cal-time-output-host.txt ] ; then
  rm cal-time-output-host.txt
fi

# Sync the clock
# This gives some residual, need to look further into time synchronisation
echo "Syncing the clock."
docker run --rm --privileged alpine hwclock -s

# Compile an executable in the docker image
echo "Compiling C scripts inside docker container."
docker exec -t milkyway bash -c "gcc --version"
docker exec -t milkyway bash -c "gcc -pedantic -Wall -std=gnu99 -o io-time-docker io-time-docker.c -lm"
docker exec -t milkyway bash -c "gcc -pedantic -Wall -std=gnu99 -o cal-time-docker cal-time-docker.c -lm"

# Compile an executable in the host system
echo "Compiling C scripts on the host."
gcc -std=gnu99 -o io-time-host io-time-host.c -lm
gcc -std=gnu99 -o cal-time-host cal-time-host.c -lm

if [[ `uname` == "Linux" ]]; then
    GETDATE="date"
else
    GETDATE="gdate"
fi

# Unix time (host time) before running executable, Unix time (docker time) when executed inside docker, Unix time (host time) after running executable
echo "Running io-timing test in the container."
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> io-time-output-docker.txt && docker exec -t milkyway bash -c "/workspace/io-time-docker" && echo $(($($GETDATE +%s%N))) >> io-time-output-docker.txt 
done

# Unix time (host time) before running executable, Unix time (host time) when executed on the host system, Unix time (host time) after running executable
echo "Running io-timing test on the host."
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> io-time-output-host.txt && ./io-time-host && echo $(($($GETDATE +%s%N))) >> io-time-output-host.txt 
done

# Unix time (host time) before running executable, Unix time (docker time) when executed inside docker, Unix time (host time) after running executable
echo "Number crunching timing test in the container."
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> cal-time-output-docker.txt && docker exec -t milkyway bash -c "/workspace/cal-time-docker" && echo $(($($GETDATE +%s%N))) >> cal-time-output-docker.txt 
done

# Unix time (host time) before running executable, Unix time (host time) when executed on the host system, Unix time (host time) after running executable
echo "Number crunching timing test on the host."
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> cal-time-output-host.txt && ./cal-time-host && echo $(($($GETDATE +%s%N))) >> cal-time-output-host.txt 
done

echo "Stopping and cleaning up."
# stop the docker
docker stop milkyway

# cleanup
docker rm milkyway
docker image rm hello-timestamp

# Produce plots
echo "Generating plots."
python make_plots.py
