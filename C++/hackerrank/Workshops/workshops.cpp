#include<bits/stdc++.h>

using namespace std;
#include <algorithm>

//Define the structs Workshops and Available_Workshops.
//Implement the functions initialize and CalculateMaxWorkshops
struct Workshop {
    int start_time,duration,end_time;
    Workshop(int st,int d,int et) : start_time(st),duration(d),end_time(et) {}
};

struct Available_Workshops {
    int n;
    std::vector <Workshop> allWorkshops;
};

Available_Workshops* initialize (int start_time[], int duration[], int n) {

  Available_Workshops* avblWorkshops = new Available_Workshops;
  avblWorkshops->n=n;
  for(int i=0;i<n;++i) {
    Workshop workshop(start_time[i], duration[i], start_time[i]+duration[i]);
    avblWorkshops->allWorkshops.push_back(workshop);
  }
  return avblWorkshops;
}
bool operator<(Workshop const &a, Workshop const &b) { 
    return a.end_time < b.end_time; 
}

int CalculateMaxWorkshops(Available_Workshops* ptr) {
    std::vector<Workshop> sortedWorkshops = ptr->allWorkshops;
    std::sort(sortedWorkshops.begin(), sortedWorkshops.end());
    
    Workshop previous = sortedWorkshops[0];
    int max = 1;
    for(auto current : sortedWorkshops) {
        if(previous.end_time <= current.start_time) {
            max++;
            previous = current;
        }
    }
    return max;
} 

int main(int argc, char *argv[]) {
    int n; // number of workshops
    cin >> n;
    // create arrays of unknown size n
    int* start_time = new int[n];
    int* duration = new int[n];

    for(int i=0; i < n; i++){
        cin >> start_time[i];
    }
    for(int i = 0; i < n; i++){
        cin >> duration[i];
    }

    Available_Workshops * ptr;
    ptr = initialize(start_time,duration, n);
    cout << CalculateMaxWorkshops(ptr) << endl;
    return 0;
}
