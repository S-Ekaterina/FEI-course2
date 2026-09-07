#include <stdio.h>
#include <stdbool.h>

bool feasible(int K[], int size, const int deadline[]) {
	int i;
	// Is ok deadlines?
	for (i=0; i<size; i++) {                 // sizeK krat
		if(deadline[K[i]-1] < i+1) {
			return false;
		}	
	}
	return true;
}

void schedule(int n, const int deadline[], int J[], int *sizeJ) {
	int i, K[n], j, a, b, sizeK;             // index i; sequence of integer K;
	J[0] = 1;                                // J = [1];
	*sizeJ = 1;
	
	
	for (i=2; i<=n; i++) {                   // n-1 krat; for (i=2; i <= n; i++){
		for (j=0; j<*sizeJ; j++) {           // sizeJ krat
			K[j] = J[j];
		}
		K[*sizeJ] = i;
		sizeK = j+1;
		
		// K=J with i added according to nondecreasing values of deadline [i]:
		for(a=0; a<sizeK-1; a++) {          // sizeK-1 krat
			for(b=a+1; b<sizeK; b++) {      // sizeK-a-1 krat
				if (deadline[K[a]-1] > deadline[K[b]-1]) {
					j = K[a];
	                K[a] = K[b];
	                K[b] = j;
				}
			}
		}

		if (feasible(K, sizeK, deadline)) { // if (K is feasible)
			for(j=0; j<sizeK; j++) {        // sizeK krat
				J[j] = K[j];                // J = K;
			}
			*sizeJ = sizeK;
		}
	}
}

int main() {
	int n = 7, i, j, a, sum=0;                    // The number of jobs
	int deadline[] = {2,4,3,2,3,1,1};      // The deadline for the i-th job
	int profit[] = {40,15,60,20,10,45,55}; // Profits associated with the jobs
	int J[n], sizeJ = 0, Job[n];
	for(i=0; i<n; i++) {
		Job[i] = i+1;
	}
	
	// The array has been sorted in nonincreasing order according to the profits associated with the jobs:
	for (i=0; i<n-1; i++) {                 // n-1 krat
        for (j=0; j<n-i-1; j++) {           // n-i-1 krat
            if (profit[j] < profit[j+1]) {  // n-i-1 krat
                a = profit[j];
                profit[j] = profit[j+1];
                profit[j+1] = a;
                
                a = deadline[j];
                deadline[j] = deadline[j+1];
                deadline[j+1] = a;
                
                a = Job[j];
                Job[j] = Job[j+1];
                Job[j+1] = a;
            }
        }
    }
	
	schedule(n, deadline, J, &sizeJ);
	
	// Outputs:
	printf("An optimal sequence for the job:\n");
	for (i=0; i<sizeJ; i++) {              // sizeJ krat
		printf("%d. Deadline - %d, Profit - %d\n", Job[J[i]-1], deadline[J[i]-1], profit[J[i]-1]);
		sum += profit[J[i]-1];
	}
	printf("Celkovo: %d profit", sum);
	
	return 0;
}
