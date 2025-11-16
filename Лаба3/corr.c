#include <stdio.h>
#include <math.h>

int corr(int x[], int y[]){
    int znach = 0;
    for (int i = 0; i < 8; i++){
        znach += x[i]*y[i];
    }
    return znach;
}

float norm_corr(int x[], int y[]){
    float znach = 0;
    int sum_x = 0;
    int sum_y = 0;
    for (int i = 0; i < 8; i++){
        sum_x += pow(x[i],2);
        sum_y += pow(y[i],2);
    }
    int c = corr(x,y);
    znach = (c)/(sqrt(sum_x * sum_y));
    return znach;
}

int main(){
    int a[8] = {5,2,8,-2,-4,-4,1,3};
    int b[8] = {4,1,7,0,-6,-5,2,5};
    int c[8] = {-6,-1,-3,-9,2,-8,4,1};

    int ab_corr = 0, ac_corr = 0, bc_corr = 0;
    float ab_norm_corr = 0, ac_norm_corr = 0, bc_norm_corr = 0;

    ab_corr = corr(a, b);
    ac_corr = corr(a, c);
    bc_corr = corr(b, c);

    ab_norm_corr = norm_corr(a, b);
    ac_norm_corr = norm_corr(a, c);
    bc_norm_corr = norm_corr(b, c);

    printf("Корреляция между a, b, c\n");
    printf("   | a | b | c  \n");
    printf(" a | - | %d | %d  \n", ab_corr, ac_corr);
    printf(" b | %d | - | %d  \n", ab_corr, bc_corr);
    printf(" c | %d | %d | -  \n\n", ac_corr, bc_corr);

    printf("Нормализованная корреляция между a, b, c\n");
    printf("   |  a  |  b  |  c   \n");
    printf(" a |  -  | %.2f | %.2f  \n", ab_norm_corr, ac_norm_corr);
    printf(" b | %.2f |  -  | %.2f  \n", ab_norm_corr, bc_norm_corr);
    printf(" c | %.2f | %.2f |  -   \n\n", ac_norm_corr, bc_norm_corr);
    return 0;
}