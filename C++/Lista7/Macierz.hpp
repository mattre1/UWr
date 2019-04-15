//
// Created by JA on 4/14/2018.
//

#ifndef LISTA7_MACIERZ_HPP
#define LISTA7_MACIERZ_HPP

#endif //LISTA7_MACIERZ_HPP

#include <iostream>

namespace obliczenia
{
    class Macierz
    {
        double** wiersze;
        int ilosc_wierszy;
        int ilosc_kolumn;

    public:
        // konstruktory, przypisania
        Macierz(int a);
        //Macierz(int a, int b);
        //Macierz(const Macierz& ob);
        //Macierz(Macierz&& ob);
        //Macierz& operator = (const Macierz& ob);
        //Macierz& operator = (Macierz&& ob);
        ~Macierz();

        // operacje na macierzach
        void printm();
    };

}