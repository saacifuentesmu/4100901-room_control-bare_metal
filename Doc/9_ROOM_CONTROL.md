# 9. ROOM_CONTROL.md
> **Referencia:**
> Zhu, Yifen. *Embedded Systems with ARM Cortex-M Microcontrollers in Assembly Language and C*, 2nd Edition, 2022. ***Capítulo 10 recomendado para esta sección***

## 1. Objetivo

Este documento guía la implementación del módulo `room_control`, que integra la lógica de aplicación para el "Sistema de Control Básico de una Sala". A diferencia de los módulos de drivers de periféricos, `room_control` utiliza las funciones proporcionadas por los drivers para construir el comportamiento deseado, manejando eventos a través de interrupciones.

---

## 2. Preparación del Proyecto

1. **Crear el archivo de cabecera**: en `Inc/`, crea un archivo llamado `room_control.h`.
2. **Crear el archivo de código**: en `Src/`, crea un archivo llamado `room_control.c`.
3. **Incluir en la compilación**: agrega `Src/room_control.c` en `cmake/vscode_generated.cmake` en la sección de fuentes.
4. **Implementar el código**: usa el código de las secciones 3, 4 y 5 como referencia para implementar tu lógica de aplicación.

---

## 3. Código de referencia para implementar (`Inc/room_control.h`)

En el archivo `Inc/room_control.h` implementa el siguiente código:

```c
#ifndef ROOM_CONTROL_H
#define ROOM_CONTROL_H

#include <stdint.h>

// Constantes
#define LED_TIMEOUT_MS 3000  // Tiempo para apagar LED después de presionar botón
#define PWM_INITIAL_DUTY 50  // Duty cycle inicial para PWM LED

/**
 * @brief Función a ser llamada por EXTI15_10_IRQHandler cuando se detecta
 *        la pulsación del botón B1.
 */
void room_control_on_button_press(void);

/**
 * @brief Función a ser llamada por USART2_IRQHandler cuando se recibe un carácter.
 * @param received_char El carácter recibido por UART.
 */
void room_control_on_uart_receive(char received_char);

/**
 * @brief (Opcional) Función para realizar inicializaciones específicas de la lógica
 *        de room_control, si las hubiera.
 */
void room_control_app_init(void);

#endif // ROOM_CONTROL_H
```

## 5. Código de referencia para implementar (`Src/room_control.c`)

En el archivo `Src/room_control.c` implementa el siguiente código como base, y completa la lógica:

```c
#include "room_control.h"

#include "gpio.h"    // Para controlar LEDs
#include "systick.h" // Para obtener ticks y manejar tiempos
#include "uart.h"    // Para enviar mensajes
#include "tim.h"     // Para controlar el PWM

// TODO: Definir variables de estado necesarias

void room_control_app_init(void)
{
    // TODO: Implementar inicializaciones específicas de la aplicación
}

void room_control_on_button_press(void)
{
    // TODO: Implementar la lógica para manejar la pulsación del botón
}

void room_control_on_uart_receive(char received_char)
{
    switch (received_char) {
        case 'h':
        case 'H':
            // TODO: Set PWM to 100%
            break;
        case 'l':
        case 'L':
            // TODO: Set PWM to 0%
            break;
        default:
            // TODO: Echo the character
            break;
    }
}
```


---

## 6. Explicación de funciones

| Función               | Descripción                                                                  |
| --------------------- | ---------------------------------------------------------------------------- |
| `room_control_app_init()` | Inicializa la lógica de aplicación.                                         |
| `room_control_on_button_press()` | Maneja eventos de pulsación del botón.                                      |
| `room_control_on_uart_receive()` | Maneja recepción de caracteres UART.                                        |

---

## 7. Ejercicios Adicionales

Una vez que hayas implementado la lógica básica:

1. **Implementa heartbeat**: Agrega parpadeo de LD2 en `SysTick_Handler`.
2. **Mejora anti-rebote**: Implementa debounce usando timestamps.
3. **Agrega más comandos UART**: Implementa comandos para cambiar duty cycle a valores específicos (ej. '1' = 10%, '5' = 50%).
4. **Timeout del LED**: En `SysTick_Handler`, verifica si han pasado 3s desde `led_on_time` y apaga el LED.

## 8. Verificación de Funcionamiento

Para verificar que tu implementación funciona correctamente:

1. **Compilación**: El proyecto debe compilar sin errores.
2. **Funcionalidad**: Implementa la lógica requerida y verifica que cumpla con los requisitos del sistema.
3. **Integración**: Asegúrate de que las ISRs llamen a las funciones de room_control.

---

**Siguiente guía:**
Main: [MAIN.md](10_MAIN.md)