// --- Ejemplo de parpadeo de LED LD2 en STM32F476RGTx -------------------------
    .section .text
    .syntax unified
    .thumb

    .global main
    .global init_led
    .global init_button
    .global init_systick
    .global SysTick_Handler

// --- Definiciones de registros para LD2 (Ver RM0351) -------------------------
    .equ RCC_BASE,       0x40021000         @ Base de RCC
    .equ RCC_AHB2ENR,    RCC_BASE + 0x4C    @ Enable GPIOA/GPIOC clock (AHB2ENR)
    .equ GPIOA_BASE,     0x48000000         @ Base de GPIOA
    .equ GPIOA_MODER,    GPIOA_BASE + 0x00  @ Mode register
    .equ GPIOA_ODR,      GPIOA_BASE + 0x14  @ Output data register
    .equ LD2_PIN,        5                  @ Pin del LED LD2

// --- Definiciones de registros para Button B1 (Ver RM0351) ------------------
    .equ GPIOC_BASE,     0x48000800         @ Base de GPIOC
    .equ GPIOC_MODER,    GPIOC_BASE + 0x00  @ Mode register
    .equ GPIOC_IDR,      GPIOC_BASE + 0x10  @ Input data register
    .equ B1_PIN,         13                 @ Pin del botón B1

// --- Definiciones de registros para SysTick (Ver PM0214) ---------------------
    .equ SYST_CSR,       0xE000E010         @ Control and status
    .equ SYST_RVR,       0xE000E014         @ Reload value register
    .equ SYST_CVR,       0xE000E018         @ Current value register
    .equ HSI_FREQ,       4000000            @ Reloj interno por defecto (4 MHz)

// --- Programa principal ------------------------------------------------------
main:
    bl init_led
    bl init_button
    bl init_systick
loop:
    bl check_button
    wfi
    b loop

// --- Inicialización de GPIOA PA5 para el LED LD2 -----------------------------
init_led:
    movw  r0, #:lower16:RCC_AHB2ENR
    movt  r0, #:upper16:RCC_AHB2ENR
    ldr   r1, [r0]
    orr   r1, r1, #(1 << 0)                @ Habilita reloj GPIOA
    str   r1, [r0]

    movw  r0, #:lower16:GPIOA_MODER
    movt  r0, #:upper16:GPIOA_MODER
    ldr   r1, [r0]
    bic   r1, r1, #(0b11 << (LD2_PIN * 2)) @ Limpia bits MODER5
    orr   r1, r1, #(0b01 << (LD2_PIN * 2)) @ PA5 como salida
    str   r1, [r0]
    bx    lr

// --- Inicialización de GPIOC PC13 para el botón B1 ---------------------------
init_button:
    movw  r0, #:lower16:RCC_AHB2ENR
    movt  r0, #:upper16:RCC_AHB2ENR
    ldr   r1, [r0]
    orr   r1, r1, #(1 << 2)                @ Habilita reloj GPIOC
    str   r1, [r0]

    movw  r0, #:lower16:GPIOC_MODER
    movt  r0, #:upper16:GPIOC_MODER
    ldr   r1, [r0]
    bic   r1, r1, #(0b11 << (B1_PIN * 2))  @ PC13 como entrada (00)
    str   r1, [r0]
    bx    lr

// --- Verificación del botón y control del LED --------------------------------
check_button:
    @ Leer estado del botón PC13 y verificar directamente
    movw  r0, #:lower16:GPIOC_IDR
    movt  r0, #:upper16:GPIOC_IDR
    ldr   r1, [r0]
    tst   r1, #(1 << B1_PIN)            @ Test bit 13 (si es 0, Z flag se activa)
    
    @ Si botón presionado (bit=0, Z flag activo), encender LED y reiniciar contador
    bne   button_not_pressed             @ Saltar si Z flag no activo (botón no presionado)
    
    @ Reiniciar contador de segundos
    movs  r4, #0                       @ Reiniciar contador
    
    @ Encender LED
    movw  r0, #:lower16:GPIOA_ODR
    movt  r0, #:upper16:GPIOA_ODR
    ldr   r2, [r0]
    orr   r2, r2, #(1 << LD2_PIN)      @ Encender PA5
    str   r2, [r0]
    
button_not_pressed:
    bx    lr

// --- Inicialización de Systick para 1 s --------------------------------------
init_systick:
    movw  r0, #:lower16:SYST_RVR
    movt  r0, #:upper16:SYST_RVR
    movw  r1, #:lower16:HSI_FREQ
    movt  r1, #:upper16:HSI_FREQ
    subs  r1, r1, #1                       @ reload = 4 000 000 - 1
    str   r1, [r0]

    movw  r0, #:lower16:SYST_CSR
    movt  r0, #:upper16:SYST_CSR
    movs  r1, #(1 << 0)|(1 << 1)|(1 << 2)  @ ENABLE=1, TICKINT=1, CLKSOURCE=1
    str   r1, [r0]
    bx    lr

// --- Manejador de la interrupción SysTick ------------------------------------
    .thumb_func                            @ Ensure Thumb bit
SysTick_Handler:
    @ Incrementar contador de segundos
    adds  r4, r4, #1
    
    @ Si contador >= 3, apagar LED
    cmp   r4, #3
    blt   systick_end                      @ Si r4 < 3, no hacer nada
    
    @ Apagar LED
    movw  r0, #:lower16:GPIOA_ODR
    movt  r0, #:upper16:GPIOA_ODR
    ldr   r1, [r0]
    bic   r1, r1, #(1 << LD2_PIN)          @ Apagar PA5
    str   r1, [r0]
    
systick_end:
    bx    lr
