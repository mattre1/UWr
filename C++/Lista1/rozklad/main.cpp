#include <iostream>
#include <cstdlib>
#include <cmath>
#include <vector>
#include <string>
#include <algorithm>

using namespace std;
void printhelp(int64_t tab)
{
    cout<<tab<<"*";
}
void prime(vector <int64_t> tab)
{
    if(tab.size()==1)
    {
        cout<<"Liczba pierwsza"<<endl;
    }
}
void print(int64_t liczba,vector <int64_t> tab)
{
    prime(tab);
    cout<<liczba<<" = ";
    for_each(tab.begin(), tab.end()-1, printhelp);
    cout<<tab.back();
    cout<<endl;
}
vector<int64_t> rozklad(int64_t n)
{
    vector <int64_t> tab;
    if(n == -9223372036854775808)
      {
        tab.push_back(-1);
        for(int i=0;i<63;i++)
        {
            tab.push_back(2);
        }
        return tab;
      }
    if(n==-1 || n==0 || n==1)
    {
        tab.push_back(n);
        return tab;
    }
    if(n<0)
    {
        n=(-1)*n;
        tab.push_back(-1);
    }
    int64_t b=std::sqrt<int64_t>(n);
    for(int64_t i=2;i<=b;i++)
    {
        while(n%i==0)
        {
            tab.push_back(i);
            n=n/i;
        }
        if(n==1)
        {
            break;
        }
    }
    if(n>1)
    {
        tab.push_back(n);
    }
    return tab;
}
int legitcheck(string napis,int argc,char *argv[])
{
    for(int i=1;i<argc;i++)
        {
            napis=argv[i];
            int length = napis.length();
            for(int j=0;j<length;j++)
                {
                    if((napis[j]<48 || napis[j]>57) && (napis[j]!=45))
                        {
                            throw invalid_argument("Jeden z argumentow nie jest liczba. Sprawdz jeszcze raz.");
                            return 1;
                        }
                }
        }
   /* if(napis>"9223372036854775807" || napis=="-9223372036854775808")
    {
        throw invalid_argument("Jeden z argumentow przekracza zasieg int64_t.");
        return 1;
    }*/
    return 0;

}
int main(int argc, char *argv[])
{
    int64_t liczba;
    vector <int64_t> tab;
    string napis;
    cout<<std::numeric_limits<int64_t>::min()<<endl;
    cout<<std::numeric_limits<int64_t>::max();
    if(argc<2)
    {
        cerr<<"Nie podales zadnego argumentu. Argumentami wywolania programu powinny byc liczby calkowite dajace sie zapisac w zmiennej typu int64_t.";
        return 1;
    }
    for(int64_t i=1;i<argc;i++)
        {
            //legitcheck(argv[i],argc,argv);
            liczba=std::stoll(argv[i]);
            tab=rozklad(liczba);
            print(liczba,tab);
        }
    int x;
    cin>>x;
    return 0;
}
