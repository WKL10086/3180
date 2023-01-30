//do NOT submit or modify this file

#ifndef __BUN_H__
#define __BUN_H__

#include "ingredient.h"

class Bun : public Ingredient
{
public:
    Bun(int softness);
    int getSoftness();
    void update() override;
    void print() override;

private:
    int softness;
};

#endif // __BUN_H__