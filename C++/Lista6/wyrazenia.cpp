//
// Created by JA on 3/31/2018.
//
#include <string>
#include <cmath>
#include <sstream>
#include <algorithm>
#include <vector>
#include "wyrazenia.hpp"

vector<pair<string, double>> Zmienna::vector1;

Liczba::Liczba(double x) : licz(x)
{}

string Liczba::opis()  const
{
    string to_string(const double& licz);
    stringstream sst;
    sst<<licz;
    return sst.str();
}

double Liczba::oblicz() const
{
    return licz;
}

string Pi::opis() const
{
    return "pi";
}

double Pi::oblicz() const
{
    return p;
}

string E::opis() const
{
    return "e";
}

double E::oblicz() const
{
    return e;
}

string Fi::opis() const
{
    return "fi";
}

double Fi::oblicz() const
{
    return f;
}

Dodaj::Dodaj(Wyrazenie* obl, Wyrazenie* obr) : lwyr(obl), pwyr(obr)
{}

string Dodaj::opis() const
{
    return ("(" + lwyr->opis() + " + " + pwyr->opis() + ")");
}

double Dodaj::oblicz() const
{
    return lwyr->oblicz()+pwyr->oblicz();
}

Odejmij::Odejmij(Wyrazenie* obl, Wyrazenie* obr) : lwyr(obl), pwyr(obr)
{}

string Odejmij::opis() const
{
    return ("(" + lwyr->opis() + " - " + pwyr->opis() + ")");
}

double Odejmij::oblicz() const
{
    return lwyr->oblicz()-pwyr->oblicz();
}

Mnoz::Mnoz(Wyrazenie *obl, Wyrazenie *obr) : lwyr(obl), pwyr(obr)
{}

string Mnoz::opis() const
{
    return ("(" + lwyr->opis() + " * " + pwyr->opis() + ")");
}

double Mnoz::oblicz() const
{
    return lwyr->oblicz()*pwyr->oblicz();
}

Dziel::Dziel(Wyrazenie* obl, Wyrazenie* obr) : lwyr(obl), pwyr(obr)
{
    if(obr->oblicz() == 0) throw invalid_argument("Dzielenie przez 0");
}

string Dziel::opis() const
{
    return ("(" + lwyr->opis() + " / " + pwyr->opis() + ")");
}

double Dziel::oblicz() const
{
    return lwyr->oblicz()/pwyr->oblicz();
}

Potega::Potega(Wyrazenie* obl, Wyrazenie* obr) : pod(obl), wyk(obr)
{}

string Potega::opis() const
{
    return ("(" + pod->opis() + " ^ " + wyk->opis() + ")");
}

double Potega::oblicz() const
{
    return pow(pod->oblicz(), wyk->oblicz());
}

Modulo::Modulo(Wyrazenie* obl, Wyrazenie* obr) : lwyr(obl), pwyr(obr)
{
    if(obr->oblicz() == 0) throw invalid_argument("Dzielenie przez 0");
}

string Modulo::opis() const
{
    return ("(" + lwyr->opis() + " mod " + pwyr->opis() + ")");
}

double Modulo::oblicz() const
{
    return fmod(lwyr->oblicz(), pwyr->oblicz());
}

Logarytm::Logarytm(Wyrazenie* obl, Wyrazenie* obr) : pod(obl), licz(obr)
{
    if((obl->oblicz() <= 0) || (obl->oblicz() == 1) || (obr->oblicz() <= 0)) throw invalid_argument("Argumenty logarytmu poza dziedzina");
}

string Logarytm::opis() const
{
    return ("(log " + pod->opis() + " " + licz->opis() + ")");
}

double Logarytm::oblicz() const
{
    return (log(licz->oblicz())/log(pod->oblicz()));
}

Sin::Sin(Wyrazenie* ob) : wyr(ob)
{}

string Sin::opis() const
{
    return ("(sin " + wyr->opis() + ")");
}

double Sin::oblicz() const
{
    return sin(wyr->oblicz());
}

Cos::Cos(Wyrazenie* ob) : wyr(ob)
{}

string Cos::opis() const
{
    return ("(sin " + wyr->opis() + ")");
}

double Cos::oblicz() const
{
    return sin(wyr->oblicz());
}

Exp::Exp(Wyrazenie* ob) : wyr(ob)
{}

string Exp::opis() const
{
    return ("(e ^ " + wyr->opis() + ")");
}

double Exp::oblicz() const
{
    return exp(wyr->oblicz());
}

Bezwzgl::Bezwzgl(Wyrazenie *ob) : wyr(ob)
{}

string Bezwzgl::opis() const
{
    return ("(abs " + wyr->opis() + ")");
}

double Bezwzgl::oblicz() const
{
    return abs(wyr->oblicz());
}

Przeciw::Przeciw(Wyrazenie* ob) : wyr(ob)
{}

string Przeciw::opis() const
{
    return ("(-  " + wyr->opis() + ")");
}

double Przeciw::oblicz() const
{
    return -wyr->oblicz();
}

Odwrot::Odwrot(Wyrazenie* ob) : wyr(ob)
{
    if (ob->oblicz() == 0) throw invalid_argument("Dzielenie przez 0");
}

string Odwrot::opis() const
{
    return ("(1 / " + wyr->opis() + ")");
}

double Odwrot::oblicz() const
{
    return (1/wyr->oblicz());
}

// Zmienne //

Zmienna::Zmienna(string s) : nazwa(s)
{}

void Zmienna::wypelnij_zmienne()
{
    pair <string, double> p1("x", 1.5);
    pair <string, double> p2("y", 3.0);
    pair <string, double> p3("z", 115.25);
    vector1.push_back(p1);
    vector1.push_back(p2);
    vector1.push_back(p3);
}

double Zmienna::znajdz_wartosc(string s)
{
    for (auto &i : vector1) {
        if(i.first == s) return i.second;
    }
    throw invalid_argument("Nie ma takiej zmiennej");
}

void Zmienna::ustaw(pair <string, double> p)
{
    vector1.push_back(p);
}

void Zmienna::zamiana_wartosci(string s, double v)
{
    for (auto &i : vector1) {
        if(i.first == s) i.second = v;
    }
}

double Zmienna::oblicz() const
{
    return znajdz_wartosc(nazwa);
}

string Zmienna::opis() const
{
    return nazwa;
}
