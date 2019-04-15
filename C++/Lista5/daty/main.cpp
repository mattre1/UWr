#include <stdfix.h>
#include <iostream>
#include <vector>
#include <algorithm>
#include <ctime>

#include "daty.h"

using namespace std;

int main()
{
    Data d1(13, 12, 1998);
    Data d2;
    Data d3(d2);
    cout<<"d1 Konstruktor z data: "<<d1.get_dzien()<<"/"<<d1.get_miesiac()<<"/"<<d1.get_rok()<<endl;
    cout<<"d2 Konstruktor bezparametrowy: "<<d2.get_dzien()<<"/"<<d2.get_miesiac()<<"/"<<d2.get_rok()<<endl;
    cout<<"d3 Konstruktor kopiujacy d2: "<<d3.get_dzien()<<"/"<<d3.get_miesiac()<<"/"<<d3.get_rok()<<endl;
    cout<<"d3-d2= "<<d3-d2<<endl;
    cout<<"d3-d1= "<<d3-d1<<endl;     // roznica dni pomiedzy datami
    d3++;
    d1--;
    cout<<"d3++ "<<d3.get_dzien()<<"/"<<d3.get_miesiac()<<"/"<<d3.get_rok()<<endl;
    cout<<"d1-- "<<d1.get_dzien()<<"/"<<d1.get_miesiac()<<"/"<<d1.get_rok()<<endl;
    d1+=89;
    d2-=89;
    cout<<"d1+=89 "<<d1.get_dzien()<<"/"<<d1.get_miesiac()<<"/"<<d1.get_rok()<<endl;   // zmiany roku przez zmiane dat (skrajne przypadki)
    cout<<"d2-=89 "<<d2.get_dzien()<<"/"<<d2.get_miesiac()<<"/"<<d2.get_rok()<<endl<<endl;

    Data d4(2, 4, 2005);
    DataGodz dg1(21, 37, 0, d4);
    DataGodz dg2;
    DataGodz dg3(dg2);
    Data d5(3, 4, 2005);
    DataGodz dg5(1, 1, 1, d5);
    cout<<"dg1 Konstruktor z czasem: "<<dg1.get_godzina()<<":"<<dg1.get_minuta()<<":"<<dg1.get_sekunda()<<"  "<<dg1.get_dzien()<<"/"<<dg1.get_miesiac()<<"/"<<dg1.get_rok()<<endl;
    cout<<"dg2 Konstruktor bezparametrowy: "<<dg2.get_godzina()<<":"<<dg2.get_minuta()<<":"<<dg2.get_sekunda()<<"  "<<dg2.get_dzien()<<"/"<<dg2.get_miesiac()<<"/"<<dg2.get_rok()<<endl;
    cout<<"dg3 Konstruktor kopiujacy dg2: "<<dg2.get_godzina()<<":"<<dg2.get_minuta()<<":"<<dg2.get_sekunda()<<"  "<<dg3.get_dzien()<<"/"<<dg3.get_miesiac()<<"/"<<dg3.get_rok()<<endl;
    cout<<"dg5 : "<<dg5.get_godzina()<<":"<<dg5.get_minuta()<<":"<<dg5.get_sekunda()<<"  "<<dg5.get_dzien()<<"/"<<dg5.get_miesiac()<<"/"<<dg5.get_rok()<<endl;
    cout<<"dg5-dg1 "<<dg5-dg1<<endl;
    cout<<"dg2-dg1 "<<dg2-dg1<<endl;
    dg2++;
    cout<<"dg2++ : "<<dg2.get_godzina()<<":"<<dg2.get_minuta()<<":"<<dg2.get_sekunda()<<"  "<<dg2.get_dzien()<<"/"<<dg2.get_miesiac()<<"/"<<dg2.get_rok()<<endl;
    dg2--;
    cout<<"dg2-- : "<<dg2.get_godzina()<<":"<<dg2.get_minuta()<<":"<<dg2.get_sekunda()<<"  "<<dg2.get_dzien()<<"/"<<dg2.get_miesiac()<<"/"<<dg2.get_rok()<<endl;
    Data d0(31, 12, 1998);
    DataGodz dg0(23, 59, 59, d0);
    cout<<"dg0 : "<<dg0.get_godzina()<<":"<<dg0.get_minuta()<<":"<<dg0.get_sekunda()<<"  "<<dg0.get_dzien()<<"/"<<dg0.get_miesiac()<<"/"<<dg0.get_rok()<<endl;
    dg0+=20;
    cout<<"dg0+=20 : "<<dg0.get_godzina()<<":"<<dg0.get_minuta()<<":"<<dg0.get_sekunda()<<"  "<<dg0.get_dzien()<<"/"<<dg0.get_miesiac()<<"/"<<dg0.get_rok()<<endl;
    dg0-=20;
    cout<<"dg0-=20 : "<<dg0.get_godzina()<<":"<<dg0.get_minuta()<<":"<<dg0.get_sekunda()<<"  "<<dg0.get_dzien()<<"/"<<dg0.get_miesiac()<<"/"<<dg0.get_rok()<<endl;
    cout<<"dg0 < dg1 = "<<(dg0 < dg1)<<endl;
    cout<<"dg1 < dg0 = "<<(dg1 < dg0)<<endl;
    cout<<"dg3 == dg2 = "<<(dg3 == dg2)<<endl;
    cout<<"dg3 == dg1 = "<<(dg3 == dg1)<<endl;

    Wydarzenie w0(dg0, "1. Moje urodziny");
    Wydarzenie w1(dg1, "2. Smierc papieza");
    Wydarzenie w2(dg5, "3. Nie wiem co to");
    Wydarzenie w3(dg2, "4. Chwila obecna");     //chronologicznie

    vector<Wydarzenie> tablica_wydarzen(1, w3);
    tablica_wydarzen.push_back(w2);
    tablica_wydarzen.push_back(w1);
    tablica_wydarzen.push_back(w0);
    cout<<"Nieposortowane: "<<endl;
    for(int i=0; i<4; i++)
    {
        cout<<tablica_wydarzen[i].opis<<endl;
    }
    sort(tablica_wydarzen.begin(), tablica_wydarzen.end());
    cout<<"Posortowane: "<<endl;
    for(int i=0; i<4; i++)
    {
        cout<<tablica_wydarzen[i].opis<<endl;
    }
    Data g(29, 2, 2020);
    Data g2(1, 3, 2020);
    cout<<g-g2;
    return 0;
}
