# Практическая работа №15
**Программирование на Python (Stepik)**

Решения учебных задач курса по программированию на Python. Все решения рассчитаны на Python 3.12; задачи на Stepik проверяются через `stdin → stdout`.

---

## 1.3 Варианты выполнения команд. Переходим в PyCharm

**Подвиг 1.**
```python
print("Hello Python!")
```

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

## 2.1 Переменные, оператор присваивания, функции type и id

**Подвиг 1.** ссылка на объект в памяти

**Подвиг 2.** связывает переменную с данными; создает переменную, если ее ранее не было

**Подвиг 3.** допустимы: `a = 6`, `a = b = 0`

**Подвиг 4.** копирование ссылки и обе переменные ссылаются на один и тот же объект

**Подвиг 5.** каскадным присваиванием

**Подвиг 6.** множественным присваиванием

**Подвиг 7.** для определения типа объекта

**Подвиг 8.** допустимые имена: `var_a`, `_b`, `__arg_c__`, `TT1`, `d25`, `S`

**Подвиг 9.** да

**Подвиг 10.** верные присвоения: `b = 5.8`, `b = "hello"`, `b = "True"`

**Подвиг 11.** переменная type будет ссылаться на число 7

---

## 2.2 Числа и операции над ними

**Подвиг 2.** вещественному

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

## 2.3 Математические функции и модуль math

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

## 2.4 функции print и input

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

## 2.6 Логический тип Bool. Операторы сравнения

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

## 2.7 Булевы подвиги

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

---

## 3.1 Введение в строки. Операции над строками

**Подвиг 1.** одинарных; двойных; тройных одинарных (`'''строка'''`); тройных двойных (`"""строка"""`)

**Подвиг 2.** тройных одинарных; тройных двойных

**Подвиг 3.** `\n`

**Подвиг 4.**
```python
s1 = input()
s2 = input()
print(s1 + " " + s2)
```

**Подвиг 5.** при выводе в консоль с помощью print(fio) имя и фамилия будут отображаться друг под другом (на разных строках); символ \n является символом переноса строк

**Подвиг 6.** `787878`

**Подвиг 7.**
```python
a, b = input().split()
print((a + " ") * 2 + (b + " ") * 2 + b)
```

**Подвиг 8.**
```python
a, b = map(int, input().split())
print("Переменная a = " + str(a) + ", переменная b = " + str(b))
```

**Подвиг 9.**
```python
s = input()
print("Строка: " + s + ". Длина: " + str(len(s)))
```

**Подвиг 10.**
```python
a, b = input().split()
print(a in b, a == b, a > b, a < b)
```

**Подвиг 11.**
```python
a, b = input().split()
print(f"Коды: {a} = {ord(a)}, {b} = {ord(b)}")
```

---

## 3.2 Индексы и срезы строк

**Подвиг 1.** к неизменяемым типам

**Подвиг 2.**
```python
s = input()
print(s[0] + s[-1])
```

**Подвиг 3.** и

**Подвиг 4.** ничего, будет ошибка IndexError

**Подвиг 5.**
```python
s = input()
print(s[:4])
```

**Подвиг 6.**
```python
s = input()
print(s[-3:])
```

**Подвиг 7.**
```python
s = input()
print(s[1::2])
```

**Подвиг 8.**
```python
s1 = input()
s2 = input()
print(s1[::2] + " " + s2[1::2])
```

**Подвиг 9.**
```python
s = input()
print(s[4::-1])
```

**Подвиг 10.**
```python
word1, word2 = input().split()
print(word2[:len(word1)])
```

**Подвиг 11.**
```python
word1, word2 = input().split()
print(word1[:len(word2)][1::2] == word2[1::2])
```

---

## 3.3 Основные методы строк

**Подвиг 1.** Соответствия методов:
- `String.upper` — Возвращает строку с заглавными буквами
- `String.lower` — Возвращает строку с малыми буквами
- `String.count` — Определяет число вхождений подстроки в строке
- `String.find` — Возвращает индекс первого найденного вхождения
- `String.replace` — Заменяет указанную подстроку на новый фрагмент
- `String.split` — Разбивает строку на подстроки
- `String.join` — Объединяет коллекцию в строку

**Подвиг 2.**
```python
s = input().lower()
print(s[0] + s[1].upper() + s[2:])
```

