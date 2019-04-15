#include <iostream>
#include <string>

#include "wyrazenia.hpp"

using namespace std;

int main()
{
    pair <string, double> p1("x", 0);
    Zmienna::ustaw(p1);
    Wyrazenie *w = new Odejmij(new Pi(), new Dodaj(new Liczba(2), new Mnoz(new Zmienna("x"), new Liczba(7))));
    cout<<w->opis()<<endl;
    cout<<w->oblicz()<<endl;

    w = new Przeciw(new Zmienna("x"));
    for(double i = 0; i <= 1.000000000001; i = i+0.01)
    {
        cout<<w->oblicz()<<endl;
        Zmienna::zamiana_wartosci("x", i);
    }

    return 0;
}