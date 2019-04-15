#include <iostream>
#include "stos.h"

using namespace std;

int main()
{
    Stack s1(17);
    //s1.push(12);
    Stack s2(s1);

    int i = 1;
    string napis;
    cout<<"Wybierz opcje:"<<endl;
    cout<<"1. Wstaw napis do stosu"<<endl;
    cout<<"2. Usun napis ze stosu"<<endl;
    cout<<"3. Ilosc elementow na stosie"<<endl;
    cout<<"4. Wypisz wszystkie elementy stosu"<<endl;
    cout<<"5. Wyjscie"<<endl;
    while(i!=5)
    {
        cout<<endl;
        cout<<">";
        cin>>i;
        cout<<endl;
        switch(i)
        {
        case 1:
            cout<<"Podaj napis do wstawienia: ";
            cin>>napis;
            s1.push(napis);
            break;
        case 2:
            cout<<"Usuniety element: "<<s1.pop();
            break;
        case 3:
            cout<<s1.sizes();
            break;
        case 4:
            s1.print();
            break;
        case 5:
            break;

        }
        cout<<endl;
    }

    return 0;
}
