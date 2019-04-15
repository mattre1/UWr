#include <stdfix.h>
#include <iostream>
#include <cmath>
#include <ctime>

#include "daty.h"

using namespace std;

/******************************************************** KLASA DATA ********************************************************/

constexpr int Data::dniwmiesiacach[2][13];  //dlaczego jak tego nie ma to nie moge w metodach uszyskac dostepu do tablicy?
constexpr int Data::dniodpoczroku[2][13];   //i czemu musza byc constexpr

//konstruktory, operatory

//1 konstruktor z podana data
Data::Data(int d, int m, int r)
{
    if(dobra_data(d, m, r))
    {
        dzien = d;
        miesiac = m;
        rok = r;
    }
    else throw invalid_argument("Zla data");
}

//2 konstruktor bezparametrowy ustawia date systemowa
Data::Data()
{
    time_t now;
    struct tm nowLocal;
    now=time(NULL);
    nowLocal=*localtime(&now);
    rok=nowLocal.tm_year+1900;
    miesiac=nowLocal.tm_mon+1;
    dzien=nowLocal.tm_mday;
}

// operator odejmowania dat
int Data::operator- (Data& d)
{
    Data ob = *this;
    int x = ileDni(ob);
    int y = ileDni(d);
    return abs(x-y);
}

// operator inkrementacji dnia
Data& Data::operator++ (int)
{
    dzien = this->dzien;            //czemu nie musze miec typow tutaj?????????
    miesiac = this->miesiac;
    rok = this->rok;
    if(przestepny(rok))
    {
        if(dzien >= dniwmiesiacach[1][miesiac])
            {
                if(miesiac == 12) {
                    this->dzien = 1;
                    this->miesiac = 1;
                    this->rok = rok+1;
                }
                else               {
                    this->dzien = 1;
                    this->miesiac = miesiac+1;
                }
            }
        else this->dzien = dzien + 1;
    }
    else
    {
        if(dzien >= dniwmiesiacach[0][miesiac])
            {
                if(miesiac == 12) {
                    this->dzien = 1;
                    this->miesiac = 1;
                    this->rok = rok+1;
                }
                else               {
                    this->dzien = 1;
                    this->miesiac = miesiac+1;
                }
            }
        else this->dzien = dzien + 1;
    }
    return *this;
}


// operator dekrementacji dnia
Data& Data::operator-- (int)
{
    dzien = this->dzien;
    miesiac = this->miesiac;
    rok = this->rok;
    if(przestepny(rok))
    {
        if(dzien <= 1)
            {
                if(miesiac == 1) {
                    this->dzien = 31;
                    this->miesiac = 12;
                    this->rok = rok-1;
                }
                else               {
                    this->dzien = dniwmiesiacach[1][miesiac-1];
                    this->miesiac = miesiac-1;
                }
            }
        else this->dzien = dzien -1;
    }
    else
    {
        if(dzien <= 1)
            {
                if(miesiac == 1) {
                    this->dzien = 31;
                    this->miesiac = 12;
                    this->rok = rok-1;
                }
                else               {
                    this->dzien = dniwmiesiacach[0][miesiac-1];
                    this->miesiac = miesiac-1;
                }
            }
        else this->dzien = dzien -1;
    }
    return *this;
}

// operator dodawania zadanej liczby dni do daty
Data& Data::operator+= (int i)
{
    Data d = *this;
    for(int j=0; j<i; j++)
    {
        d++;
    }
    *this = d;      //powinienem zwolnic pamiec obiektu d?????
    return *this;
}

// operator odejmowania zadanej liczby dni od daty
Data& Data::operator-= (int i)
{
    Data d = *this;
    for(int j=0; j<i; j++)
    {
        d--;
    }
    *this = d;
    return *this;
}

// metody

// sprawdza czy podany rok jest przestepny
bool Data::przestepny(int r)
{
    return (((r%4 == 0) && (r%100 != 0)) || (r%400 == 0));
}

// sprawdza czy podana data jest poprawna
bool Data::dobra_data(int d, int m, int r)
{
    if(m>12 || m<1) return false;

    if(przestepny(r))
    {
        if(d > dniwmiesiacach[1][m]) return false;
    }
    else
    {
        if(d > dniwmiesiacach[0][m]) return false;
    }
    return true;
}

