//do NOT submit or modify this file

#include "ingredient.h"

Ingredient::~Ingredient()
{
}

int Ingredient::getFreshness()
{
    return freshness;
}

bool Ingredient::isSpoiled()
{
    return freshness == 0;
}

void Ingredient::update()
{
    if(freshness > 0) //make sure we won't have negative freshness values
        freshness -= 1;
}
