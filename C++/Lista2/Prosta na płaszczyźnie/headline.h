#include <iostream>
#define EPSILON 0.1

using namespace std;

class Point
{
    public:
    //attributes
    const double x = 0.0;
    const double y = 0.0;
    // constructors
    Point() = default;                          //1 konstruktor defaultowy
    Point(const double x, const double y);      //2 konstruktor ze wspólrzednymi
    Point(const double x, const double y, const double x1, const double y1); //3 konstruktor przesuwa o podane wspólrzedne wektora
};


class Vector
{
    public:
    //attributes
    const double dx;
    const double dy; //kierunki wektora
    // constructors
    Vector() = default; //1 konstruktor defaultowy
    Vector(const double dx, const double dy); //2 konstruktor ze wspólrzednymi
    Vectr(const Vector& v1);
};


class Line
{
    //attributes
    double a = 1.0;
    double b = 0.0;
    double c = 0.0; //wspólczynniki równania Ax+By+C=0
    public:
    //gettery
    double get_a() const
    {
        return this ->a;
    }
    double get_b() const
    {
        return this ->b;
    }
    double get_c() const
    {
        return this ->c;
    }
    // constructors
    Line(double x1,double y1, double x2,double y2);         //1 konstruktor
    Line(double x, double y);                               //2 konstruktor
    Line(double x, double y, double z);                     //3 konstruktor
    Line(double a, double b, double c, double x, double y); //4 konstruktor
    Line();                                                 //5 konstruktor bezparametrowy
    Line(const Line& obj)= delete;                          //6 konstruktor kopiujacy klasa jest niekopiowalna
    Line& operator=(const Line& obj) = delete;              //operator przypisania
    // functions
    void normalization();
    bool perpendicular(double x, double y);
    bool parallel(double x, double y);
    bool point_on_line(double x, double y);
    void form();
};


