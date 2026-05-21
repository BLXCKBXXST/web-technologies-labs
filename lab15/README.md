# Практическая работа №15
**Программирование на Python (Stepik)**

Решения учебных задач курса по программированию на Python. Все решения рассчитаны на Python 3.12; задачи на Stepik проверяются через `stdin → stdout`.

---

## 1.2 Функция print()

**Подвиг 1.** *(не зафиксирован — добавить позже)*

**Подвиг 2.**
```python
print(6 + 7)
```

**Подвиг 3.**
```python
print("Люблю тебя, Петра творенье,")
print("Люблю твой строгий, стройный вид,")
```

---

## 2.1 Переменные. Оператор присваивания

**Подвиг 1.** Ссылка на объект в памяти.

**Подвиг 2.** Связывает переменную с данными; создаёт переменную, если её ранее не было.

**Подвиг 3.** Допустимы: `a = 6`, `a = b = 0`.

**Подвиг 4.** Копирование ссылки — обе переменные ссылаются на один и тот же объект.

**Подвиг 5.** Каскадным присваиванием.

**Подвиг 6.** Множественным присваиванием.

**Подвиг 7.** Для определения типа объекта.

**Подвиг 8.** Допустимые имена: `var_a`, `_b`, `__arg_c__`, `TT1`, `d25`, `S`.

**Подвиг 9.** Да.

**Подвиг 10.** Верные присвоения: `b = 5.8`, `b = "hello"`, `b = "True"`.

**Подвиг 11.** Переменная `type` будет ссылаться на число 7.

---

## 2.2 Числовые типы. Арифметические операторы

**Подвиг 1.** *(не зафиксирован — добавить позже)*

**Подвиг 2.** Вещественному.

**Подвиг 3.** `int`

**Подвиг 4.** `float`

**Подвиг 5.** Соответствия операторов:
- `+` — сложение
- `-` — вычитание
- `*` — умножение
- `/` — деление
- `//` — целочисленное деление
- `%` — остаток от деления
- `**` — возведение в степень

**Подвиг 6.**
```python
var_a = 5
var_b = 7
var_c = var_a + var_b
```

**Подвиг 7.** `16`

**Подвиг 8.** `2.0`

**Подвиг 9.** `2`

**Подвиг 10.** `11`

**Подвиг 11.** `5`

**Подвиг 12.** `float`

**Подвиг 13.**
```python
total = 5
count = -4.3
total += 3
count -= 1.2
```

**Подвиг 14.**
```python
x, y = map(int, input().split())
x /= 2
y *= 3.5
```

---

## 2.3 Функции. Модуль math

**Подвиг 1.**
```python
d = int(input())
res = abs(d)
```

**Подвиг 2.**
```python
d1, d2, d3, d4, d5 = map(int, input().split())
res = min(d1, d2, d3, d4, d5)
```

**Подвиг 3.**
```python
d1, d2, d3, d4, d5 = map(int, input().split())
res = max(d1, d2, d3, d4, d5)
```

**Подвиг 4.** `import math`

**Подвиг 5.**
```python
import math
a, b = map(int, input().split())
length = round(math.sqrt(a ** 2 + b ** 2), 2)
```

**Подвиг 6.**
```python
import math
n, k = map(int, input().split())
Cnk = math.factorial(n) // (math.factorial(k) * math.factorial(n - k))
```

**Подвиг 7.**
```python
import math
n, m = map(int, input().split())
total_bus = math.ceil((n + m) / 20)
```

**Подвиг 8.**
```python
x = int(input())
res = 5000 // (9 * x)
```

---

## 2.4 Ввод и вывод данных

**Подвиг 1.**
```python
a = 7
b = -4
c = 3
print(a, b, c)
```

**Подвиг 2.**
```python
a = 7
b = -4
c = 3
print(a, b, c, sep="\n")
```

**Подвиг 3.**
```python
s1 = "Hello"
s2 = "Balakirev"
print(s1, end=" ")
print(s2)
```

**Подвиг 4.**
```python
s1, s2 = input().split()
print(f"Word 1: {s1} | Word 2: {s2}")
```

**Подвиг 5.**
```python
a, b = map(int, input().split())
print(a ** b)
```

