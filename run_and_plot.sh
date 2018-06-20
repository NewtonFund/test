#!/bin/bash

rm output-docker.txt
rm output-host.txt

# Sync the clock
# This gives some residual, need to look further into time synchronisation
docker run --rm --privileged alpine hwclock -s

# Compile an executable in the docker image
docker exec -t milkyway bash -c "gcc -o hello-time-docker hello-docker.c -O3"

# Compile an executable in the host system
gcc -o hello-time-host hello-host.c -O3

# Sync with ntpd
# docker doesn't let you do it like this...
#docker exec -t milkyway bash -c "ntpd -gq && service ntp start"

# Unix time (host time) before running executable, Unix time (docker time) when executed inside docker, Unix time (host time) after running executable
for i in {1..100}
do
    echo -n $(($(gdate +%s%N)))" " >> output-docker.txt && docker exec -t milkyway bash -c "/workspace/hello-time-docker" && echo $(($(gdate +%s%N))) >> output-docker.txt 
done

# Unix time (host time) before running executable, Unix time (host time) when executed on the host system, Unix time (host time) after running executable
for i in {1..100}
do
    echo -n $(($(gdate +%s%N)))" " >> output-host.txt && ./hello-time-host && echo $(($(gdate +%s%N))) >> output-host.txt 
done

# Produce plots
python make_plots.py
