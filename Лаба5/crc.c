#include <stdio.h>
#include <stdlib.h>

#define N 17
#define CRC_len 2
#define length (N + CRC_len)
int polynom[CRC_len + 1] = {1,0,1};    

void calc_crc(int input[], int len, int rem[]) {
    int tmp[len + CRC_len];
    for (int i = 0; i < len; i++) tmp[i] = input[i];
    for (int i = len; i < len + CRC_len; i++) tmp[i] = 0;

    for (int i = 0; i < len; i++) {
        if (tmp[i] == 1) {
            for (int j = 0; j <= CRC_len; j++) {
                tmp[i + j] ^= polynom[j];
            }
        }
    }

    for (int i = 0; i < CRC_len; i++) rem[i] = tmp[len + i];
}

int is_valid(int frame[], int len, int step) {
    int rem[CRC_len];
    calc_crc(frame, len, rem);      
    
    printf("| %3d | ", step);
    
    //биты данных
    for (int i = 0; i < N; i++) {
        printf("%d", frame[i]);
    }
    printf(" | ");
    
    for (int i = 0; i < CRC_len; i++) {
        printf("%d", frame[len + i]);
    }
    printf("  | ");
    
    for (int i = 0; i < CRC_len; i++) {
        printf("%d", rem[i]);
    }
    printf("  | ");
    
    for (int i = 0; i < CRC_len; i++) {
        if (rem[i] != frame[len + i]) {
            printf(" ОШИБКА |\n");
            return 0;    // CRC не совпадает - ошибка
        }
    }
    printf("  ОК   |\n");
    return 1;    // CRC совпадает - все ок
}

int main(){
    int data[N] = {1,0,1,1,0,0,0,1,1,0,1,1,1,0,1,0,1};
    int crc[CRC_len];
    int frame[length];
    
    /*for (int i = 0; i < N; i++){
        data[i] = rand() % 2;
    }*/
    
    calc_crc(data, N, crc);
    
    for (int i = 0; i < N; i++) frame[i] = data[i];
    for (int i = 0; i < CRC_len; i++) frame[N + i] = crc[i];

    printf("N = %d \n", N);
    printf("CRC изначальное: ");
    for (int i = 0; i < CRC_len; i++) {
        printf("%d", crc[i]);
    }
    printf("\n");

    printf("Полином: ");
    for (int i = CRC_len; i >= 0; i--) {
        printf("%d", polynom[i]);
    }

    //printf(is_valid(frame, N) ? "Нет ошибок\n" : "Есть ошибки\n");

    printf("\n| Шаг |     Данные        | CRC  | Выч. | Результат |\n");
    printf("------------------------------------------------------\n");

    is_valid(frame, N, 0);

    //Однобитные ошибки 
    int detected = 0, missed = 0;

    for (int i = 0; i < length; i++) {
        frame[i] ^= 1;  
        if (is_valid(frame, N, i + 1)) {
            missed++; 
        }else { 
            detected++;
        }
        //frame[i] ^= 1;  
    }
    printf("------------------------------------------------------\n\n");
    
    printf("Обнаружено: %d  Пропущено: %d \n",  detected, missed);
    printf("Процент пропуска: %.2f%%\n", (missed* 100.0) / (detected + missed));
    printf("Всего тестов: %d\n", N);
     /*
    //Двубитные ошибки 
    int detected_double = 0, missed_double = 0;
    for (int i = 0; i < length - 1; i++) {
        for (int j = i + 1; j < length; j++) {
            frame[i] ^= 1; 
            frame[j] ^= 1; 
            
            if (is_valid(frame, N)) missed_double++; 
            else detected_double++;
            
            frame[i] ^= 1;  
            frame[j] ^= 1;
            
            if (detected_double + missed_double > 100000) {
                i = length; 
                break;
            }
        }
    }
    printf("\n=== Двубитные ошибки ===\n");
    printf("Обнаружено: %d  Пропущено: %d\n", detected_double, missed_double);
    printf("Процент пропуска: %.2f%%\n", (missed_double * 100.0) / (detected_double + missed_double));

    // Двубитные ошибки в соседних битах
    int detected_double2 = 0, missed_double2 = 0;
    for (int i = 0; i < length - 1; i++) {  
        frame[i] ^= 1;
        frame[i + 1] ^= 1;
        
        if (is_valid(frame, N)) missed_double2++;
        else detected_double2++;
        
        frame[i] ^= 1;
        frame[i + 1] ^= 1;
        
        if (i > 100000) break;  
    }
    printf("\n=== Двубитные соседние ошибки ===\n");
    printf("Обнаружено: %d  Пропущено: %d\n", detected_double2, missed_double2);
    printf("Процент пропуска: %.2f%%\n", (missed_double2 * 100.0) / (detected_double2 + missed_double2));
*/
    // ------- N = 250 -----------
/*
    int N2 = 1000;
    int length2 = N2 + CRC_len;

    int data2[1000];
    int crc2[CRC_len];
    int frame2[1000 + CRC_len];

    // случайные данные
    for (int i = 0; i < N2; i++)
        data2[i] = rand() % 2;

    calc_crc(data2, N2, crc2);

    for (int i = 0; i < N2; i++) frame2[i] = data2[i];
    for (int i = 0; i < CRC_len; i++) frame2[N2 + i] = crc2[i];

    printf("=== N = 250 ===\n");
    printf("CRC: ");
    for (int i = 0; i < CRC_len; i++) printf("%d", crc2[i]);
    printf("\n");

    printf(is_valid(frame2, N2) ? "Нет ошибок\n" : "Есть ошибки\n");

    int detected2 = 0, missed2 = 0;

    for (int i = 0; i < length2; i++) {
        frame2[i] ^= 1;  //вносим ошибку
        int rem3[CRC_len];
        calc_crc(frame2, N2, rem3);

        int valid = 1;
        for (int j = 0; j < CRC_len; j++)
            if (rem3[j] != frame2[N2 + j]) valid = 0;

        if (valid) missed2++;
        else detected2++;

        frame2[i] ^= 1; 
    }

    printf("Проверено: %d  Пропущено: %d\n", detected2, missed2); */

    return 0;
}