**Подвиг 3.**
```python
s = input()
print(s.count("-"))
```

**Подвиг 4.** ничего, возникнет ошибка ValueError

**Подвиг 5.** значение -1

**Подвиг 6.**
```python
s = input()
print(s.find("ra"))
```

**Подвиг 7.**
```python
s = input()
print(s.replace("---", "-").replace("--", "-"))
```

**Подвиг 8.**
```python
a, b, c = input().split()
print(a.zfill(3), b.zfill(3), c.zfill(3), sep="\n")
```

**Подвиг 9.**
```python
s = input()
print(len(s.split()))
```

**Подвиг 10.**
```python
s = input()
print(";".join(s.split()))
```

**Подвиг 11.** Соответствия методов:
- `String.rjust` — Расширяет строку, добавляя символы слева
- `String.ljust` — Расширяет строку, добавляя символы справа
- `String.strip` — Удаляет пробелы и переносы строк справа и слева
- `String.rstrip` — Удаляет пробелы и переносы строк справа
- `String.lstrip` — Удаляет пробелы и переносы строк слева
- `String.rfind` — Возвращает индекс первого найденного вхождения при поиске справа

---

## 3.4 Спецсимволы и экранирование символов

**Подвиг 1.** Соответствия спецсимволов:
- `\n` — Перевод строки
- `\\` — Символ обратного слеша
- `\’` — Символ апострофа (одинарной кавычки)
- `\"` — Символ двойной кавычки
- `\b` — Эмуляция клавиши BackSpace
- `\r` — Возврат каретки
- `\t` — Горизонтальная табуляция

**Подвиг 2.**
```python
s = 'Тема занятия "спецсимволы"'
print(s)
```

**Подвиг 3.**
```python
a, b = input().split()
print(a + "\\" + b)
```

**Подвиг 4.**
```python
s = input()
print(s.replace(" ", "'", 1).replace(" ", '"'))
```

**Подвиг 5.**
```python
s = r"C:\WINDOWS\System32\drivers\etc\hosts"
print(s)
```

**Подвиг 6.**
```python
s = input()
print('"' + s + '"')
```

---

## 3.5 Форматирование строк и F-строки

**Подвиг 1.**
```python
name = input()
surname = input()
age = input()
print("Уважаемый {} {}! Поздравляем Вас с {}-летием!".format(name, surname, age))
```

**Подвиг 2.**
```python
width, depth, height = input().split()
print("Габариты: {w} x {d} x {h}".format(w=width, d=depth, h=height))
```

**Подвиг 3.**
```python
a, b = map(int, input().split())
print(f"{min(a, b)} {max(a, b)}")
```

**Подвиг 4.**
```python
city = input()
street = input()
house = input()
flat = input()
print(f"г. {city}, ул. {street}, д. {house}, кв. {flat}")
```

**Подвиг 5.**
```python
rate = float(input())
rubles = int(input())
dollars = int(rubles / rate)
print(f"Вы можете получить {dollars}$ за {rubles} рублей по курсу {rate}")
```

---

## 3.6 Списки и операции над ними

**Подвиг 1.** к изменяемым

**Подвиг 2.** `[ ]`; `list()`

**Подвиг 3.**
```python
lst = list(map(int, input().split()))
print(lst)
```

**Подвиг 4.**
```python
cities = input().split()
print("Москва" in cities)
```

**Подвиг 5.** `3`; `-3`

**Подвиг 6.**
```python
cities = input().split()
print(cities[-1])
```

**Подвиг 7.**
```python
marks = list(map(int, input().split()))
print(round(sum(marks) / len(marks), 1))
```

**Подвиг 8.**
```python
title = input()
author = input()
pages = int(input())
price = float(input())
book = [title, author, pages, price]
del book[2]
book[1] = "Пушкин"
book[2] = book[2] * 2
print(book)
```

**Подвиг 9.**
```python
lst = list(map(int, input().split()))
print(max(lst), min(lst), sum(lst))
```

**Подвиг 10.**
```python
lst = list(map(int, input().split()))
lst.sort(reverse=True)
print(*lst)
```

**Подвиг 11.** Соответствия операторов:
- `+` — соединение двух списков в один
- `*` — дублирование списка
- `in` — проверка вхождения элемента в список
- `del` — удаление элемента списка

