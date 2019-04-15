#include <string>
#include <vector>
#include <iostream>

using namespace std;

// reprezentuje wyrazenie arytmetyczne (klasa bazowa)
class Wyrazenie
{
public:
    virtual string opis() const = 0;
    virtual double oblicz() const = 0;
};

// **************************************************************************** OPERANDY **************************************************************************** //

// reprezentuje liczbe w wyrazeniu
class Liczba : public Wyrazenie
{
    const double licz;
public:
    explicit Liczba(double x);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Zmienna : public Wyrazenie
{
    const string nazwa;
    static vector<pair<string, double>> vector1;
public:
    static void wypelnij_zmienne();
    static void ustaw(pair <string, double> p);
    static double znajdz_wartosc(string s);
    static void zamiana_wartosci(string s, double v);
    Zmienna(string s);
    string opis() const;
    double oblicz() const;
};

// PI = 3.141592
class Pi : public Wyrazenie
{
    static constexpr double p = 3.141592;
public:
    virtual string opis() const;
    virtual double oblicz() const;
};

// e = 2.718281
class E : public Wyrazenie
{
    static constexpr double e = 2.718281;
public:
    virtual string opis() const;
    virtual double oblicz() const;
};



// fi = 1.618033
class Fi : public Wyrazenie
{
    static constexpr double f = 1.618033;
public:
    virtual string opis() const;
    virtual double oblicz() const;
};

// ********************************************************************************** OPERATORY 2-arg ********************************************************************************** //

class Dodaj : public Wyrazenie
{
    Wyrazenie* lwyr;
    Wyrazenie* pwyr;
public:
    Dodaj(Wyrazenie* obl, Wyrazenie* obr);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Odejmij : public Wyrazenie
{
    Wyrazenie* lwyr;
    Wyrazenie* pwyr;
public:
    Odejmij(Wyrazenie* obl, Wyrazenie* obr);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Mnoz : public Wyrazenie
{
    Wyrazenie* lwyr;
    Wyrazenie* pwyr;
public:
    Mnoz(Wyrazenie* obl, Wyrazenie* obr);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Dziel : public Wyrazenie
{
    Wyrazenie* lwyr;
    Wyrazenie* pwyr;
public:
    Dziel(Wyrazenie* obl, Wyrazenie* obr);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Potega : public Wyrazenie
{
    Wyrazenie* pod;
    Wyrazenie* wyk;
public:
    Potega(Wyrazenie* obl, Wyrazenie* obr);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Modulo : public Wyrazenie
{
    Wyrazenie* lwyr;
    Wyrazenie* pwyr;
public:
    Modulo(Wyrazenie* obl, Wyrazenie* obr);
    virtual string opis() const;
    virtual double oblicz() const;
};

// log pod licz
class Logarytm : public Wyrazenie
{
    Wyrazenie* pod;
    Wyrazenie* licz;
public:
    Logarytm(Wyrazenie* obl, Wyrazenie* obr);
    virtual string opis() const;
    virtual double oblicz() const;
};

// ********************************************************************************** OPERATORY 1-arg ********************************************************************************** //

class Sin : public Wyrazenie
{
    Wyrazenie* wyr;
public:
    Sin(Wyrazenie* ob);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Cos : public Wyrazenie
{
    Wyrazenie* wyr;
public:
    Cos(Wyrazenie* ob);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Exp : public Wyrazenie
{
    Wyrazenie* wyr;
public:
    Exp(Wyrazenie* ob);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Bezwzgl : public Wyrazenie
{
    Wyrazenie* wyr;
public:
    Bezwzgl(Wyrazenie* ob);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Przeciw : public Wyrazenie
{
    Wyrazenie* wyr;
public:
    Przeciw(Wyrazenie* ob);
    virtual string opis() const;
    virtual double oblicz() const;
};

class Odwrot : public Wyrazenie
{
    Wyrazenie* wyr;
public:
    Odwrot(Wyrazenie* ob);
    virtual string opis() const;
    virtual double oblicz() const;
};