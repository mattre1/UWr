#include <iostream>
#include <cstdlib>
#include <limits>

#include "wymierna.hpp"

namespace obliczenia
{
    Wymierna::Wymierna(int l, int m) throw(dzielenie_przez_0)
    {
        if(m == 0)
        {
            throw dzielenie_przez_0();
        }

        if(l > std::numeric_limits<int>::max())
        {
            throw przekroczenie_zakresu();
        }

        if(l == 0 || l == 1 || m == 1)
        {
            licz = l;
            mian = m;
        }
        else
        {
            int a = l;
            int b = m;
            while(a != b)
            {
                if(a < b) b -= a;
                else a -= b;
            }
            licz = l/a;
            mian = m/a;
        }
    }

    Wymierna::Wymierna(const Wymierna& ob) : licz(ob.licz), mian(ob.mian)
    {}

    Wymierna& Wymierna::operator = (const Wymierna& ob) noexcept
    {
        this->licz = ob.licz;
        this->mian = ob.licz;
        return *this;
    }

    Wymierna::get_licz() const
    {
        return licz;
    }

    Wymierna::get_mian() const
    {
        return mian;
    }

    Wymierna& Wymierna::operator += (const Wymierna& ob) noexcept
    {
        int a = this->mian;
        int b = ob.mian;
        int t, ab;
        ab = a * b;

        while(b)
        {
            t = b;
            b = a % b;
            a = t;
        }
        ab /= a;

        this->licz = (this->licz * (ab/this->mian)) + (ob.licz * (ab/ob.mian));
        this->mian = ab;

        return *this;
    }

    Wymierna& Wymierna::operator -= (const Wymierna& ob) noexcept
    {
        int a = this->mian;
        int b = ob.mian;
        int t, ab;
        ab = a * b;
        while(b)
        {
            t = b;
            b = a % b;
            a = t;
        }
        ab /= a;
        this->licz = (this->licz * (ab/this->mian)) - (ob.licz * (ab/ob.mian));
        this->mian = ab;
        return *this;
    }

    Wymierna& Wymierna::operator *= (const Wymierna& ob) throw(przekroczenie_zakresu)
    {
        long long int l1 = this->licz;
        long long int m1 = this->mian;
        long long int l2 = ob.licz;
        long long int m2 = ob.mian;
        long long int licz = l1*l2;
        long long int mian = m1*m2;

        if(licz > std::numeric_limits<int>::max() || licz < std::numeric_limits<int>::lowest() || mian > std::numeric_limits<int>::max())
           {
               throw przekroczenie_zakresu();
           }

        int a = licz;
        int b = mian;
        while(a != b)
        {
            if(a < b) b -= a;
            else a -= b;

        }
        this->licz = licz/a;
        this->mian = mian/a;
        return *this;
    }

    Wymierna& Wymierna::operator /= (const Wymierna& ob) throw(dzielenie_przez_0, przekroczenie_zakresu)
    {
        if(ob.licz == 0)
        {
            throw dzielenie_przez_0();
        }

        long long int l1 = this->licz;
        long long int m1 = this->mian;
        long long int l2 = ob.licz;
        long long int m2 = ob.mian;
        long long int licz = l1*m2;
        long long int mian = m1*l2;

        if(licz > std::numeric_limits<int>::max() || licz < std::numeric_limits<int>::lowest() || mian > std::numeric_limits<int>::max())
        {
            throw przekroczenie_zakresu();
        }

        int a = licz;
        int b = mian;
        while(a != b)
        {
            if(a < b) b -= a;
            else a -= b;

        }
        this->licz = licz/a;
        this->mian = mian/a;
        return *this;
    }

    Wymierna& Wymierna::operator - () noexcept
    {
        this->licz = (-1)*this->licz;
        return *this;
    }

    Wymierna& Wymierna::operator ! () noexcept
    {
        int sign = 1;
        if(this->licz < 0) sign = -1;
        int tmp = abs(this->licz);
        this->licz = sign*this->mian;
        this->mian = tmp;
        return *this;
    }

    std::ostream& operator << (std::ostream &wyj, const Wymierna &w) noexcept
    {
        double res = static_cast<double>(w.licz)/static_cast<double>(w.mian);
        wyj<<res<<std::endl;
        return wyj;
    }

    Wymierna::operator double () const
    {
        return (1.0 * licz/mian);
    }

    Wymierna::operator int () const
    {
        return (licz/mian);
    }


    const char* dzielenie_przez_0::what()
    {
        return "Dzielenie przez 0!";
    }

    const char* przekroczenie_zakresu::what()
    {
        return "Przekroczenie zakresu typu!";
    }

}
