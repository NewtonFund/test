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

# cleanup
docker image rm hello-timestamp

rm io-time-output-docker.txt
rm io-time-output-host.txt
rm cal-time-output-docker.txt
rm cal-time-output-host.txt

# Sync the clock
# This gives some residual, need to look further into time synchronisation
docker run --rm --privileged alpine hwclock -s

# Compile an executable in the docker image
docker exec -t milkyway bash -c "gcc -pedantic -Wall -o io-time-docker io-time-docker.c"
docker exec -t milkyway bash -c "gcc -pedantic -Wall -o cal-time-docker cal-time-docker.c -lm"

# Compile an executable in the host system
gcc -o io-time-host io-time-host.c
gcc -o cal-time-host cal-time-host.c

# Sync with ntpd
# docker doesn't let you do it like this...
#docker exec -t milkyway bash -c "ntpd -gq && service ntp start"

if [[ `uname` == "Linux" ]]; then
    GETDATE="date"
else
    GETDATE="gdate"
fi

# Unix time (host time) before running executable, Unix time (docker time) when executed inside docker, Unix time (host time) after running executable
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> io-time-output-docker.txt && docker exec -t milkyway bash -c "/workspace/io-time-docker" && echo $(($($GETDATE +%s%N))) >> io-time-output-docker.txt 
done

# Unix time (host time) before running executable, Unix time (host time) when executed on the host system, Unix time (host time) after running executable
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> io-time-output-host.txt && ./io-time-host && echo $(($($GETDATE +%s%N))) >> io-time-output-host.txt 
done

# Unix time (host time) before running executable, Unix time (docker time) when executed inside docker, Unix time (host time) after running executable
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> cal-time-output-docker.txt && docker exec -t milkyway bash -c "/workspace/cal-time-docker" && echo $(($($GETDATE +%s%N))) >> cal-time-output-docker.txt 
done

# Unix time (host time) before running executable, Unix time (host time) when executed on the host system, Unix time (host time) after running executable
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> cal-time-output-host.txt && ./cal-time-host && echo $(($($GETDATE +%s%N))) >> cal-time-output-host.txt 
done

# stop the docker
docker stop milkyway

# cleanup
docker rm milkyway

# Produce plots
python make_plots.py


