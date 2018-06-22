#include <stdio.h>
#include <time.h>
#include <math.h>

int main()
{

    FILE *f = fopen("cal-time-output-host.txt", "a");

    // get current time
    struct timespec t0;
    struct timespec t1;

    double out_val;

    //Call clock_gettime to fill t0
    clock_gettime(CLOCK_REALTIME, &t0);

    for (long int i=0; i<10000; ++i) {
        for (long int j=0; j<10000; ++j) {
            double k = (double)j;
            out_val = pow(sin(k), cos(k));
            out_val = pow(exp(-out_val), exp(-k));
        }
    }

    //Call clock_gettime to fill t0
    clock_gettime(CLOCK_REALTIME, &t1);
    long int t = (t1.tv_sec * 1000000000 + t1.tv_nsec) - (t0.tv_sec * 1000000000 + t0.tv_nsec);
    fprintf(f, "%li ", t);

    // printf() displays the string inside quotation
    //fprintf(f, "%li ", t0);
    fclose(f);
    return 0;
}

