#ifndef SYMBOL_TABLE_ENTRY_H
#define SYMBOL_TABLE_ENTRY_H

#include <string>
using namespace std;

#define FUNCTION    -5  
#define INT         -4   
#define STR         -3
#define INT_or_STR  -2
#define UNDEFINED   -1   
#define NOT_APPLICABLE  -1

typedef struct { 
	int type;                // one of the above type codes 
	int numParams;  // numParams and returnType only applicable
	int returnType;    // if type == FUNCTION 
    int length;
} TYPE_INFO;

class SYMBOL_TABLE_ENTRY {
private:
  // Member variables
  string name;
  int typeCode; 
  int numParams; 
  int returnType;

public:
  // Constructors
  SYMBOL_TABLE_ENTRY( ) { name = ""; typeCode = UNDEFINED; numParams = 0; returnType = UNDEFINED; }
  SYMBOL_TABLE_ENTRY(const string theName, const int theType, const int theNumParams, const int theReturnType) {
    name = theName;
    typeCode = theType;
    numParams = theNumParams;
    returnType = theReturnType;
  }

  // Accessors
  string getName() const { return name; }
  int getTypeCode() const { return typeCode; }
  int getNumParams() const { return numParams; }
  int getReturnType() const { return returnType; }
};

#endif  // SYMBOL_TABLE_ENTRY_H
