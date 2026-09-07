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

typedef struct {
	char character[20];
    int frequency;
} Pocet;

int compare(const void* a, const void* b) {
    Symbol* symbolA = (Symbol*)a;
    Symbol* symbolB = (Symbol*)b;
    return symbolA->frequency - symbolB->frequency;
}

int compar(const void* a, const void* b) {
    Pocet* pocetA = (Pocet*)a;
    Pocet* pocetB = (Pocet*)b;
    return pocetA->frequency - pocetB->frequency;
}

void code(char cod[], char c) {
	int i;
	for (i=29; i>0; i--) {
		cod[i] = cod[i-1];
	}
	cod[0] = c;
}

void length(Symbol symbol[], int n) {
    int i, sum, m=n, j;
    //int add[m][2], ;
    
    Pocet pocet[m];
	for (i=0; i<n; i++) {
		pocet[i].character[0] = symbol[i].character;
        pocet[i].character[1] = '\0';
		pocet[i].frequency = symbol[i].frequency;
	}
    
    while (m > 1) {
    	sum = pocet[0].frequency + pocet[1].frequency;
    	//printf("%s ", pocet[0].character);
    	//printf("%s ", pocet[1].character);
    	for (i=0; i<n; i++) {
    		for (j=0; j<20; j++) {
    			if (pocet[0].character[j] == symbol[i].character) {
    				code(symbol[i].code, '0');
    				symbol[i].length++;
	    			//printf("0 %c ", symbol[i].character);
				}
				else if (pocet[1].character[j] == symbol[i].character) {
					code(symbol[i].code, '1');
					symbol[i].length++;
					//printf("1 %c ", symbol[i].character);
				}
			}
    	}
		strcat(pocet[0].character, pocet[1].character); // napriklad 'AB'
		pocet[0].frequency = sum;
    	m--;
    	strcpy(pocet[1].character, pocet[m].character);
		pocet[1].frequency = pocet[m].frequency;
		qsort(pocet, m, sizeof(Pocet), compar);
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
    	printf("Character: %c, frequency: %d, length: %d, code: %s\n", symbol[i].character, symbol[i].frequency, symbol[i].length, symbol[i].code);
	}
	
	// Be a fab ace
	char ace[12] = "BE A FAB ACE";
	int p=0;
	for (i=0; i<12; i++) {
		for (j=0; j<n; j++) {
			if (symbol[j].character == ace[i]) {
				printf("%s ", symbol[j].code);
				p += strlen(symbol[j].code);
				p++;
				break;
			}	
		}
	}
    printf("\n%d symbolov", --p);
	return 0;
}
