#include <stdio.h>
#include <math.h>

void generate_gold(int x[5], int y[5], int gold[31]) {
    for (int i = 0; i < 31; i++) {
        gold[i] = x[4] ^ y[4];          // выход = x5 XOR y5
        int new_x1 = x[3] ^ x[4];       // x1 = x4 XOR x5
        int new_y1 = y[1] ^ y[4];       // y1 = y2 XOR y5

        for (int j = 4; j > 0; j--) {
            x[j] = x[j-1];
            y[j] = y[j-1];
        }
        x[0] = new_x1;
        y[0] = new_y1;
    }
}

int main() {
    const int N = 31; //2^5 -1
    int gold1[N], gold2[N];

    int x1[5] = {1, 0, 0, 1, 1}; //19
    int y1[5] = {1, 1, 0, 1, 0}; //26
    generate_gold(x1, y1, gold1);

    int x2[5] = {1, 0, 1, 0, 0}; //20
    int y2[5] = {1, 0, 1, 0, 1}; //21
    generate_gold(x2, y2, gold2);

    printf("Последовательность Голда 1: ");
    for (int i = 0; i < N; i++) printf("%d ", gold1[i]);
    printf("\nПоследовательность Голда 2: ");
    for (int i = 0; i < N; i++) printf("%d ", gold2[i]);
    printf("\n\n");

    //printf("Шаг\tВыход\tСостояние X\t\tСостояние Y\n");

    //printf("%2d      %2d     X: [%d, %d, %d, %d, %d]    Y: [%d, %d, %d, %d, %d]\n", i+1, gold[i], x[0], x[1], x[2], x[3], x[4], y[0], y[1], y[2], y[3], y[4]);

    // Вычисление энергий (sum of squares)
    double sum1 = 0.0, sum2 = 0.0;
    for (int i = 0; i < N; i++) {
        sum1 += gold1[i] * gold1[i];  // = число единиц в gold1
        sum2 += gold2[i] * gold2[i];  // = число единиц в gold2
    }

    double d = sqrt(sum1 * sum2);

    printf("Сдвиг:    ");
    for (int tau = 0; tau < N; tau++) {
        printf("%4d  ", tau);
    }
    printf("\nКорреляция: ");
    for (int tau = 0; tau < N; tau++) {
        double c = 0.0;
        for (int i = 0; i < N; i++) {
            int j = (i - tau + N) % N;
            c += (double)(gold1[i] * gold2[j]);
        }
        double R = (d > 0) ? c / d : 0.0;
        printf("%.3f ", R);
    }
    printf("\n");

    // Вычисление суммы квадратов (энергии) исходной последовательности
    double sum_sq = 0.0;
    for (int i = 0; i < N; i++) {
        sum_sq += gold1[i] * gold1[i];  // так как gold[i] ∈ {0,1}, то gold[i]^2 = gold[i]
    }
    // sum_sq == число единиц в последовательности

    printf("\n\nСдвиг");
    for (int i = 1; i <= N; i++) {
        printf(" | %d", i);
    }
    printf(" | Автокорреляция\n");
    for (int i = 0; i < N; i++) printf("------");
    printf("\n");

    // Для каждого сдвига τ
    for (int tau = 0; tau < N; tau++) {
        // Вывод сдвига и сдвинутых битов
        double c = 0.0;
        printf("%4d", tau);

        for (int i = 0; i < N; i++) {
            int j = (i - tau + N) % N;          // правый сдвиг на tau
            int shifted_bit = gold1[j];
            printf(" | %d", shifted_bit);
            c += (double)(gold1[i] * shifted_bit);
        }

        double R = (sum_sq > 0) ? c / sum_sq : 0.0;
        printf(" | %.3f\n", R);
    }

    return 0;
}