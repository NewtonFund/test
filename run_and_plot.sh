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

if [[ `uname` == "Linux" ]]; then
    GETDATE="date"
else
    GETDATE="gdate"
fi

# Unix time (host time) before running executable, Unix time (docker time) when executed inside docker, Unix time (host time) after running executable
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> output-docker.txt && docker exec -t milkyway bash -c "/workspace/hello-time-docker" && echo $(($($GETDATE +%s%N))) >> output-docker.txt 
done

# Unix time (host time) before running executable, Unix time (host time) when executed on the host system, Unix time (host time) after running executable
for i in {1..100}
do
    echo -n $(($($GETDATE +%s%N)))" " >> output-host.txt && ./hello-time-host && echo $(($($GETDATE +%s%N))) >> output-host.txt 
done

# Produce plots
python make_plots.py