**Подвиг 12.**
```python
cities = ["Москва", "Тверь", "Вологда"]
lst = cities + input().split()
print(*lst)
```

**Подвиг 13.**
```python
cities = ["Москва", "Тверь", "Вологда"]
lst = input().split() + cities
print(*lst)
```

---

## 3.7 Срезы списков. Операторы сравнения списков

**Подвиг 1.**
```python
v = [1205, 1101, 1434, 1320, 923, 874]
print(v[:3])
```

**Подвиг 2.**
```python
v = [1205, 1101, 1434, 1320, 923, 874]
print(v[-4:])
```

**Подвиг 3.**
```python
c = ["Москва", "Ульяновск", "Самара", "Тверь", "Вологда", "Омск", "Уфа"]
print(c[::2])
```

**Подвиг 4.**
```python
c = ["Москва", "Ульяновск", "Самара", "Тверь", "Вологда", "Омск", "Уфа"]
print(c[1::2])
```

**Подвиг 5.**
```python
m = [2, 3, 5, 5, 2, 2, 3, 3, 4, 5, 4, 4]
print(m[6:1:-1])
```

**Подвиг 6.**
```python
m = [2, 3, 5, 5, 2, 2, 3, 3, 4, 5, 4, 4]
print(m[::-2])
```

**Подвиг 7.** `True`

**Подвиг 8.** `True`

**Подвиг 9.** `True`

**Подвиг 10.** `False`

**Подвиг 11.** возникнет ошибка TypeError

---

## 3.8 Методы списков

**Подвиг 1.** Соответствия методов:
- `append` — Добавляет элемент в конец списка
- `insert` — Вставляет элемент в указанное место списка
- `remove` — Удаляет элемент по значению
- `pop` — Удаляет последний элемент, либо элемент с указанным индексом
- `clear` — Очищает список (удаляет все элементы)

**Подвиг 2.**
```python
lst = list(map(int, input().split()))
lst.append(lst[0] != lst[-1])
print(*lst)
```

**Подвиг 3.**
```python
cities = ["Москва", "Казань", "Ярославль"]
cities.insert(1, "Ульяновск")
print(*cities)
```

**Подвиг 4.**
```python
lst = list(input())
lst.pop(0)
lst[0] = "8"
lst.remove("-")
lst.remove("-")
print("".join(lst))
```

**Подвиг 5.**
```python
name, patronymic, surname = input().split()
print(f"{surname} {name[0]}.{patronymic[0]}.")
```

**Подвиг 6.** Соответствия методов:
- `copy` — Возвращает копию списка
- `count` — Возвращает число элементов с указанным значением
- `index` — Возвращает индекс первого найденного элемента
- `reverse` — Меняет порядок следования элементов на обратный
- `sort` — Сортирует элементы списка

**Подвиг 7.**
```python
lst = sorted(map(int, input().split()))
print(*lst[:3])
```

**Подвиг 8.**
```python
lst = list(map(int, input().split()))
last = lst.pop()
lst.append(last % 2 == 1)
print(*lst)
```

**Подвиг 9.**
```python
lst = list(map(int, input().split()))
print(lst.count(2))
```

**Подвиг 10.**
```python
lst = input().split()
lst.sort()
del lst[0]
print(*lst)
```

---

## 3.9 Вложенные списки

**Подвиг 1.**
```python
lst = [5.4, 6.7, 10.4]
digs = list(map(int, input().split()))
lst.append(digs)
print(lst)
```

**Подвиг 2.**
```python
s1 = input()
s2 = input()
s3 = input()
lst = [s1.split(), s2.split(), s3.split()]
print(lst)
```

**Подвиг 3.**
```python
r1 = input()
r2 = input()
r3 = input()
matrix = [list(map(int, r1.split())), list(map(int, r2.split())), list(map(int, r3.split()))]
print(matrix[0][-1], matrix[1][-1], matrix[2][-1])
```

**Подвиг 4.** `a[1][2][1][0]`

**Подвиг 5.** `del a[1][2][2]`

**Подвиг 6.**
```python
t = [["Скажи-ка", "дядя", "ведь", "не", "даром"],
    ["Я", "Python", "выучил", "с", "каналом"],
    ["Балакирев", "что", "раздавал?"]]
word = input()
print(word in t[0] or word in t[1] or word in t[2])
```

---

## 4.1 Условный оператор if. Конструкция if-else

