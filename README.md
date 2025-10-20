# Taller Práctico: Sistema de Control Básico en C Puro (STM32L476RG)

**Universidad Nacional de Colombia - Sede Manizales**
**Curso:** Estructuras Computacionales (4100901)

## Introducción

Este taller tiene como objetivo principal consolidar los conocimientos adquiridos en los capítulos previos sobre la arquitectura del STM32L476RG y el manejo de sus periféricos mediante programación en C puro, accediendo directamente a los registros de hardware.

Replicaremos la funcionalidad del "Sistema de Control Básico" implementado en la práctica introductoria (que utilizaba HAL y STM32CubeMX), pero esta vez, construiremos cada módulo desde cero, basándonos en las implementaciones realizadas en los talleres de SysTick, GPIO, EXTI, TIM/PWM y UART. La versión actual utiliza un único LED PWM para representar la iluminación (encendido variable) y el LED integrado (LD2) como heartbeat.

**Objetivo General:**
Implementar un sistema embebido que gestione LEDs, lea un botón, controle un LED con PWM y se comunique vía UART, utilizando únicamente acceso directo a registros en C puro.

**Funcionalidades Implementadas:**
1.  **Heartbeat LED (PA5 - LD2):** Parpadeo cada 500 ms como señal de actividad del sistema.
2.  **Control de Ocupación por Botón (PC13):** Alterna estado entre IDLE y OCCUPIED. En OCCUPIED el LED PWM (PA6) se pone al 100% y se inicia un timeout de 3 segundos; al expirar vuelve a IDLE y se apaga (duty 0%). Otra pulsación también alterna estado.
3.  **Control PWM de Iluminación (PA6 - TIM3_CH1):** Señal PWM a 1 kHz que ajusta brillo de la "bombilla". Duty cycle configurable vía comandos UART.
4.  **Comunicación UART (USART2 @115200 8N1):** Recepción de comandos de control y envío de mensajes de estado: inicialización, cambios de ocupación, timeout y ajustes de PWM.

**Comandos UART Disponibles:**
| Comando | Acción |
|---------|--------|
| `O` / `o` | Forzar estado OCCUPIED (PWM 100%, reinicia timeout) |
| `I` / `i` | Forzar estado IDLE (PWM 0%) |
| `h` / `H` | Ajustar PWM al 100% (sin cambiar estado) |
| `l` / `L` | Ajustar PWM al 0% (sin cambiar estado) |
| `1`..`5` | Ajustar PWM a 10%,20%,30%,40%,50% (sin cambiar estado) |
| Otro | Reporta mensaje de comando desconocido |

## Estructura de la Guía

Esta guía está dividida en varias secciones para facilitar el proceso de desarrollo:

1.  **[SETUP.md](Doc/1_SETUP.md):** Preparación del hardware y el entorno de desarrollo.
2.  **[ASM_CONFIG.md](Doc/2_ASM_CONFIG.md):** Guía de introducción al set de instrucciones de un procesador (ISA) y al lenguaje ensamblador.
3.  **[WORKSHOP_ASM.md](Doc/3_WORKSHOP_ASM.md):** Taller práctico de ensamblador e instrucciones básicas del ISA de ARM.
4.  **[WORKSHOP_C.md](Doc/4_WORKSHOP_C.md):** Taller práctico traduciendo las instrucciones básicas del ISA de ARM a lenguaje C.
5.  **[REFACTOR_TO_LIB.md](Doc/5_REFACTOR_TO_LIB.md):** Refactorización del código a librerías modulares.
6.  **[USART.md](Doc/6_USART.md):** Implementación de comunicación serial.
7.  **[NVIC.md](Doc/7_NVIC.md):** Configuración de interrupciones.
8.  **[TIM_PWM.md](Doc/8_TIM_PWM.md):** Generación de señales PWM.
9.  **[ROOM_CONTROL.md](Doc/9_ROOM_CONTROL.md):** Integración de la lógica de la aplicación.
10. **[MAIN.md](Doc/10_MAIN.md):** Estructura del archivo `main.c`.
11. **[USER_MANUAL.md](Doc/11_USER_MANUAL.md):** Funciones y arquitectura del sistema.

> **Nota:** Cada documento incluye enlaces relativos para facilitar la navegación y referencias cruzadas.

Dirígete primero a [SETUP.md](Doc/1_SETUP.md) para configurar tu entorno de desarrollo.

