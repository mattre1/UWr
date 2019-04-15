#include <iostream>

namespace obliczenia
{

    class wyjatek_wymierny : public std::exception
    {
    public:
        virtual const char* what() = 0;
    };

    class dzielenie_przez_0 : public wyjatek_wymierny
    {
    public:
        const char* what();
    };

    class przekroczenie_zakresu : public wyjatek_wymierny
    {
    public:
        const char* what();
    };


    class Wymierna
    {
        int licz;
        int mian;

    public:
        int get_licz() const;
        int get_mian() const;

        Wymierna(int l=1, int m=1) throw(dzielenie_przez_0);
        Wymierna(const Wymierna& ob);
        Wymierna& operator = (const Wymierna& ob) noexcept;

        Wymierna& operator += (const Wymierna& ob) noexcept;
        Wymierna& operator -= (const Wymierna& ob) noexcept;
        Wymierna& operator *= (const Wymierna& ob) throw(przekroczenie_zakresu);
        Wymierna& operator /= (const Wymierna& ob) throw(dzielenie_przez_0, przekroczenie_zakresu);

        Wymierna& operator - () noexcept;
        Wymierna& operator ! () noexcept;

        operator double () const;
        operator int () const;

        friend std::ostream& operator << (std::ostream &wyj, const Wymierna &w) noexcept;

    };






}