// sprawdza ile dni uplynelo od ustalonej daty(01.01.00) do podanej
int Data::ileDni(const Data& dat)
{
    int dzien =   dat.dzien;
    int miesiac = dat.miesiac;
    int rok =     dat.rok;

    rok = rok-1;
    int przestepne = rok/4 - rok/100 + rok/400 + 1;
    int nieprzestepne = rok - przestepne + 1;
    int wynik = przestepne*dniodpoczroku[1][12] + nieprzestepne*dniodpoczroku[0][12];
    rok = rok+1;

    if(przestepny(rok))   wynik = wynik + dniodpoczroku[1][miesiac-1];
    else                  wynik = wynik + dniodpoczroku[0][miesiac-1];
    wynik = wynik + dzien;
    return wynik;
}

/******************************************************** KLASA DATAGODZ ********************************************************/

//konstruktory

// 1 konstruktor z parametrami ??????domyslnymi
DataGodz::DataGodz(int g, int m, int s, Data& dt) : Data(dt)
{
    if(g<24 && g>=0 && m<60 && m>=0 && s<60 && s>=0)
    {
        godzina = g;
        minuta = m;
        sekunda = s;
    }
    else throw invalid_argument("Zly czas podany");
}

// 2 konstruktor domyslny
DataGodz::DataGodz() : Data()
{
    time_t now;
    struct tm nowLocal;
    now=time(NULL);
    nowLocal=*localtime(&now);
    godzina=nowLocal.tm_hour;
    minuta=nowLocal.tm_min;
    sekunda=nowLocal.tm_sec;
}

// operatory

// operator odejmowania godzin (roznica pomiedzy 2 punktami czasowymi)
int DataGodz::operator- (DataGodz& datg)
{
    DataGodz ob = *this;
    int rok1 = ob.get_rok();
    int miesiac1 = ob.get_miesiac();
    int dzien1 = ob.get_dzien();

    Data ob1(dzien1, miesiac1, rok1);
    int rok2 = datg.get_rok();
    int miesiac2 = datg.get_miesiac();
    int dzien2 = datg.get_dzien();
    Data ob2(dzien2, miesiac2, rok2);

    int roznica_dni = ob2 - ob1;

    int godzina1 = ob.get_godzina();
    int minuta1 = ob.get_minuta();
    int sekunda1 = ob.get_sekunda();
    int godzina2 = datg.get_godzina();
    int minuta2 = datg.get_minuta();
    int sekunda2 = datg.get_sekunda();

    int64_t licz_sekund1 = 3600*godzina1 + 60*minuta1 + sekunda1;
    int64_t licz_sekund2 = 3600*godzina2 + 60*minuta2 + sekunda2;
    int64_t dzien_sekund = 86400;
    if(roznica_dni == 0) {return abs(licz_sekund1 - licz_sekund2);}
    else
    {
        int64_t wynik = (dzien_sekund-licz_sekund1) + licz_sekund2;
        for(int i=1; i<roznica_dni; i++)
        {
            wynik = wynik + dzien_sekund;
        }
        return wynik;
    }
}

// operator inkrementacji (o 1 sekunde)
DataGodz& DataGodz::operator++ (int)
{
    godzina = this->godzina;
    minuta  = this->minuta;
    sekunda = this->sekunda;
    dzien = this->get_dzien();
    miesiac = this->get_miesiac();
    rok = this->get_rok();
    Data ob(dzien, miesiac, rok);
    if(sekunda == 59)
    {
        if(minuta == 59)
        {
            if(godzina == 23)
            {
                ob++;
                DataGodz k1(0, 0, 0, ob);
                *this = k1;
            }
            else
            {
                this->godzina = godzina+1;
                this->minuta = 0;
                this->sekunda = 0;
            }
        }
        else
        {
            this->minuta = minuta+1;
            this->sekunda = 0;
        }
    }
    else this->sekunda = sekunda+1;
    return *this;
}

