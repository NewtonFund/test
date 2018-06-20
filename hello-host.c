#include <stdio.h>
#include <time.h>

int main()
{

    FILE *f = fopen("output-host.txt", "a");

    // get current time
    struct timespec t0;

    clock_gettime(CLOCK_REALTIME, &t0);   //Call clock_gettime to fill tsp

    fprintf(f, "%li%09li ", t0.tv_sec, t0.tv_nsec);

    // printf() displays the string inside quotation
    //fprintf(f, "%li ", t0);
    fclose(f);
    return 0;
}

