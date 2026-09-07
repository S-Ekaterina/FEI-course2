#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct {
    char character;
    int frequency;
    int length;
    char code[30];
} Symbol;

int compare(const void* a, const void* b) {
    Symbol* symbolA = (Symbol*)a;
    Symbol* symbolB = (Symbol*)b;
    return symbolB->frequency - symbolA->frequency;
}

void binary(int number, int m, char* code) {
	int i;
	for (i=0; i<m; i++) {
        code[m-1-i] = (number % 2) + '0';
        number /= 2;
    }
    code[m] = '\0';
}

void length(Symbol symbol[], int n) {
    int i, length=1, m=0;
    
    for (i=0; i<n; i++) {
    	if (i>0 && i == (int)pow(2, length)) {
    		length++;
		}
		symbol[i].length=length;
		binary(i, length, symbol[i].code);
    }
}

int main() {
	int i, j, a;
	char character[] = "ABCDEF";
	int frequency[] = {45, 13, 12, 16, 9, 5};
	int n = sizeof(frequency)/sizeof(frequency[0]);
	
	Symbol symbol[n];
	for (i=0; i<n; i++) {
		symbol[i].character = character[i];
		symbol[i].frequency = frequency[i];
		symbol[i].length=0;
		memset(symbol[i].code, 0, sizeof(symbol[i].code));
	}
	
	qsort(symbol, n, sizeof(Symbol), compare);
	length(symbol, n);
    
    for (i=0; i<n; i++) {
    	printf("Character: %c, frequency: %d, code: %s\n", symbol[i].character, symbol[i].frequency, symbol[i].code);
	}
    
    // Be a fab ace
	char ace[12] = "BE A FAB ACE";
	int g,p=0;
	for (i=0; i<12; i++) {
		g=0;
		for (j=0; j<n; j++) {
			if (symbol[j].character == ace[i]) {
				printf("%s ", symbol[j].code);
				p++;
				g=1;
				break;
			}	
		}
		if (g == 0) {
			printf("   ");
			p++;
		}
	}
	printf("\n%d symbolov", p);
    
	return 0;
}

