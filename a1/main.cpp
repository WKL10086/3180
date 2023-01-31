//do NOT submit this file

//while you can modify this file to create your own test cases, make sure your submitted files can compile with the orignal unmodified version of this file

#include <iostream>
#include "burgerShop.h"

using std::cout;
using std::endl;

int main()
{
    cout << "============ 1st hour ============" << endl;
    cout << "Teemo: let's open a happy burger shop with 10 storage spaces for ingredients!" << endl;
    cout << endl;
    BurgerShop happyBurgerShop(10);
    happyBurgerShop.print();
    happyBurgerShop.update();

    cout << "============ 2nd hour ============" << endl;
    cout << "Teemo: let's prepare some ingredients!" << endl;
    cout << "Teemo: a hard bun and a soft bun!" << endl;
    cout << endl;
    happyBurgerShop.attemptToMakeBun(10);
    happyBurgerShop.attemptToMakeBun(70);
    happyBurgerShop.print();
    happyBurgerShop.update();

    cout << "============ 3rd hour ============" << endl;
    cout << "Teemo: need some well-done meats and more soft buns!" << endl;
    cout << endl;
    happyBurgerShop.attemptToMakeMeat(90);
    happyBurgerShop.attemptToMakeMeat(80);
    happyBurgerShop.attemptToMakeBun(60);
    happyBurgerShop.attemptToMakeBun(90);
    happyBurgerShop.print();
    happyBurgerShop.update();

    cout << "============ 4th hour ============" << endl;
    cout << "Teemo: how about a piece of rare meat and a super soft bun!" << endl;
    cout << endl;
    happyBurgerShop.attemptToMakeMeat(10);
    happyBurgerShop.attemptToMakeBun(100);
    happyBurgerShop.print();
    happyBurgerShop.update();

    cout << "============ 5th hour ============" << endl;
    cout << "Teemo: happy burger shop is now open!" << endl;
    cout << "Teemo: and we already have a customer!" << endl;
    cout << "Teemo: she wants at least 60% soft buns and at least 20% done meat!" << endl;
    cout << "Teemo: let's craft a burger for her!" << endl;
    cout << endl;
    happyBurgerShop.attemptToMakeAndServeBurger(60, 20);
    happyBurgerShop.print();
    for(int i=0; i<98; i++)
        happyBurgerShop.update();

    cout << "============ 98 hours have passed... ============" << endl;
    cout << "Teemo: zzzzzzzzzzzzzzzzzzzz..." << endl;
    cout << endl;
    happyBurgerShop.print();
    
    cout << "============ 103rd hour ============" << endl;
    cout << "Teemo: wow! finally another customer!" << endl;
    cout << "Teemo: let's craft a burger for him!" << endl;
    cout << "Teemo: he has no requirements on bun softness and meat doneness!" << endl;
    cout << endl;
    happyBurgerShop.attemptToMakeAndServeBurger(0, 0);
    happyBurgerShop.print();
    happyBurgerShop.update();
    
    cout << "============ 104th hour ============" << endl;
    cout << "Teemo: gg!" << endl;
    cout << "Teemo: maybe instead of meat burgers, I should make mushroom burgers instead next time..." << endl;
    cout << "Teemo: shop closes! T_T" << endl;

    return 0;
}