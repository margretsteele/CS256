#include <iostream>
#include <cstring>
#include <string>
#include <stdlib.h>
using namespace std;
int changeOpAndEval( char newOp, string expr);

int main()
{
	cout << "+ values: " << changeOpAndEval( '+', "* 10 3") << endl;
	cout << "- values: " << changeOpAndEval( '-', "* 10 3") << endl;
	cout << "* values: " << changeOpAndEval( '*', "* 10 3") << endl;
	cout << "/ values: " << changeOpAndEval( '/', "* 10 3") << endl;
	return 0;
}
int changeOpAndEval( char newOp, string expr)
{
	char * cstr = new char [expr.size()+1];
	strcpy (cstr, expr.c_str());

	strtok (cstr," ");
	int a = atoi(strtok(NULL," "));
	int b = atoi(strtok(NULL," "));
	delete[] cstr;
	switch( newOp )
	{
		case '+':
			return a+b;
		case '-':
			return a-b;
		case '*':
			return a*b;
		case '/':
			return a/b;
	}
}