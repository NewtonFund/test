# Comparing execution time with and without docker

1.) Compile and run a C script to print the timestamp of the docker image to a text file in the host
2.) Compile and run the same C script to print the timestamp to a text file in the host
3.) Plot the time (vs run) between (a) before calling the executable, and (b) writing the to text file
4.) Plot the time (vs run) between (a) writing the to text file, and (b) after the executable is wrapped up

## Dependencies
* Docker
* gcc
* Python 2.7 (should be compatible with 3.X)
* numpy
* matplotlib

## Execute
./run_and_plot.py
