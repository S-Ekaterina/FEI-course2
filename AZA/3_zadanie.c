#include <stdio.h>
#include <stdlib.h>

// Min-heap utility functions:
void min_heap(int files[], int n, int i) {
    int smallest = i, left = 2*i+1, right = 2*i+2, a;
    if (left < n && files[left] < files[smallest]) {
    	smallest = left;
	}
    if (right < n && files[right] < files[smallest]) {
    	smallest = right;
	} 
    if (smallest != i) {
        a = files[i];
        files[i] = files[smallest];
        files[smallest] = a;
        min_heap(files, n, smallest);
    }
}

// Looking for two files of minimum size:
int minimum(int files[], int* n) {
    int min = files[0];
    files[0] = files[*n-1];
    *n -= 1;
    min_heap(files, *n, 0);
    return min;
}

// Performing a merge:
void insertHeap(int files[], int* n, int b) {
    int a, i = *n;
    *n += 1;
    files[i] = b;
    while (i != 0 && files[(i-1)/2] > files[i]) {
        a = files[i];
        files[i] = files[(i-1)/2];
        files[(i-1)/2] = a;
        i = (i-1)/2;
    }
}

// Minimises the number of record moves in the problem of merging n files:
int merge_pattern(int files[], int n) {
	int i, totalCost=0, a, b, mergeCost;
	
    // min-heap from the input array:
    for (i=(n/2)-1; i>=0; i--) {
    	min_heap(files, n, i);
	} 

    while (n > 1) {
    	// Looking for two files of minimum size:
        a = minimum(files, &n);
        b = minimum(files, &n);

		// The cost of each step is the sum of the sizes of the two files being merged:
        mergeCost = a + b;
        totalCost += mergeCost;

		// Performing a merge:
        insertHeap(files, &n, mergeCost);
        // printf("%d %d %d\n", a, b, mergeCost);
    }
    return totalCost;
}

int main() {
	int c;
	// Example 1
	
	int input1[] = {7,19,3,9,13};
	int n = sizeof(input1)/sizeof(input1[0]);
    printf("Celkove naklady na zlucenie pre priklad 1: %d, merger size: %d\n", merge_pattern(input1, n));

    // Example 2
    int input2[] = {49,56,96,22,31,41};
    n = sizeof(input2)/sizeof(input2[0]);
    printf("Celkove naklady na zlucenie pre priklad 2: %d, merger size: %d\n", merge_pattern(input2, n));
    
	return 0;
}