**Подвиг 1.**
```python
a, b = map(float, input().split())
if a > b:
    print(a)
else:
    print(b)
```

**Подвиг 2.**
```python
s = input().lower()
if s == s[::-1]:
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 3.**
```python
m, n = map(int, input().split())
if m % n == 0:
    print(m // n)
else:
    print(f"{m} на {n} нацело не делится")
```

**Подвиг 4.**
```python
a, b, c = map(int, input().split())
if c ** 2 == a ** 2 + b ** 2:
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 5.**
```python
n = int(input())
if n % 10 == 7:
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 6.**
```python
s = input()
if "t" in s and "h" in s and "o" in s:
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 7.**
```python
cities = input().split()
if "Москва" in cities:
    cities.remove("Москва")
print(*cities)
```

**Подвиг 8.**
```python
a, b, c, d = map(int, input().split())
if (c + 2 <= a and d + 2 <= b) or (d + 2 <= a and c + 2 <= b):
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 9.**
```python
n = input()
if int(n[0]) + int(n[1]) + int(n[2]) == int(n[3]) + int(n[4]) + int(n[5]):
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 10.**
```python
t = float(input())
if t % 5 < 3:
    print("green")
else:
    print("red")
```

---

## 4.2 Вложенные условия и множественный выбор

**Подвиг 1.**
```python
m = '''1. Введение в Python
2. Строки и списки
3. Условные операторы
4. Циклы
5. Словари, кортежи и множества
6. Выход'''
items = m.split("\n")
n = int(input())
if n == 1:
    print(items[0])
elif n == 2:
    print(items[1])
elif n == 3:
    print(items[2])
elif n == 4:
    print(items[3])
elif n == 5:
    print(items[4])
else:
    print(items[5])
```

**Подвиг 2.**
```python
a, b, c = map(int, input().split())
if a <= b and a <= c:
    print(a)
elif b <= a and b <= c:
    print(b)
else:
    print(c)
```

**Подвиг 3.**
```python
w = float(input())
if w <= 60:
    print(1)
elif w <= 64:
    print(2)
elif w <= 69:
    print(3)
else:
    print(4)
```

**Подвиг 4.**
```python
n = int(input())
if n == 1:
    print("понедельник")
elif n == 2:
    print("вторник")
elif n == 3:
    print("среда")
elif n == 4:
    print("четверг")
elif n == 5:
    print("пятница")
elif n == 6:
    print("суббота")
else:
    print("воскресенье")
```

**Подвиг 5.**
```python
m = int(input())
if m == 2:
    print(28)
elif m in (4, 6, 9, 11):
    print(30)
else:
    print(31)
```

**Подвиг 6.**
```python
days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
m, n = map(int, input().split())

if n > 1:
    pm, pd = m, n - 1
else:
    pm, pd = m - 1, days[m - 2]

if n < days[m - 1]:
    nm, nd = m, n + 1
else:
    nm, nd = m + 1, 1

print(f"{pm:02}.{pd:02} {nm:02}.{nd:02}")
```

**Подвиг 7.**
```python
k = int(input())
day = (k - 1) % 7
if day == 0:
    print("понедельник")
elif day == 1:
    print("вторник")
elif day == 2:
    print("среда")
elif day == 3:
    print("четверг")
elif day == 4:
    print("пятница")
elif day == 5:
    print("суббота")
else:
    print("воскресенье")
```

---

## 4.3 Тернарный условный оператор

**Подвиг 1.**
```python
a = float(input())
b = float(input())
d = a if a > b else b
print(d)
```

**Подвиг 2.**
```python
n = int(input())
msg = "кратно 3" if n % 3 == 0 else "не кратно 3"
print(msg)
```

**Подвиг 3.**
```python
s = input().lower()
msg = "палиндром" if s == s[::-1] else "не палиндром"
print(msg)
```

**Подвиг 4.**
```python
n = int(input())
print("True" if n == 1 else "False")
```

**Подвиг 5.**
```python
t = int(input())
print(0 if t == 59 else t + 1)
```

**Подвиг 6.**
```python
m = ['до', 'ре', 'ми', 'фа', 'соль', 'ля', 'си']
a, b, c = map(int, input().split())
n1 = m[a - 1]
n2 = m[b - 1]
n3 = m[c - 1]
s1 = "#" + n1 if n1 in ("до", "фа") else n1
s2 = "#" + n2 if n2 in ("до", "фа") else n2
s3 = "#" + n3 if n3 in ("до", "фа") else n3
print(s1, s2, s3)
```

---

## 5.1 Оператор цикла while

**Подвиг 1.** Соответствия терминов:
- тело цикла — набор операторов, выполняемых в цикле
- итерация — однократное выполнение тела цикла
- заголовок цикла — оператор цикла с условием цикла

**Подвиг 2.**
```python
n, m = map(int, input().split())
res = []
while n <= m:
    res.append(n ** 2)
    n += 1
print(*res)
```

**Подвиг 3.**
```python
x = float(input())
i = 2
res = []
while i <= 10:
    res.append(round(x * i, 1))
    i += 1
print(*res)
```

**Подвиг 4.**
```python
n = int(input())
s = 0
i = 1
while i <= n:
    s += 1 / i
    i += 1
print(round(s, 3))
```

**Подвиг 5.**
```python
s = 0
x = int(input())
while x != 0:
    s += x
    x = int(input())
print(s)
```

**Подвиг 6.**
```python
s = input()
while "--" in s:
    s = s.replace("--", "-")
print(s)
```

**Подвиг 7.**
```python
n = int(input())
p = 1
while n > 0:
    p *= n % 10
    n //= 10
print(p)
```

**Подвиг 8.**
```python
n = int(input())
a, b = 1, 1
res = []
i = 0
while i < n:
    res.append(a)
    a, b = b, a + b
    i += 1
print(*res)
```

**Подвиг 9.**
```python
n = int(input())
cells = 1
t = 3
while t <= n:
    cells *= 2
    t += 3
print(cells)
```

**Подвиг 10.**
```python
n = int(input())
sum_ = 1000
i = 0
while i < n:
    sum_ += sum_ * 0.05
    i += 1
print(round(sum_, 2))
```

**Подвиг 11.**
```python
n, m = map(int, input().split())
i = n + 1 - n % 2
res = []
while i <= m:
    res.append(i)
    i += 2
print(*res)
```

**Подвиг 12.**
```python
n = 100
res = []
while n <= 999:
    if n % 47 == 43 and n % 3 == 0:
        res.append(n)
    n += 1
print(*res)
```

---

## 5.2 Операторы break, continue и else

**Подвиг 1.** Соответствия операторов:
- `break` — досрочное прерывание работы оператора цикла
- `continue` — пропуск одной итерации цикла
- `else` — блок операторов, исполняемых при штатном завершении цикла

**Подвиг 2.**
```python
p = [0] * 10
count = 0
while count < 5:
    i = int(input())
    if p[i] == 1:
        continue
    p[i] = 1
    count += 1
print(*p)
```

**Подвиг 3.**
```python
p = 1
while True:
    x = int(input())
    if x == 0:
        break
    if x < 0:
        continue
    p *= x
print(p)
```

**Подвиг 4.**
```python
cities = input().split()
i = 0
result = "ДА"
while i < len(cities):
    if len(cities[i]) <= 5:
        result = "НЕТ"
        break
    i += 1
print(result)
```

**Подвиг 5.**
```python
names = input().split()
i = 0
result = "НЕТ"
while i < len(names):
    name = names[i].lower()
    if name[0] == name[-1]:
        result = "ДА"
        break
    i += 1
print(result)
```

**Подвиг 6.**
```python
n = int(input())
res = []
i = 1
while i <= n:
    if n >= 100:
        break
    if i % 3 == 0 and i % 5 == 0:
        res.append(i)
    i += 1
else:
    print(*res)

if n >= 100:
    print("слишком большое значение n")
```

**Подвиг 7.**
```python
n = int(input())
i = 1
while i ** 2 <= n:
    i += 1
print(i)
```

**Подвиг 8.**
```python
x = int(input())
day = 1
dist = 10
while dist <= x:
    day += 1
    dist += dist * 0.1
print(day)
```

**Подвиг 9.**
```python
books = []
while True:
    try:
        books.append(input())
    except EOFError:
        break

i = 0
while i < len(books):
    if len(books[i].split()) >= 2:
        del books[i]
    else:
        i += 1
print(*books)
```

---

## 5.3 Оператор цикла for и функция range

**Подвиг 1.**
```python
print(*range(11))
```

**Подвиг 2.**
```python
print(*range(-10, 1))
```

**Подвиг 3.**
```python
print(*range(-10, 0, 2))
```

**Подвиг 4.**
```python
print(*range(1, 20, 3))
```

**Подвиг 5.**
```python
lst = list(map(int, input().split()))
s = 0
for x in lst:
    if x % 2 != 0:
        s += x
print(s)
```

**Подвиг 6.**
```python
cities = input().split()
for i in range(len(cities)):
    cities[i] = len(cities[i])
print(*cities)
```

**Подвиг 7.**
```python
n = int(input())
for i in range(1, n + 1):
    if n % i == 0:
        print(i)
```

**Подвиг 8.**
```python
n = int(input())
result = "ДА"
for i in range(2, n):
    if n % i == 0:
        result = "НЕТ"
        break
if n < 2:
    result = "НЕТ"
print(result)
```

**Подвиг 9.**
```python
cities = input().split()
result = "ДА"
for i in range(len(cities) - 1):
    prev = cities[i].lower()
    j = len(prev) - 1
    while prev[j] in "ьъы":
        j -= 1
    last = prev[j]
    first = cities[i + 1][0].lower()
    if last != first:
        result = "НЕТ"
        break
print(result)
```

**Подвиг 10.**
```python
n = int(input())
s = 0
for i in range(1, n):
    if i % 3 == 0 or i % 5 == 0:
        s += i
print(s)
```

---

## 5.4 Примеры работы оператора цикла for. Функция enumerate

**Подвиг 1.**
```python
s = input()
res = []
idx = s.find("ра")
while idx != -1:
    res.append(idx)
    idx = s.find("ра", idx + 1)
if res:
    print(*res)
else:
    print(-1)
```

**Подвиг 2.**
```python
s = input()
template = "+7(ddd)ddd-dd-dd"
ok = len(s) == len(template)
if ok:
    for i in range(len(template)):
        if template[i] == "d":
            if not s[i].isdigit():
                ok = False
                break
        elif s[i] != template[i]:
            ok = False
            break
print("ДА" if ok else "НЕТ")
```

**Большой подвиг 3.**
```python
s = input().replace(" ", "")
result = 0
num = ""
sign = 1
for ch in s:
    if ch == "+" or ch == "-":
        if num != "":
            result += sign * int(num)
            num = ""
        sign = 1 if ch == "+" else -1
    else:
        num += ch
result += sign * int(num)
print(result)
```

**Подвиг 4.**
```python
digits = list(map(int, input().split()))
for i, x in enumerate(digits):
    digits[i] = x ** 2
print(*digits)
```

**Подвиг 5.**
```python
lst = list(map(int, input().split()))
res = []
for x in lst:
    res.append(x)
    res.append(x)
print(*res)
```

**Подвиг 6.**
```python
lst = list(map(float, input().split()))
m = lst[0]
for x in lst:
    if x < m:
        m = x
print(m)
```

**Подвиг 7.**
```python
lst = list(map(float, input().split()))
for i, x in enumerate(lst):
    if x < 0:
        lst[i] = -1.0
print(*lst)
```

---

## 5.5 Итератор и итерируемые объекты. Функции iter и next

**Подвиг 1.** `iter(7)`; `iter(True)`

**Подвиг 2.**
```python
cities = input().split()
it = iter(cities)
print(next(it))
print(next(it))
```

**Подвиг 3.**
```python
s = input()
it = iter(s)
res = ""
for ch in it:
    if ch == " ":
        break
    res += ch
print(res)
```

**Подвиг 4.**
```python
n = input()
it = iter(n)
print(*it)
```

**Подвиг 5.** ошибка StopIteration

---

## 5.6 Вложенные циклы

**Подвиг 1.**
```python
n = int(input())
matrix = [[1] * n for _ in range(n)]
for row in matrix:
    row[-1] = 5
for row in matrix:
    print(*row)
```

**Подвиг 2.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
for url in lst_in:
    print("-".join(url.split()))
```

**Подвиг 3.**
```python
n = int(input())
res = []
for num in range(2, n):
    is_prime = True
    for d in range(2, num):
        if num % d == 0:
            is_prime = False
            break
    if is_prime:
        res.append(num)
print(*res)
```

**Подвиг 4.**
```python
import sys
s = sys.stdin.readlines()
lst_in = [list(map(int, x.strip().split())) for x in s]

result = "ДА"
for i in range(5):
    for j in range(5):
        if lst_in[i][j] == 1:
            for di in (-1, 0, 1):
                for dj in (-1, 0, 1):
                    if di == 0 and dj == 0:
                        continue
                    ni, nj = i + di, j + dj
                    if 0 <= ni < 5 and 0 <= nj < 5 and lst_in[ni][nj] == 1:
                        result = "НЕТ"
print(result)
```

**Подвиг 5.**
```python
import sys
s = sys.stdin.readlines()
lst_in = [list(map(int, x.strip().split())) for x in s]

result = "ДА"
for i in range(5):
    for j in range(5):
        if lst_in[i][j] != lst_in[j][i]:
            result = "НЕТ"
print(result)
```

**Большой подвиг 6.**
```python
lst = list(map(int, input().split()))
for i in range(len(lst)):
    min_idx = i
    for j in range(i + 1, len(lst)):
        if lst[j] < lst[min_idx]:
            min_idx = j
    lst[i], lst[min_idx] = lst[min_idx], lst[i]
print(*lst)
```

**Большой подвиг 7.**
```python
lst = list(map(int, input().split()))
n = len(lst)
for i in range(n - 1):
    for j in range(n - 1 - i):
        if lst[j] > lst[j + 1]:
            lst[j], lst[j + 1] = lst[j + 1], lst[j]
print(*lst)
```

**Подвиг 8.**
```python
n = int(input())
res = []
for bill in (64, 32, 16, 8, 4, 2, 1):
    count = n // bill
    res += [bill] * count
    n %= bill
print(*res)
```

---

## 5.8 Генераторы списков (List comprehension)

**Подвиг 1.**
```python
lst = list(map(float, input().split()))
lst_abs = [abs(x) for x in lst]
print(lst_abs)
```

**Подвиг 2.**
```python
n = input()
lst = [int(d) for d in n]
print(lst)
```

**Подвиг 3.**
```python
cities = input().split()
res = [c for c in cities if len(c) > 5]
print(*res)
```

**Подвиг 4.**
```python
n = int(input())
lst = [i for i in range(1, n + 1) if n % i == 0]
print(*lst)
```

**Подвиг 5.**
```python
n = int(input())
matrix = [[i] * n for i in range(n)]
for row in matrix:
    print(*row)
```

**Подвиг 6.**
```python
lst = list(map(float, input().split()))
lst_res = [x for x in lst if int(x) % 2 == 0]
print(*lst_res)
```

**Подвиг 7.**
```python
a = list(map(int, input().split()))
b = list(map(int, input().split()))
res = [a[i] + b[i] for i in range(len(a))]
print(*res)
```

**Подвиг 8.**
```python
data = input().split()
lst = [[data[i], int(data[i + 1])] for i in range(0, len(data), 2)]
print(lst)
```

---

## 5.9 Вложенные циклы и вложенные генераторы списков

**Подвиг 1.**
```python
n = int(input())
matrix = [[1 if i == j else 0 for j in range(n)] for i in range(n)]
for row in matrix:
    print(*row)
```

**Подвиг 2.**
```python
import sys
s = sys.stdin.readlines()
lst_in = [list(map(int, x.strip().split())) for x in s]

res = [x for row in lst_in for x in row][::-1]
print(*res)
```

**Подвиг 3.**
```python
data = list(map(int, input().split()))
n = int(len(data) ** 0.5)
lst = [data[i * n:(i + 1) * n] for i in range(n)]
print(lst)
```

**Подвиг 4.**
```python
t = ["– Скажи-ка, дядя, ведь не даром",
    "Я Python выучил с каналом",
    "Балакирев что раздавал?",
    "Ведь были ж заданья боевые,",
    "Да, говорят, еще какие!",
    "Недаром помнит вся Россия",
    "Как мы рубили их тогда!"
    ]
lst = [[w for w in line.split() if len(w) > 3] for line in t]
print(lst)
```

**Подвиг 5.**
```python
import sys
s = sys.stdin.readlines()
lst_in = [list(map(int, x.strip().split())) for x in s]

A = [[lst_in[i][j] for i in range(len(lst_in))] for j in range(len(lst_in[0]))]
for row in A:
    print(*row)
```
