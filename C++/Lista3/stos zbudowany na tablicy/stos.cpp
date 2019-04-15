#include <iostream>
#include <stdexcept>
#include <utility>
#include "stos.h"

using namespace std;

//methods

void Stack::push(const string& x)
{
    size_of_stack++;
    if(size_of_stack>maxsize) throw range_error("Stack overflow");
    stk[size_of_stack-1] = x;
}

string Stack::pop()
{
    size_of_stack--;
    return stk[size_of_stack];
}

string Stack::check() const
{
    return stk[size_of_stack-1];
}

int Stack::sizes() const
{
    return size_of_stack;
}

void Stack::print() const
{
    cout<<"Stack:"<<endl;
    for(int i=size_of_stack-1; i>=0; i--)
    {
        cout<<stk[i]<<endl;
    }
}


//constructors
//1 konstruktor z zadana pojemnoscia
Stack::Stack(int k) : maxsize(k), size_of_stack(0), stk(new string[k]) {}

//2 konstruktor bezparametrowy delegatowy
Stack::Stack() : Stack(1) {}

//3 kontruktor inicjalizujacy stos za pomoca listy napisow
Stack::Stack(initializer_list<string> l) : maxsize(17), size_of_stack(0), stk(new string[l.size()])
{
    for(initializer_list<string>::iterator it=l.begin(); it!=l.end(); it++)
    {
        push(*it);
    }
}

//4 konstruktor kopiujacy
Stack::Stack(const Stack& x) : maxsize(x.maxsize), size_of_stack(0), stk(new string[x.maxsize])
{
    for(int i=0; i<x.size_of_stack; i++)
    {
        push(x.stk[size_of_stack]);
    }
}

//5 konstruktor przenoszacy
Stack::Stack(Stack&& x) : maxsize(x.maxsize), size_of_stack(x.size_of_stack), stk(x.stk)
{
    x.stk = nullptr;
}


//operator kopiujacy
Stack & Stack::operator= (const Stack& s)
{
    return Stack(s);
}

//operator przenoszacy
Stack & Stack::operator= (Stack&& s)
{
    if(&s==this)
    {
        return *this;
    }
    maxsize = s.maxsize;
    size_of_stack = s.size_of_stack;
    stk = s.stk;
    s.stk = nullptr;
    return *this;
}


//destruktor
Stack::~Stack()
{
    delete [] stk;
}





//listy inicjalizacyjne w konstruktorach np. Stos() : ile(0) - bezparametrowy
//wszystkie funkcje które nie modyfikuja obiektu - type name() const
//valgrind  ./stos na linuxie


