#ifndef SYMBOL_TABLE_ENTRY_H
#define SYMBOL_TABLE_ENTRY_H

#include <string>
using namespace std;

#define DIV             -9 
#define MUL             -8 
#define SUB             -7 
#define ADD             -6 
#define FUNCTION        -5  
#define INT             -4   
#define STR             -3
#define UNDEFINED       -1   
#define NOT_APPLICABLE  -1

typedef struct { 
	int type;          // one of the above type codes 
	int numParams;     // numParams and returnType only applicable
	int returnType;    // if type == FUNCTION 
    int length;
    int intvalue;
    char strvalue[256];
} TYPE_INFO;

class SYMBOL_TABLE_ENTRY {
private:
  // Member variables
  string name;
  int typeCode; 
  int numParams; 
  int returnType;
  int intvalue;
  string strvalue;

public:
  // Constructors
  SYMBOL_TABLE_ENTRY( ) { name = ""; typeCode = UNDEFINED; numParams = 0; returnType = UNDEFINED; intvalue = 0; strvalue = "";}
  SYMBOL_TABLE_ENTRY(const string theName, const int theType, const int theNumParams, const int theReturnType,  const int theIntValue,  const string theStrValue ) {
    name = theName;
    typeCode = theType;
    numParams = theNumParams;
    returnType = theReturnType;
    intvalue = theIntValue;
    strvalue = theStrValue;
  }

  // Accessors
  string getName() const { return name; }
  int getTypeCode() const { return typeCode; }
  int getNumParams() const { return numParams; }
  int getReturnType() const { return returnType; }
  int getIntValue() const { return intvalue; }
  string getStrValue() const { return strvalue; }
};

#endif  // SYMBOL_TABLE_ENTRY_H
