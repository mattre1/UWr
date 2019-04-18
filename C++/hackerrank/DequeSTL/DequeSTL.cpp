#include <iostream>
#include <deque> 
using namespace std;

void printKMax(int arr[], int n, int k){
	std::deque<int> dq(k);

    for(int i=0;i<k;++i){
        
        while(!dq.empty() and arr[i] >= arr[dq.back()]){
            dq.pop_back();
        }

        dq.push_back(i);
    } //we have dq that contain greatest element of first subarray

    for(int i=k;i<n;++i) {
        std::cout<<arr[dq.front()]<<" "; //print greatest element of current subarray

        while (!dq.empty() and dq.front() <= i-k) {
          dq.pop_front();
        }

        while (!dq.empty() and arr[i] >= arr[dq.back()]) {
          dq.pop_back();
        }

        dq.push_back(i);
    }
    std::cout << arr[dq.front()]<<std::endl; //last subarray maximum
}

int main(){
  
	int t;
	cin >> t;
	while(t>0) {
		int n,k;
    	cin >> n >> k;
    	int i;
    	int arr[n];
    	for(i=0;i<n;i++)
      		cin >> arr[i];
    	printKMax(arr, n, k);
    	t--;
  	}
  	return 0;
}

