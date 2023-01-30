//do NOT submit or modify this file

#include "meat.h"
#include <iostream>
using std::cout;

Meat::Meat(int doneness) : doneness(doneness) //after the ":", we can have a member-initialization list for initializing the data members
{
    //you can also do the following instead of using the member-initialization list:
    //this->doneness = doneness;  //the LHS must use "this" to differentiate the data member instance variable from the local variable 
}

int Meat::getDoneness()
{
    return doneness;   
}

void Meat::print()
{
    cout << "Meat (" << getFreshness() << "% fresh, " << doneness << "% done)";
}