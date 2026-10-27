
#include <stdio.h>

int main() {
    int value = 12;

    if (value > 10) {
        value = value - 2;
    } else {
        value = value + 2;
    }

    do {
        value = value - 1;
    } while (value > 0);

    return 0;
}
