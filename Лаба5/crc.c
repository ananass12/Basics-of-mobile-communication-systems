#include <stdio.h>
#include <stdlib.h>

#define N (20 + 19)
#define CRC_len 7
#define length (N + CRC_len)
int polynom[CRC_len + 1] = {1,1,0,0,0,0,1,1};     //G = x7 + x6 + x + 1   ->    11000011

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

    for (int i = 0; i < CRC_len; i++)
        rem[i] = tmp[len + i];
}

int is_valid(int frame[], int len) {
    int rem[CRC_len];
    calc_crc(frame, len, rem);      // считаем CRC от первых len бит данных

    for (int i = 0; i < CRC_len; i++) {
        if (rem[i] != frame[len + i]) {
            return 0;   // CRC не совпадает - ошибка
        }
    }
    return 1;           // CRC совпадают - ошибок нет
}

int main(){
    // ------- N = 39 -----------
    int data[N];
    int crc[CRC_len];
    int frame[length];
    
    for (int i = 0; i < N; i++){
        data[i] = rand() % 2;
    }
    
    calc_crc(data, N, crc);
    
    for (int i = 0; i < N; i++) frame[i] = data[i];
    for (int i = 0; i < CRC_len; i++) frame[N + i] = crc[i];

    printf("=== N = %d ===\n", N);
    printf("CRC: ");
    for (int i = 0; i < CRC_len; i++) {
        printf("%d", crc[i]);
    }
    printf("\n");

    printf(is_valid(frame, N) ? "Нет ошибок\n" : "Есть ошибки\n");

    int detected = 0, missed = 0;
    for (int i = 0; i < length; i++) {
        frame[i] ^= 1;
        if (is_valid(frame, N)) missed++; else detected++;
        frame[i] ^= 1;
    }

    printf("Проверено: %d  Пропущено: %d\n\n", detected, missed);

    // ------- N = 250 -----------

    int N2 = 250;
    int length2 = N2 + CRC_len;

    int data2[250];
    int crc2[CRC_len];
    int frame2[250 + CRC_len];

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

    // проверка всех одиночных ошибок
    int detected2 = 0, missed2 = 0;

    for (int i = 0; i < length2; i++) {
        frame2[i] ^= 1;  // вносим ошибку
        int rem3[CRC_len];
        calc_crc(frame2, N2, rem3);

        int valid = 1;
        for (int j = 0; j < CRC_len; j++)
            if (rem3[j] != frame2[N2 + j]) valid = 0;

        if (valid) missed2++;
        else detected2++;

        frame2[i] ^= 1;  // возвращаем бит назад
    }

    printf("Проверено: %d  Пропущено: %d\n", detected2, missed2);

    return 0;
}