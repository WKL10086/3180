//do NOT submit or modify this file

#ifndef __MEAT_H__
#define __MEAT_H__

#include "ingredient.h"

class Meat : public Ingredient
{
public:
    Meat(int doneness);
    int getDoneness();
    void print() override;

private:
    int doneness;
};

#endif // __MEAT_H__