#include <stdio.h>
#include <stdint.h>

/**
 * "Ligar" bits com Or (Set bits)
 */
uint8_t set_bit(uint8_t value, int bit) {
    return value | (1 << bit);
}

/**
 * "Deslizar" ou Filtrar bits com And (Mask bits)
 * Geralmente usado para isolar bits específicos.
 */
uint8_t check_bit(uint8_t value, int bit) {
    return (value & (1 << bit)) >> bit;
}

/**
 * "Detectar diferenças" com Xor (Find differences/Toggle)
 * O resultado terá bits 1 onde os valores são diferentes.
 */
uint8_t diff_bits(uint8_t a, uint8_t b) {
    return a ^ b;
}

/**
 * Shift Lógico para a esquerda
 */
uint8_t logical_shift_left(uint8_t value, int count) {
    return value << count;
}

/**
 * Shift Lógico para a direita
 */
uint8_t logical_shift_right(uint8_t value, int count) {
    // Para uint8_t (unsigned), >> é sempre lógico
    return value >> count;
}

/**
 * Shift Aritmético para a direita
 * Mantém o bit de sinal. Em C, em tipos signed, >> costuma ser aritmético.
 */
int8_t arithmetic_shift_right(int8_t value, int count) {
    return value >> count;
}

/**
 * Shift Circular para a esquerda (Rotate Left)
 */
uint8_t circular_shift_left(uint8_t value, int count) {
    count %= 8;
    if (count == 0) return value;
    return (value << count) | (value >> (8 - count));
}

/**
 * Shift Circular para a direita (Rotate Right)
 */
uint8_t circular_shift_right(uint8_t value, int count) {
    count %= 8;
    if (count == 0) return value;
    return (value >> count) | (value << (8 - count));
}

void print_binary(uint8_t value) {
    for (int i = 7; i >= 0; i--) {
        printf("%d", (value >> i) & 1);
    }
}

int main() {
    uint8_t val = 0b00001010; // 10 em decimal
    
    printf("Valor original: ");
    print_binary(val);
    printf(" (%d)\n", val);

    // 1. Ligar bit 0
    uint8_t ligar = set_bit(val, 0);
    printf("Ligar bit 0 (OR): ");
    print_binary(ligar);
    printf(" (%d)\n", ligar);

    // 2. "Deslizar" / Isolar bit 3
    uint8_t isolar = check_bit(val, 3);
    printf("Bit 3 esta ligado? (AND): %s\n", isolar ? "Sim" : "Nao");

    // 3. Detectar diferenças
    uint8_t outro = 0b00001111;
    uint8_t diff = diff_bits(val, outro);
    printf("Diferença entre ");
    print_binary(val);
    printf(" e ");
    print_binary(outro);
    printf(" (XOR): ");
    print_binary(diff);
    printf("\n");

    // 4. Shifts
    printf("\n--- Operações de Shift ---\n");
    
    printf("Shift Lógico Esquerda (val << 1): ");
    print_binary(logical_shift_left(val, 1));
    printf("\n");

    printf("Shift Lógico Direita (val >> 1):  ");
    print_binary(logical_shift_right(val, 1));
    printf("\n");

    int8_t neg = -10; // 11110110 em complemento de dois
    printf("Shift Aritmético Direita (%d >> 1): ", neg);
    print_binary((uint8_t)arithmetic_shift_right(neg, 1));
    printf(" (%d)\n", arithmetic_shift_right(neg, 1));

    printf("Shift Circular Esquerda (val ROL 1): ");
    print_binary(circular_shift_left(val, 1));
    printf("\n");

    printf("Shift Circular Direita (val ROR 1):  ");
    print_binary(circular_shift_right(val, 1));
    printf("\n");

    return 0;
}