// operator dekrementacji (o 1 sekunde)
DataGodz& DataGodz::operator-- (int)
{
    godzina = this->godzina;
    minuta  = this->minuta;
    sekunda = this->sekunda;
    dzien = this->get_dzien();
    miesiac = this->get_miesiac();
    rok = this->get_rok();
    Data ob(dzien, miesiac, rok);
    if(sekunda == 0)
    {
        if(minuta == 0)
        {
            if(godzina == 0)
            {
                ob--;
                DataGodz k1(23, 59, 59, ob);
                *this = k1;
            }
            else
            {
                this->godzina = godzina-1;
                this->minuta = 59;
                this->sekunda = 59;
            }
        }
        else
        {
            this->minuta = minuta-1;
            this->sekunda = 59;
        }
    }
    else this->sekunda = sekunda-1;
    return *this;
}

// operator dodawania zadanej liczby sekund do godziny
DataGodz& DataGodz::operator+= (int i)
{
    DataGodz d1 = *this;
    for(int j=0; j<i; j++)
    {
        d1++;
    }
    *this = d1;
    return *this;
}

// operator odejmowania zadanej liczby sekund do godziny
DataGodz& DataGodz::operator-= (int i)
{
    DataGodz d1 = *this;
    for(int j=0; j<i; j++)
    {
        d1--;
    }
    *this = d1;
    return *this;
}

//operator relacyjny mniejszosci
bool DataGodz::operator< (DataGodz& datg)
{
    DataGodz ob = *this;
    int rok1 = ob.get_rok();
    int miesiac1 = ob.get_miesiac();
    int dzien1 = ob.get_dzien();
    int godzina1 = this->godzina;
    int minuta1 = this->minuta;
    int sekunda1 = this->sekunda;

    int rok2 = datg.get_rok();
    int miesiac2 = datg.get_miesiac();
    int dzien2 = datg.get_dzien();
    int godzina2 = datg.get_godzina();
    int minuta2 = datg.get_minuta();
    int sekunda2 = datg.get_sekunda();

    if(rok1 > rok2) return false;
    if(rok1 == rok2)
    {
        if(miesiac1 > miesiac2) return false;
        if(miesiac1 == miesiac2)
        {
           if(dzien1 > dzien2) return false;
           if(dzien1 == dzien2)
           {
               if(godzina1 > godzina2) return false;
               if(godzina1 == godzina2)
               {
                   if(minuta1 > minuta2) return false;
                   if(minuta1 == minuta2)
                   {
                       if(sekunda1 >= sekunda2) return false;
                   }
               }
           }
        }
    }
    return true;
}

// operator relacyjny rownosci
bool DataGodz::operator== (DataGodz& datg)
{
    DataGodz ob = *this;
    int rok1 = ob.get_rok();
    int miesiac1 = ob.get_miesiac();
    int dzien1 = ob.get_dzien();
    int godzina1 = this->godzina;
    int minuta1 = this->minuta;
    int sekunda1 = this->sekunda;

    int rok2 = datg.get_rok();
    int miesiac2 = datg.get_miesiac();
    int dzien2 = datg.get_dzien();
    int godzina2 = datg.get_godzina();
    int minuta2 = datg.get_minuta();
    int sekunda2 = datg.get_sekunda();

    if((rok1 == rok2) && (miesiac1 == miesiac2) && (dzien1 == dzien2)
        && (godzina1 == godzina2) && (minuta1 == minuta2) && (sekunda1 == sekunda2)) return true;
    else return false;
}

/************************************************************* WYDARZENIE ***********************************************************/


// konstruktor przyjmuje punkt czasowy i opis wydarzenia
Wydarzenie::Wydarzenie(DataGodz& d, string op)
{
    dg = d;
    opis = op;
}

//operator porownania
bool Wydarzenie::operator< (Wydarzenie& w)
{
    Wydarzenie ob = *this;

    int rok = ob.dg.get_rok();
    int miesiac = ob.dg.get_miesiac();
    int dzien = ob.dg.get_dzien();
    int godzina = ob.dg.get_godzina();
    int minuta = ob.dg.get_minuta();
    int sekunda = ob.dg.get_sekunda();

    Data dat(dzien, miesiac, rok);
    DataGodz dg(godzina, minuta, sekunda, dat);
    return (dg<w.dg);
}
