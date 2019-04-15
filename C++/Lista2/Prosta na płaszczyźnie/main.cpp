#include <iostream>
#include <cmath>
#include "headline.h"

using namespace std;

//global functions

bool global_perpendicular(const Line &lin1, const Line &lin2)
{
    return(std::abs((-lin1.get_a()/lin1.get_b())*(-lin2.get_a()/lin2.get_b())+1)<=EPSILON);
}
bool global_parallel(const Line &lin1, const Line &lin2)
{
    return(std::abs(lin1.get_a()*lin2.get_b()-(lin2.get_a()*lin1.get_b()))<=EPSILON);
}
void point_of_cross(const Line &lin1, const Line &lin2)
{
    double x;
    double y;
    if(global_parallel(lin1,lin2))
    {
        cout<<"Nie ma punktu przeciecia, bo proste sa rownolegle";
        return;
    }
    else
    {
       x=(lin2.get_c()/lin2.get_b()-lin1.get_c()/lin1.get_b())/(lin1.get_a()/lin1.get_b()-lin2.get_a()/lin2.get_b());
       y=(-(lin1.get_a())*x)/lin1.get_b()-(lin1.get_c()/lin1.get_b());
    }
    cout<<"point of cross: "<<x<<" "<<y<<endl;
}
void compound(const Vector &v1, const Vector &v2)
{
    double dx=v1.dx+v2.dx;
    double dy=v1.dy+v2.dy;
    cout<<"compound: "<<dx<<" "<<dy<<endl;
    }

int main()
 {
    Line lin1(-1,1,1);
    lin1.form();
    cout<<"Normalization:"<<endl;
    cout<<lin1.get_a()<<" "<<lin1.get_b()<<" "<<lin1.get_c()<<endl;
    Line lin2(-1,1,1);
    cout<<lin2.get_a()<<" "<<lin2.get_b()<<" "<<lin2.get_c()<<endl;
    cout<<"lin2 perpendicular: "<<lin2.perpendicular(1,1)<<endl;
    cout<<"lin2 parallel: "<<lin2.parallel(-1,1)<<endl;
    cout<<"lin2 point on line: "<<lin2.point_on_line(1,1)<<endl;
    cout<<"parallel: "<<global_parallel(lin1,lin2)<<endl;
    cout<<"perpendicular: "<<global_perpendicular(lin1,lin2)<<endl;
    point_of_cross(lin1,lin2);
    Vector v1(-1,-2);
    Vector v2(2,3);
    compound(v1,v2);

    return 0;
}
