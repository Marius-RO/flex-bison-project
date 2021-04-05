#include <iostream> 

using namespace std;

void exempluFunctieFaraParametri(){

}

void exempluFunctieCuParametri(int parametruInt,string parametruString){

}

int main(){

    // comentariu pe o singura linie

    //int primulNumar = "5"; // aici o sa fie eroare de sintaxa daca e scoasa din comentariu
    //string variabilaString = 123; // aici o sa fie eroare de sintaxa daca e scoasa din comentariu

    int primulNumar = 2;
    int alDoileaNumar = 20 * 20 / (19 + 1) - 2;

    if (5 > 2){
        exempluFunctieFaraParametri();
    }
    else {
        exempluFunctieFaraParametri();
    } 

    if (5 < 2){
        exempluFunctieCuParametri(10, "valoare-parametru-2");
    }

    while(5 > 2){
        //exempluFunctieCuParametri(1 + 2 * 3 / 0, "valoare" + "-parametru-4"); // eroare pt ca este impartire la 0
        exempluFunctieCuParametri(4 * 2 + 2 / 2, "valoare" + "-parametru" + "-4");
        break;
    }

    string variabilaString1 = "Hello";
    string variabilaString2 = "Hello" + "-World";

    /**
    *  COMENTARIU PE 
        MAI 
        MULTE
        LINII
    **/

    return 0;

}
