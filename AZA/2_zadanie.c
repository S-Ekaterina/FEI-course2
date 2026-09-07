#include <stdio.h>
#include <stdlib.h>

// Disjoint Set Data Structure III in Appendix C
typedef struct {
	int job;      // The number of jobs
	int deadline; // The deadline for the i-th job
	int profit;   // Profits associated with the jobs
} Task;

int compare(const void* a, const void* b) {
    Task* taskA = (Task*)a;
    Task* taskB = (Task*)b;
    return taskB->profit - taskA->profit;
}

int small(int S, int sets[]) {              // log m krat
    if (sets[S] == S) {
        return S;
    }
    return sets[S] = small(sets[S], sets);
}

void schedule(int n, int d, Task tasks[], int J[], int *sizeJ) {
	int i, slot;
	int sets[d+1];
	
	// Initializing d+1 disjoint sets:
	for (i=0; i<=d; i++) {                  // d krat
        sets[i] = i;
    }
    
    // It adds a job as late as possible to the schedule being built, but no later than its deadline:
    for (i=0; i<n; i++) {                   // n krat
    	slot = small(tasks[i].deadline, sets);// log m krat
    	if (slot > 0) {
    		J[*sizeJ] = i;
			*sizeJ += 1;
			// schedule it at time small(S), and merge S with the set containing small(S)-1:
			sets[slot] = small(slot - 1, sets);
			//printf("%d %d\n", i, J[*sizeJ-1]);
		}
	}
}

int main() {
	int i, j, a, sum=0;
	int n = 7;                             // The number of jobs
	int d = 0;                             // Maximum of the deadlines for n jobs
	int deadline[] = {2,4,3,2,3,1,1};      // The deadline for the i-th job
	int profit[] = {40,15,60,20,10,45,55}; // Profits associated with the jobs
	int J[n], sizeJ = 0;
	
	for (i=0; i<n; i++) {                  // n krat
		if (d < deadline[i]) {
			d = deadline[i];
		}
	}

	Task tasks[n];
	for (i=0; i<n; i++) {                  // n krat
		tasks[i].job = i+1;
		tasks[i].deadline = deadline[i];
		tasks[i].profit = profit[i];
	}

	// The array has been sorted in nonincreasing order according to the profits associated with the jobs:
	qsort(tasks, n, sizeof(Task), compare);
	
	schedule(n, d, tasks, J, &sizeJ);
	
	// Outputs:
	printf("An optimal sequence for the job:\n");
	for (i=0; i<sizeJ; i++) {              // sizeJ krat
		printf("%d. Deadline - %d, Profit - %d\n", tasks[J[i]].job, tasks[J[i]].deadline, tasks[J[i]].profit);
		sum += tasks[J[i]].profit;
	}
	printf("Celkovo: %d profit", sum);
	
	return 0;
}