**Подвиг 6.** `d = int(input())`

**Подвиг 7.** `d = input()`

**Подвиг 8.**
```python
a, b = map(float, input().split())
print(a + b)
```

**Подвиг 9.**
```python
X, Y = map(int, input().split())
print(X + Y + 2 * X + 4 * Y)
```

**Подвиг 10.**
```python
a = float(input())
b = float(input())
print(2 * (a + b))
```

**Подвиг 11.**
```python
import math
print(round(math.pi, 3))
```

**Подвиг 12.**
```python
x = float(input())
print(f"Вы ввели число {x}")
```

---

## 2.5 Арифметические подвиги

**Подвиг 1.**
```python
a, b = map(float, input().split())
a, b = b, a
```

**Подвиг 2.**
```python
count, total = map(float, input().split())
count += 2
total -= 0.3
```

**Подвиг 3.**
```python
import math
a, b, c = map(float, input().split())
length = round(math.sqrt(a ** 2 + b ** 2 + c ** 2), 2)
```

**Подвиг 4.**
```python
digit = int(input())
sum_digit = digit % 10 + digit // 10 % 10 + digit // 100 % 10 + digit // 1000
```

**Подвиг 5.**
```python
import math
a, b, c = map(int, input().split())
p = (a + b + c) / 2
sq_tr = math.sqrt(p * (p - a) * (p - b) * (p - c))
```

**Подвиг 6.**
```python
import math
a, b, alpha = map(float, input().split())
length_c = math.sqrt(a ** 2 + b ** 2 - 2 * a * b * math.cos(alpha))
```

**Подвиг 7.**
```python
import math
d1, d2, alpha = map(int, input().split())
rad = alpha / 180 * math.pi
square = round(d1 * d2 / 2 * math.sin(rad), 1)
```

**Подвиг 8.**
```python
import math
x0, y0, x1, y1 = map(float, input().split())
cos_a = (x0 * x1 + y0 * y1) / (math.sqrt(x0 ** 2 + y0 ** 2) * math.sqrt(x1 ** 2 + y1 ** 2))
alpha = round(180 / math.pi * math.acos(cos_a), 1)
```

---

## 2.6 Операторы сравнения. Тип bool

**Подвиг 1.** Соответствия операторов:
- `<` — сравнение на меньше
- `>` — сравнение на больше
- `<=` — сравнение меньше или равно
- `>=` — сравнение больше или равно
- `==` — сравнение на равенство
- `!=` — сравнение на неравенство

**Подвиг 2.** `True`

**Подвиг 3.** `False`

**Подвиг 4.** `True`

**Подвиг 5.**
```python
x = float(input())
print(int(x) % 3 == 0)
```

**Подвиг 6.**
```python
x = float(input())
print(x % 1 > 0.5)
```

**Подвиг 7.**
```python
a, b = map(int, input().split())
print(a % b == 0)
```

**Подвиг 8.** `True`

**Подвиг 9.** `False`

**Подвиг 10.**
```python
a, b, c = map(int, input().split())
print(a + b > c and a + c > b and b + c > a)
```

**Подвиг 11.**
```python
x = float(input())
print(0 <= x <= 2 or 10 <= x <= 20)
```

---

## 2.7 Логические операторы

**Подвиг 1.**
```python
d = int(input())
print((d % 7 == 0) * 100)
```

**Подвиг 2.**
```python
a, b, x = map(float, input().split())
res_in = a <= x < b
res_not_in = not (a <= x <= b)
```

**Подвиг 3.**
```python
a, b, c, d, x = map(float, input().split())
res_1 = (a < x < b) or (c <= x <= d)
res_2 = not (a < x < b) and (c <= x <= d)
res_3 = not (a < x < b) and not (c <= x <= d)
```

**Подвиг 4.**
```python
x0, y0, x1, y1, x, y = map(int, input().split())
is_into_rect = x0 < x < x1 and y0 < y < y1
is_not_into_rect = not is_into_rect
```

**Подвиг 5\*.**
```python
rect_width, rect_height, w, h = map(int, input().split())
cols = (rect_width + w - 1) // w
rows = (rect_height + h - 1) // h
total = cols * rows - (rect_width // w) * (rect_height // h)
```
