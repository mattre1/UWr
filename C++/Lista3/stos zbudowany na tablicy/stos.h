#include <iostream>
#include <string>

using namespace std;

class Stack
{
    public:
    //attributes
    int maxsize;            //pojemnosc
    int size_of_stack;      //liczba elementow przechowywanych na stosie
    string* stk = nullptr;  //tablica dynamiczna napisow

    public:
    //methods
        void push(const string&);   //wklada napis na stos
        string pop();               //sciaga napis ze stosu i zwraca go
        string check() const;       //sprawdza jaki napis lezy na wierzchu stosu
        int sizes() const;          //zwraca liczbe wszystkich elementow na stosie
        void print() const;         //wyswietla kolejne elementy stosu
    //constructors
        Stack(int);                                 //1 konstruktor z zadana pojemnoscia
        Stack();                                    //2 konstruktor bezparametrowy delegatowy
        Stack(initializer_list<string>);            //3 kontruktor inicjalizujacy stos za pomoca listy napisow
        Stack(const Stack&);                        //4 konstruktor kopiujacy
        Stack(Stack&&);                             //5 konstruktor przenoszacy

        Stack & operator=(const Stack&);            //operator kopiujacy
        Stack & operator=(Stack&&);                 //operator przypisania
        ~Stack();                                   //destruktor

};
