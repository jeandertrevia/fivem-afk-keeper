"""
FiveM AFK Keeper
Simula pressionamentos aleatórios de WASD para evitar kick por ociosidade.
Compatível com macOS e Windows.

Uso:
    python main.py

Dependências:
    pip install pynput
"""

import time
import random
import threading
from pynput.keyboard import Controller

keyboard = Controller()

KEYS = ["w", "a", "s", "d"]

# Intervalo entre cada tecla pressionada (segundos)
MIN_INTERVAL = 20
MAX_INTERVAL = 45

# Duração do pressionamento da tecla (segundos)
MIN_PRESS_DURATION = 0.05
MAX_PRESS_DURATION = 0.2

running = True


def press_random_key():
    key = random.choice(KEYS)
    duration = random.uniform(MIN_PRESS_DURATION, MAX_PRESS_DURATION)
    keyboard.press(key)
    time.sleep(duration)
    keyboard.release(key)
    return key, duration


def afk_loop():
    print("AFK Keeper iniciado. Pressione Ctrl+C para parar.\n")
    while running:
        wait = random.uniform(MIN_INTERVAL, MAX_INTERVAL)
        print(f"[aguardando {wait:.1f}s]", end="", flush=True)
        time.sleep(wait)
        if not running:
            break
        key, duration = press_random_key()
        print(f"\r[tecla '{key}' pressionada por {duration:.2f}s]          ")


def main():
    global running
    thread = threading.Thread(target=afk_loop, daemon=True)
    thread.start()
    try:
        thread.join()
    except KeyboardInterrupt:
        running = False
        print("\nAFK Keeper encerrado.")


if __name__ == "__main__":
    main()
