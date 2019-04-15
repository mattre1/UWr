#include <iostream>

#include "wymierna.hpp"

using std::endl;


using namespace obliczenia;

int main()
{
    try
    {
        Wymierna w1(2, 8);
        std::cout<<"w1: "<<w1.get_licz()<<"/";
        std::cout<<w1.get_mian()<<endl;

        Wymierna w2(2);
        std::cout<<"w2: "<<w2.get_licz()<<"/";
        std::cout<<w2.get_mian()<<endl;

        Wymierna w3(w2);
        std::cout<<"w3: "<<w3.get_licz()<<"/";
        std::cout<<w3.get_mian()<<endl;

        Wymierna w4 = w1;
        std::cout<<"w4: "<<w4.get_licz()<<"/";
        std::cout<<w4.get_mian()<<endl;

        std::cout<<endl;

        std::cout<<"Rzutowanie double w4: "<<(double)w4<<endl;
        std::cout<<endl;

        w1 += w2;
        std::cout<<"w1 += w2: "<<w1.get_licz()<<"/";
        std::cout<<w1.get_mian()<<endl;

        w1 *= w2;
        std::cout<<"w1 *= w2: "<<w1.get_licz()<<"/";
        std::cout<<w1.get_mian()<<endl;

        Wymierna w5(3,4);
        std::cout<<"w5: "<<w5.get_licz()<<"/";
        std::cout<<w5.get_mian()<<endl;

        w1 /=w5;
        std::cout<<"w1 /= w2: "<<w1.get_licz()<<"/";
        std::cout<<w1.get_mian()<<endl;

        -w5;
        std::cout<<"-w5: "<<w5.get_licz()<<"/";
        std::cout<<w5.get_mian()<<endl;

        !w5;
        std::cout<<"!w5: "<<w5.get_licz()<<"/";
        std::cout<<w5.get_mian()<<endl;

        std::cout<<"Operator ostream: "<<w5;

        Wymierna w6(0, 2);

        //w5/w6;


        Wymierna w7(2147483647, 1);
        Wymierna w8(3, 1);
        w7 *= w8;
        std::cout<<w7.get_licz()<<"/";



    }
    catch(dzielenie_przez_0& e)
    {
        std::cout<<e.what();
    }
    catch(przekroczenie_zakresu& e)
    {
        std::cout<<e.what();
    }

    return 0;
}
