#include <iostream>
#include <cmath>
#include <algorithm>
#include <cstdlib>
#include "headline.h"
#define EPSILON 0.1

using namespace std;

//constructors

//2 konstruktor ze wspólrzednymi(1-szy defaultowy)
Vector::Vector(const double _dx, const double _dy): dx(_dx), dy(_dy)
    {}

//2 konstruktor ze wspólrzednymi
Point::Point(const double _x, const double _y): x(_x), y(_y)
    {}

//3 konstruktor przesuwa o podane wspólrzedne wektora
Point::Point(const double _x, const double _y, const double _x1, const double _y1): x(_x+_x1), y(_y+_y1)
    {}

//1 konstruktor z para punktów przecinajacych prosta
Line::Line(double x1, double y1, double x2, double y2)
    {
        if((y1-y2)==0 && (x2-x1)==0)
        {
            cout<<"Wspolczynniki A i B nie moga byc jednoczesnie zerem";
            throw invalid_argument("nie można jednoznacznie utworzyć prostej");
        }
        this ->a=y1-y2;
        this ->b=x2-x1;
        this ->c=(y2*x1)-(y1*x1)+(x1*y1)-(x2*y1);
        normalization();
    }

// 2 konstruktor wyznacza prosta prostopadla do wektora przechodzacego przez podane wspólrzedne
Line::Line(double x, double y)
    {
        if(x==0 && y==0)
        {
            cout<<"Wspolczynniki A i B nie moga byc jednoczesnie zerem";
            throw invalid_argument("nie można jednoznacznie utworzyć prostej");
        }
        this ->a=x;
        this ->b=y;
        this ->c=0;
        normalization();
    }

//3 konstruktor z podanymi wspólczynnikami w postaci ogólnej
Line::Line(double x, double y, double z)
    {
        if(x==0 && y==0)
        {
            cout<<"Wspolczynniki A i B nie moga byc jednoczesnie zerem";
            throw invalid_argument("nie można jednoznacznie utworzyć prostej");
        }
        this ->a=x;
        this ->b=y;
        this ->c=z;
        normalization();
    }

//4 konstruktor z prosta i wektorem o który ma byc przesunieta
Line::Line(double a, double b, double c, double x, double y)
    {
        if(a==0 && b==0)
        {
            cout<<"Wspolczynniki A i B nie moga byc jednoczesnie zerem";
            throw invalid_argument("nie można jednoznacznie utworzyć prostej");
        }
        this ->a=a;
        this ->b=b;
        this ->c=c+(a*x/b)+y;
        normalization();
    }

//5 konstruktor bezparametrowy
Line::Line(): a(0), b(1), c(0)
    {}

//methods

void Line::normalization()
    {
        double divider = std::sqrt(a*a + b*b);
        if(c<=0) c=c/divider;
        else c=(c*(-1))/divider;
        a=a/divider;
        b=b/divider;
    }

bool Line::perpendicular(double dx, double dy)   {
        return ((abs(a-dx)<=EPSILON) && (abs(b-dy)<=EPSILON));
        }

bool Line::parallel(double dx,double dy)
    {
        return (abs(((a/b) - dy) <= EPSILON) && (abs(dx-1) <= EPSILON));
           }

bool Line::point_on_line(double x, double y)
    {
        return (a*x+b*y+c==0);    }


void Line::form()
{
    cout<<"y = "<<a/(-b)<<"*x + "<<c/(-b)<<endl;
}

