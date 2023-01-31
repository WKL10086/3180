#ifndef __BURGERSHOP_H__
#define __BURGERSHOP_H__

//do NOT submit or modify this file

#include "ingredient.h"

class BurgerShop
{
public:
    BurgerShop(int ingredientStorageCapacity);
    ~BurgerShop();
    void attemptToMakeBun(int softness);
    void attemptToMakeMeat(int doneness);
    void attemptToMakeAndServeBurger(int requiredBunSoftness, int requiredMeatDoneness);
    void update();
    void print();

private:
    bool isStorageFull();
    void addFoodToStorage(Ingredient* food);
    bool makeBun(int softness);
    bool makeMeat(int doneness);
    bool makeAndServeBurger(int requiredBunSoftness, int requiredMeatDoneness);

    Ingredient** ingredientStorage;
    int ingredientStorageCapacity;
    int ingredientStorageUsed = 0;
    int burgerServed = 0;
};

#endif // __BURGERSHOP_H__