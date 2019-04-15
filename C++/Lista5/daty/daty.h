#include <iostream>

using namespace std;

/******************************************************** KLASA DATA ********************************************************/

//przechowuje date w kalendarzu gregorianskim
//pierwszy dzien-> 25.10.1582
class Data
{
protected:
    int dzien;
    int miesiac;
    int rok;

public:
//gettery
    get_dzien()     {return dzien;}
    get_miesiac()   {return miesiac;}
    get_rok()       {return rok;}


    // tablica statyczna przechowuje ilosc dni w miesiacach
    // roku przestepnego i nieprzestepnego
    constexpr static int dniwmiesiacach[2][13] = {
        {0,31,28,31,30,31,30,31,31,30,31,30,31},    // lata zwykle
        {0,31,29,31,30,31,30,31,31,30,31,30,31}     // lata przestepne
    };

    // tablica statyczna przechowuje ilosc dni ktore uplynely od poczatku roku
    // w latach przestepnych i nieprzestepnych
    constexpr static int dniodpoczroku[2][13] = {
        {0,31,59,90,120,151,181,212,243,273,304,334,365},   // lata zwykle
        {0,31,60,91,121,152,182,213,244,274,305,335,366}    // lata przestepne
    };


    //konstruktory, operatory
    Data(int d, int m, int r);                      // 1 konstruktor z podana data
    Data();                                         // 2 konstruktor bezparametrowy

    int operator- (Data& d);                        // operator odejmowania dat
    Data& operator++ (int);                         // operator inkrementacji dnia
    Data& operator-- (int);                         // operator dekrementacji dnia
    Data& operator+= (int i);                       // operator dodawania zadanej liczby dni do daty
    Data& operator-= (int i);                       // operator odejmowania zadanej liczby dni od daty

    //metody
    public: static bool przestepny(int r);                   // sprawdza czy podany rok jest przestepny

    private: bool dobra_data(int d, int m, int r);           // sprawdza czy podana data jest poprawna

    public: int ileDni(const Data& dat);                     // sprawdza ile dni uplynelo do podanej daty

};

/************************************************* KLASA DATAGODZ ******************************************************/

//klasa dziedziczy z klasy Data
//przechowuje dodatkowo czas
class DataGodz : public Data
{
    int godzina;
    int minuta;
    int sekunda;
public:
//gettery
    get_godzina()   {return godzina;}
    get_minuta()    {return minuta;}
    get_sekunda()   {return sekunda;}


    //konstruktory, operatory
    DataGodz(int g, int m, int s, Data& dt);                // 1 konstruktor z parametrami domyslnymi
    DataGodz();                                             // 2 konstruktor bezparametrowy

    int operator- (DataGodz& datg);                         // operator odejmowania godzin (roznica pomiedzy 2 punktami czasowymi)
    DataGodz& operator++ (int);                             // operator inkrementacji (o 1 sekunde)
    DataGodz& operator-- (int);                             // operator dekrementacji (o 1 sekunde)
    DataGodz& operator+= (int i);                           // operator dodawania zadanej liczby sekund do godziny
    DataGodz& operator-= (int i);                           // operator odejmowania zadanej liczby sekund do godziny
    bool operator< (DataGodz& datg);                        // operator relacyjny mniejszosci
    bool operator== (DataGodz& datg);                       // operator relacyjny rownosci
};

/********************************************************** KLASA WYDARZENIE **********************************************************/

// klasa przechowuje punkt czasowy i skojarzone z nim wydarzenie
class Wydarzenie
{
public:
    DataGodz dg;
    string opis;

    Wydarzenie(DataGodz& d, string op); // konstruktor przyjmuje punkt czasowy i opis wydarzenia

    bool operator< (Wydarzenie& w);     // operator sprawdza czy wydarzenie zaszlo wczesniej (dla funkcji sortujacej)

};

