//
// Created by JA on 4/14/2018.
//

#include "Macierz.hpp"

namespace obliczenia {
    // konstruktor tworzy macierz kwadratowa jednostkowa stopnia a
    Macierz::Macierz(int a) : ilosc_wierszy(a), ilosc_kolumn(a) {
         // alokacja
         wiersze = new double*[ilosc_wierszy];
         for(int i=0; i<ilosc_wierszy; i++)
         {
             wiersze[i] = new double[ilosc_kolumn];
         }

         // przypisanie
         for(int i=0; i<ilosc_wierszy; i++)
        {
            for(int j=0; j<ilosc_kolumn; j++)
            {
                if(i == j) wiersze[i][j] = 1;
                else       wiersze[i][j] = 0;
            }
        }
    }

    void Macierz::printm() {
        for(int i=0; i<ilosc_wierszy; i++)
        {
            for(int j=0; j<ilosc_kolumn; j++)
            {
                std::cout<<wiersze[i][j]<<" ";
            }
            std::cout<<std::endl;
        }
    }

    Macierz::~Macierz()
    {
        for(int i=0; i<ilosc_wierszy; i++)
        {
            delete [] wiersze[i];
        }
        delete [] wiersze;
    }


    // konstruktor tworzy macierz prostokatna zerowa a x b
    Macierz::(int a, int b) : ilosc_wierszy(a), ilosc_kolumn(b) {
        // alokacja
        double **wiersze = new double *[ilosc_wierszy];
        for (int i = 0; i < ilosc_wierszy; i++) {
            wiersze[i] = new double[ilosc_kolumn];
        }

        // przypisanie
        for (int i = 0; i < ilosc_wierszy; i++) {
            for (int j = 0; j < ilosc_kolumn; j++) {
                wiersze[i][j] = 0;
            }
        }
    }

    // kopiujacy
    Macierz::(const Macierz &ob) : ilosc_wierszy(ob.ilosc_wierszy),
                                   ilosc_kolumn(ob.ilosc_kolumn) {
        double **wiersze = new double *[ilosc_wierszy];
        for (int i = 0; i < ilosc_wierszy; i++) {
            wiersze[i] = new double[ilosc_kolumn];
        }

        for (int i = 0; i < ilosc_wierszy; i++) {
            for (int j = 0; j < ilosc_kolumn; j++) {
                wiersze[i][j] = ob.wiersze[i][j];
            }
        }
    }

    Macierz::(Macierz&& ob) : ilosc_wierszy(ob.ilosc_wierszy),ilosc_kolumn(ob.ilosc_kolumn)
{
    double **wiersze = new double *[ilosc_wierszy];
    for(int i = 0;i<ilosc_wierszy;i++)
    { wiersze[i] = new double[ilosc_kolumn];}
}


Macierz& Macierz::operator = (const Macierz& ob)
{
    this = Macierz(ob);
    return *this;
}


Macierz& Macierz::operator = (Macierz&& ob)
{
    if(&ob == this) return *this;

    this = Macierz(ob);
    return *this;
}
*/



}






