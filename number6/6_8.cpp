#include <iostream>
using namespace std;

int main()
{
  unsigned int i = 2519;
  bool smallest_num_found = false;
  while (!smallest_num_found) 
  {
    i++;
	
    bool this_number_is_smallest = true;
    for (int j = 2; j <= 20; j++) 
	{
	  if (i % j != 0)
	    this_number_is_smallest = false;
		
	  if (i == 20 && this_number_is_smallest)
	  {
	    smallest_num_found = true;
		break;
      }
	}
  }
  
  cout << "Smallest number is " << i << endl;
   
  return 0;   
}

