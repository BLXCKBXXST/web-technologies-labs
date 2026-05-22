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

---

## 6.1 Введение в словари

**Подвиг 1.** Правильные объявления:
- `{"river": "река", 'road': 'Дорога', 'one': 1}`
- `dict(you='ты', we='мы', they='они', us='нам')`
- `{}`
- `dict()`
- `dict([[1, 'one'], [2, 'two'], [3, 'three']])`

**Подвиг 2.** Правильные ключи:
- `d[1] = 'one'`
- `d[True] = 'истина'`
- `d["house"] = ['дом', 'жилище', 'хижина']`
- `d[5.6] = 5.6`
- `d['dict'] = {'one': 1, 'two': 2}`

**Подвиг 3.**
```python
d = dict()
for item in input().split():
    k, v = item.split("=")
    d[k] = int(v)
print(*sorted(d.items()))
```

**Подвиг 4.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
d = {}
for item in lst_in:
    k, v = item.split("=")
    d[int(k)] = v
print(*sorted(d.items()))
```

**Подвиг 5.**
```python
data = input().split()
d = dict(item.split("=") for item in data)
if "house" in d and "True" in d and "5" in d:
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 6.**
```python
data = input().split()
d = dict(item.split("=") for item in data)
if "False" in d:
    del d["False"]
if "3" in d:
    del d["3"]
print(*sorted(d.items()))
```

**Подвиг 7.**
```python
numbers = input().split()
d = {}
for num in numbers:
    code = num[:2]
    if code not in d:
        d[code] = []
    d[code].append(num)
print(*sorted(d.items()))
```

**Подвиг 8.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
d = {}
for item in lst_in:
    number, name = item.split()
    if name not in d:
        d[name] = []
    d[name].append(number)
print(*sorted(d.items()))
```

**Подвиг 9.**
```python
import math
cache = {}
while True:
    n = int(input())
    if n == 0:
        break
    if n in cache:
        print(f"значение из кэша: {cache[n]}")
    else:
        result = round(math.sqrt(n), 2)
        cache[n] = result
        print(result)
```

**Подвиг 10.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
cache = {}
for url in lst_in:
    if url in cache:
        print("Взято из кэша: " + cache[url])
    else:
        page = "HTML-страница для адреса " + url
        cache[url] = page
        print(page)
```

---

## 6.2 Методы словаря. Перебор его элементов в цикле

**Подвиг 1.** `d.copy()`; `dict(d)`

**Подвиг 2.** Соответствия методов:
- `fromkeys` — формирует словарь с ключами, указанными в списке
- `clear` — очищает словарь (удаляет все его элементы)
- `copy` — создает копию словаря
- `get` — возвращает значение по ключу
- `pop` — удаляет элемент словаря по ключу и возвращает удаленное значение
- `keys` — возвращает коллекцию из ключей словаря
- `values` — возвращает коллекцию из значений словаря
- `items` — возвращает записи в виде кортежей (ключ, значение)

**Подвиг 3.**
```python
lst = list(map(int, input().split()))
d = {}
for x in lst:
    d[x] = None
print(*d.keys())
```

**Подвиг 4.**
```python
morse = {
    'А': '.-', 'Б': '-...', 'В': '.--', 'Г': '--.', 'Д': '-..',
    'Е': '.', 'Ж': '...-', 'З': '--..', 'И': '..', 'Й': '.---',
    'К': '-.-', 'Л': '.-..', 'М': '--', 'Н': '-.', 'О': '---',
    'П': '.--.', 'Р': '.-.', 'С': '...', 'Т': '-', 'У': '..-',
    'Ф': '..-.', 'Х': '....', 'Ц': '-.-.', 'Ч': '---.', 'Ш': '----',
    'Щ': '--.-', 'Ъ': '--.--', 'Ы': '-.--', 'Ь': '-..-', 'Э': '..-..',
    'Ю': '..--', 'Я': '.-.-', ' ': '-...-'
}
s = input().upper().replace('Ё', 'Е')
res = [morse[ch] for ch in s]
print(" ".join(res))
```

**Подвиг 5.**
```python
morse = {
    'а': '.-', 'б': '-...', 'в': '.--', 'г': '--.', 'д': '-..',
    'е': '.', 'ж': '...-', 'з': '--..', 'и': '..', 'й': '.---',
    'к': '-.-', 'л': '.-..', 'м': '--', 'н': '-.', 'о': '---',
    'п': '.--.', 'р': '.-.', 'с': '...', 'т': '-', 'у': '..-',
    'ф': '..-.', 'х': '....', 'ц': '-.-.', 'ч': '---.', 'ш': '----',
    'щ': '--.-', 'ъ': '--.--', 'ы': '-.--', 'ь': '-..-', 'э': '..-..',
    'ю': '..--', 'я': '.-.-', ' ': '-...-'
}
decode = {v: k for k, v in morse.items()}
codes = input().split(" ")
res = ""
for c in codes:
    res += decode[c]
print(res)
```

**Подвиг 6.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
d = {}
for item in lst_in:
    bday, name = item.split()
    bday = int(bday)
    if bday not in d:
        d[bday] = []
    d[bday].append(name)
for bday in d:
    print(f"{bday}: {', '.join(d[bday])}")
```

**Подвиг 7.**
```python
things = {'карандаш': 20, 'зеркальце': 100, 'зонт': 500, 'рубашка': 300, 
          'брюки': 1000, 'бумага': 200, 'молоток': 600, 'пила': 400, 'удочка': 1200,
          'расческа': 40, 'котелок': 820, 'палатка': 5240, 'брезент': 2130, 'спички': 10}
n = int(input()) * 1000
items = sorted(things.items(), key=lambda x: x[1], reverse=True)
total = 0
res = []
for name, weight in items:
    if total + weight <= n:
        res.append(name)
        total += weight
print(*res)
```

---

## 6.3 Кортежи (tuple) и их методы

**Подвиг 1.** `(False,)`; `(1, 2, True, False)`; `tuple("python")`

**Подвиг 2.** упорядоченная коллекция данных; неизменяемый тип данных; расходует меньше памяти, чем списки

**Подвиг 3.**
```python
t = (3.4, -56.7)
t += tuple(map(int, input().split()))
print(t)
```

**Подвиг 4.**
```python
cities = tuple(input().split())
if "Москва" not in cities:
    cities += ("Москва",)
print(*cities)
```

**Подвиг 5.**
```python
cities = tuple(input().split())
if "Ульяновск" in cities:
    cities = tuple(c for c in cities if c != "Ульяновск")
print(*cities)
```

**Подвиг 6.**
```python
names = tuple(input().split())
res = [name.lower() for name in names if "ва" in name.lower()]
print(*res)
```

**Подвиг 7.**
```python
t = tuple(map(int, input().split()))
res = []
for x in t:
    if x not in res:
        res.append(x)
print(*res)
```

**Подвиг 8.**
```python
t = tuple(map(int, input().split()))
res = []
for i in range(len(t)):
    if t.count(t[i]) > 1:
        res.append(i)
print(*res)
```

**Подвиг 9.**
```python
t = ((1, 0, 0, 0, 0),
     (0, 1, 0, 0, 0),
     (0, 0, 1, 0, 0),
     (0, 0, 0, 1, 0),
     (0, 0, 0, 0, 1))
n = int(input())
t2 = tuple(row[:n] for row in t[:n])
for row in t2:
    print(*row)
```

**Подвиг 10.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
menu = tuple(tuple(item.split()) for item in lst_in)
print(menu)
```

---

## 6.4 Множества (set) и их методы

**Подвиг 1.** `{1, 1, 5, 5, True, 1}`; `set([1, 2, 3, 2, 1])`; `set()`

**Подвиг 2.** может хранить только данные неизменяемых типов; относится к изменяемому типу данных

**Подвиг 3.**
```python
s = set(map(float, input().split()))
print(*sorted(s))
```

**Подвиг 4.**
```python
words = input().lower().split()
print(len(set(words)))
```

**Подвиг 5.**
```python
s = input()
digits = set(ch for ch in s if ch.isdigit())
if digits:
    print(*sorted(digits))
else:
    print("НЕТ")
```

**Подвиг 6.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
print(len(set(lst_in)))
```

**Подвиг 7.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
names = set()
for item in lst_in:
    name = item.split(":")[0]
    names.add(name)
print(len(names))
```

**Подвиг 8.**
```python
cities = set()
while True:
    city = input()
    if city == "q":
        break
    cities.add(city)
print(len(cities))
```

---

## 6.5 Операции над множествами. Сравнение множеств

**Подвиг 1.**
```python
a = set(map(int, input().split()))
b = set(map(int, input().split()))
s = a & b
print(*sorted(s))
```

**Подвиг 2.**
```python
a = set(map(int, input().split()))
b = set(map(int, input().split()))
s = a - b
print(*sorted(s))
```

**Подвиг 3.**
```python
a = set(map(int, input().split()))
b = set(map(int, input().split()))
s = a ^ b
print(*sorted(s))
```

**Подвиг 4.**
```python
a = set(input().split())
b = set(input().split())
if a == b:
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 5.**
```python
marks = set(map(int, input().split()))
if 2 in marks:
    print("НЕ ДОПУЩЕН")
else:
    print("ДОПУЩЕН")
```

**Подвиг 6.**
```python
a = set(input().split())
b = set(input().split())
if a <= b:
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 7.**
```python
n = int(input())
factors = set()
for p in (2, 3, 5, 7):
    while n % p == 0:
        factors.add(p)
        n //= p
if {2, 3, 5} <= factors:
    print("ДА")
else:
    print("НЕТ")
```

---

## 6.6 Генераторы множеств и словарей

**Подвиг 1.** генератор списков; генератор множеств; генератор словарей; генератор целых чисел в виде арифметической прогрессии

**Подвиг 2.**
```python
data = input().split()
start = int(data[0])
words = data[1:]
d = {start + i: words[i] for i in range(len(words))}
print(d[4])
```

**Подвиг 3.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
unique = {car for car in lst_in}
print(len(unique))
```

**Подвиг 4.**
```python
words = input().split()
s = {w.lower() for w in words if len(w) >= 3}
print(len(s))
```

**Подвиг 5.**
```python
words = input().lower().split()
d = {w: words.count(w) for w in set(words)}
print(d.get("и", 0))
```

**Подвиг 6.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
authors = {line.split(": ", 1)[0] for line in lst_in}
d = {a: {line.split(": ", 1)[1] for line in lst_in if line.split(": ", 1)[0] == a} for a in authors}
```

---

## 6.7 Моржовая операция присваивания

**Подвиг 1.** Верные утверждения:
- моржовая операция может быть использована только в составе другого оператора языка Python
- моржовая операция создает переменную, если ее ранее не было
- моржовая операция имеет один из самых низких приоритетов (выполняется в последнюю очередь)

**Подвиг 2.** Рабочие определения:
- `d = [1, 2, tr := 3, 6, 3]`
- `while (t := float(input())) > 0: print(t)`
- `print(a := 5, a := a + 1)`

**Подвиг 3.** Верные утверждения:
- цикл while будет работать пока пользователь не введет отрицательное число (включая 0)
- при вводе положительных чисел переменная t будет принимать булево значение True

**Подвиг 4.** Верное утверждение:
- чтобы поменять местами первую и последнюю строки списка lst следует воспользоваться командой: lst[0], lst[-1] = row3, row1

**Подвиг 5.**
```python
t = tuple(map(int, input().split()))
s = 0
lst = [s := s + x for x in t]
print(*lst)
```

**Подвиг 6.**
```python
s = 0
while (x := int(input())) != 0:
    if x % 2 == 0:
        s += x
print(s)
```

**Подвиг 7.**
```python
def f(x):
    return abs(x) ** 0.5 + 3.2 + x


t = tuple(map(float, input().split()))
lst = [[(v := f(x)), v ** 2, v ** 3] for x in t]
```

**Подвиг 8.**
```python
p = 1
while (x := int(input())) > 0:
    if x % 3 == 0:
        p *= x
print(p)
```

<!-- AUTOGEN: модули 7+ (автосдача Stepik) -->

---

## 7.1 Что такое функции. Их объявление и вызов

**Подвиг 1.** len("123"); print(); dp = print; fl = len; len; print

**Подвиг 2.** имя функции - это ссылка на объект-функцию; оператор вызова функции - это (); функция выполняет фрагмент программы, записанный в теле функции; функция может быть вызвана в любом (допустимом) месте программы произвольное число раз; функция служит для устранения дублирования кода; именами функций следует выбирать глаголы (например, go, set, get и т.п.)

**Подвиг 3.**
```python
def my_function():
    print("It's my first function")


my_function()
```

**Подвиг 4.**
```python
def greet():
    name, surname = input().split()
    print(f"Уважаемый, {name} {surname}! Вы верно выполнили это задание!")


greet()
```

**Подвиг 5.**
```python
def show_weight(x):
    print(f"Предмет имеет вес: {x} кг.")


w = float(input())
show_weight(w)
```

**Подвиг 6.**
```python
def stats(lst):
    print(f"Min = {min(lst)}, max = {max(lst)}, sum = {sum(lst)}")


data = list(map(int, input().split()))
stats(data)
```

**Подвиг 7.**
```python
def perimeter(width, height):
    print(f"Периметр прямоугольника, равен {2 * (width + height)}")


w, h = map(int, input().split())
perimeter(w, h)
```

**Подвиг 8.**
```python
def check_email(email):
    allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_@."
    if "@" in email and "." in email and all(ch in allowed for ch in email):
        print("ДА")
    else:
        print("НЕТ")


check_email(input())
```

---

## 7.2 Оператор return

**Подвиг 1.**
```python
def get_sq(x):
    return x ** 2


n = float(input())
print(get_sq(n))
```

**Подвиг 2.**
```python
def is_triangle(a, b, c):
    return a < b + c and b < a + c and c < a + b
```

**Подвиг 3.**
```python
def is_large(s):
    return len(s) >= 3
```

**Подвиг 4.**
```python
def is_even(n):
    return n % 2 == 0


x = int(input())
while x != 1:
    if is_even(x):
        print(x)
    x = int(input())
```

**Подвиг 5.**
```python
def is_odd(n):
    return n % 2 != 0


lst_d = list(map(int, input().split()))
lst = [x for x in lst_d if is_odd(x)]
print(*lst)
```

**Подвиг 6.**
```python
tp = input().strip()
if tp == "RECT":
    def get_sq(length, width):
        return length * width
else:
    def get_sq(a):
        return a * a
```

**Подвиг 7.**
```python
def is_long(s):
    return len(s) >= 6


cities = input().split()
lst = [c for c in cities if is_long(c)]
print(*lst)
```

**Подвиг 8.**
```python
def str_len(s):
    return s, len(s)


cities = input().split()
d = {k: v for k, v in (str_len(c) for c in cities)}
a = sorted(d, key=d.get)
print(*a)
```

**Подвиг 9.**
```python
def multiply(a, b):
    return a * b


digs = list(map(int, input().split()))
print(multiply(min(digs), max(digs)))
```

---

## 7.3 Алгоритм Евклида для нахождения НОД

**Большой подвиг 1.**
```python
def get_nod(a, b):
    while b:
        a, b = b, a % b
    return a
```

---

## 7.4 Позиционные и именованные аргументы. Параметры со значениями

**Подвиг 1.** позиционные аргументы - это передаваемые функции значения, записанные через запятую; именованные аргументы - это значения с дополнительным указанием имени параметра функции; функция - это фрагмент программного кода, который можно вызвать из другого места программы по имени функции

**Подвиг 2.**
```python
def get_rect_value(length, width, tp=0):
    if tp == 0:
        return 2 * (length + width)
    return length * width
```

**Подвиг 3.**
```python
def check_password(password, chars="$%!?@#"):
    return len(password) >= 8 and any(c in chars for c in password)
```

**Подвиг 4.**
```python
def translit(s, sep="-"):
    t = {'ё': 'yo', 'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ж': 'zh',
         'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o', 'п': 'p',
         'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'ch', 'ш': 'sh',
         'щ': 'shch', 'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya'}
    s = s.lower()
    res = ""
    for ch in s:
        if ch == " ":
            res += sep
        elif ch in t:
            res += t[ch]
        else:
            res += ch
    return res


line = input()
print(translit(line))
print(translit(line, sep="+"))
```

**Подвиг 5.**
```python
def wrap_tag(s, tag="h1"):
    return f"<{tag}>{s}</{tag}>"


line = input()
print(wrap_tag(line))
print(wrap_tag(line, tag="div"))
```

**Подвиг 6. В функцию из предыдущего подвига 5 добавьте в конец еще один третий параметр up с начальным булевым значением True.**
```python
def wrap_tag(s, tag="h1", up=True):
    tag = tag.upper() if up else tag.lower()
    return f"<{tag}>{s}</{tag}>"


line = input()
print(wrap_tag(line, tag="div"))
print(wrap_tag(line, tag="div", up=False))
```

---

## 7.5 Функции с произвольным числом параметров

**Подвиг 1.** def func(*args): pass; def func(x, y, *args): pass; def func(*args, **kwargs): pass; def func(x, *args, type=True, **kwargs): pass; def func(*args, type=True, **kwargs): pass

**Подвиг 2.**
```python
def get_even(*args):
    return [x for x in args if x % 2 == 0]
```

**Подвиг 3.**
```python
def get_biggest_city(*cities):
    biggest = cities[0]
    for city in cities:
        if len(city) > len(biggest):
            biggest = city
    return biggest
```

**Подвиг 4.**
```python
def get_data_fig(*sides, **kwargs):
    result = [sum(sides)]
    for name in ("tp", "color", "closed", "width"):
        if name in kwargs:
            result.append(kwargs[name])
    return tuple(result)
```

**Большой подвиг 5.**
```python
import sys


def is_isolate(lst2D, i, j):
    n = len(lst2D)
    for di in (-1, 0, 1):
        for dj in (-1, 0, 1):
            if di == 0 and dj == 0:
                continue
            ni, nj = i + di, j + dj
            if 0 <= ni < n and 0 <= nj < n and lst2D[ni][nj] == 1:
                return False
    return True


def verify(lst2D):
    n = len(lst2D)
    for i in range(n):
        for j in range(n):
            if lst2D[i][j] == 1 and not is_isolate(lst2D, i, j):
                return False
    return True


lines = [s for s in sys.stdin.readlines() if s.strip()]
lst2D = [list(map(int, s.split())) for s in lines]
```

**Значимый подвиг 6.**
```python
def str_min(s1, s2):
    return s1 if s1 < s2 else s2


def str_min3(s1, s2, s3):
    return str_min(str_min(s1, s2), s3)


def str_min4(s1, s2, s3, s4):
    return str_min(str_min3(s1, s2, s3), s4)
```

---

## 7.6 Операторы упаковки и распаковки коллекций

**Подвиг 1.** [2, 3, 4]

**Подвиг 2.** print(1, 2, 3)

**Подвиг 3. На вход программе подаются семь целых чисел, записанных в одну строчку через пробел.**
```python
*lst, x, y, z = map(int, input().split())
print(*lst)
```

**Подвиг 4. На вход программе подается строка с названиями городов, записанных в одну строчку через пробел.**
```python
cities = input().split()
lst_c = (*cities,)
print(lst_c)
```

**Подвиг 5.**
```python
a, b = map(int, input().split())
lst = [*range(a, b + 1)]
print(*lst)
```

**Подвиг 6.**
```python
nums = input().split()
cities = input().split()
lst = [*nums, *cities]
print(*lst)
```

**Подвиг 7.**
```python
import sys

menu = {'Главная': 'home', 'Архив': 'archive', 'Новости': 'news'}
lst_in = list(map(str.strip, sys.stdin.readlines()))
extra = {}
for item in lst_in:
    name, url = item.split("=")
    extra[name] = url
menu = {**menu, **extra}
```

---

## 7.7 Символ звездочка (*) параметрах функции

**Подвиг 1.** в параметры s1, s2 функции compare_str можно передавать как позиционные, так и именованные аргументы; вызов функции compare_str("Java", "java", False) приведет к ошибке, т.к. в параметр ignore_case можно передавать только именованный аргумент; если вместо * в параметрах функции прописать *args, то в параметр ignore_case значение, по-прежнему, нужно будет передавать только с помощью именованного аргумента

**Подвиг 2.**
```python
def most_popular(people, *, case_sens=False):
    items = list(people) if case_sens else [p.lower() for p in people]
    best_name = items[0]
    best_count = 0
    for name in items:
        c = items.count(name)
        if c > best_count:
            best_count = c
            best_name = name
    return best_name, best_count


writers = input().split()
result = most_popular(writers, case_sens=True)
```

**Подвиг 3.**
```python
def count_chars(s, chars, *, return_type=tuple, ignore_case=True):
    txt = s.lower() if ignore_case else s
    target = chars.lower() if ignore_case else chars
    freqs = [txt.count(ch) for ch in target]
    return return_type(freqs)


text = input()
symbols = input()
result = count_chars(text, symbols, return_type=set, ignore_case=False)
```

**Подвиг 4.**
```python
def merge_dicts(dict1, *dicts, ignored_keys=None):
    ignored = set(ignored_keys) if ignored_keys else set()
    result = {}
    for d in (dict1, *dicts):
        for k, v in d.items():
            if k not in ignored:
                result[k] = v
    return result


goods = merge_dicts(goods1, goods2, goods3, goods4, ignored_keys=('id', 'date', 'cat_id'))
```

**Подвиг 5.** третий вызов функции symbol_upper с формированием значения res3 приведет к ошибке; переменная res2 будет ссылаться на строку "PyThon is the best language."

**Подвиг 6.**
```python
def filter_by_length(*strings, min_length=0, max_length):
    return [s for s in strings if min_length <= len(s) <= max_length]


names_initial = input().split()
names_result = filter_by_length(*names_initial, min_length=5, max_length=9)
```

**Подвиг 7.**
```python
def are_anagrams(s1, s2, *, start=0, end=-1, ignore_case=True):
    a = s1.lower() if ignore_case else s1
    b = s2.lower() if ignore_case else s2
    if end == -1:
        a, b = a[start:], b[start:]
    else:
        a, b = a[start:end], b[start:end]
    return sorted(a) == sorted(b)


words = input().split()
result = are_anagrams(*words, ignore_case=False)
```

---

## 7.8 Символ слэш (/) в параметрах функции

**Подвиг 1.** в параметры x и w функции model можно передавать только позиционные аргументы

**Подвиг 2.**
```python
def is_right_tr(a, b, c, /, precision=0.001):
    return (abs(c ** 2 - (a ** 2 + b ** 2)) < precision
            or abs(a ** 2 - (b ** 2 + c ** 2)) < precision
            or abs(b ** 2 - (a ** 2 + c ** 2)) < precision)


side_a, side_b, side_c = map(float, input().split())
result = is_right_tr(side_a, side_b, side_c)
```

**Подвиг 3.**
```python
def verify_password(psw, /, chars="@#!*", min_length=8):
    rus = "абвгдеёжзийклмнопрстуфхцчшщьыъэюя"
    if len(psw) < min_length:
        return False
    if not any(c in chars for c in psw):
        return False
    if any(c.lower() in rus for c in psw):
        return False
    return True


password = input()
result = verify_password(password, chars="0123456789", min_length=10)
```

**Подвиг 4.**
```python
def check_phone(phone, format_phone="8(xxx)xxx-xx-xx", /, format_symbol='x'):
    if len(phone) != len(format_phone):
        return False
    for ph, fc in zip(phone, format_phone):
        if fc == format_symbol:
            if not ph.isdigit():
                return False
        elif ph != fc:
            return False
    return True


phone_number = input()
result = check_phone(phone_number, "+7(***)*** ****", format_symbol='*')
```

**Подвиг 5.**
```python
DEBUG = 10, 'DEBUG'
INFO = 20, 'INFO'
WARNING = 30, 'WARNING'
ERROR = 40, 'ERROR'
CRITICAL = 50, 'CRITICAL'


def log_event(timestamp, message, /, *, level=INFO, format_log="[%(time)] %(levelname) - %(message)"):
    if level[0] < INFO[0]:
        return None
    text = format_log
    text = text.replace('%(time)', str(timestamp))
    text = text.replace('%(message)', message)
    text = text.replace('%(levelname)', level[1])
    text = text.replace('%(levelno)', str(level[0]))
    return text


log_time = int(input())
log_msg = input()
log_item = log_event(log_time, log_msg, level=WARNING,
                     format_log="%(levelname) - (%(time)) %(message)")
print(log_item)
```

**Подвиг 6.**
```python
def parser_data(text, /, max_count=0, *, ignore_sign=False):
    result = []
    i = 0
    n = len(text)
    while i < n:
        if text[i].isdigit():
            start = i
            while i < n and text[i].isdigit():
                i += 1
            num = text[start:i]
            if start > 0 and text[start - 1] in "+-":
                num = text[start - 1] + num
            if ignore_sign:
                num = num.lstrip("+-")
            result.append(num)
            if max_count and len(result) >= max_count:
                break
        else:
            i += 1
    return result


data_text = input()
result = parser_data(data_text, max_count=5, ignore_sign=True)
```

**Вызов 7*.**
```python
def is_right_rect(a, b, c, d, /, *, precision=0.001):
    d1 = ((a[0] - c[0]) ** 2 + (a[1] - c[1]) ** 2) ** 0.5
    d2 = ((b[0] - d[0]) ** 2 + (b[1] - d[1]) ** 2) ** 0.5
    return abs(d1 - d2) < precision


rect_coords = [(float(x.split('=')[0]), float(x.split('=')[1])) for x in input().split()]
result = is_right_rect(*rect_coords)
```

---

## 7.9 Рекурсивные функции

**Подвиг 1.** это функция, которая вызывает саму себя

**Подвиг 2. На вход программе подается целое положительное число N.**
```python
def get_rec_N(n):
    if n > 1:
        get_rec_N(n - 1)
    print(n)


N = int(input())
get_rec_N(N)
```

**Подвиг 3. На вход программе подаются целые числа, записанные через пробел.**
```python
def get_rec_sum(lst, i=0):
    if i == len(lst):
        return 0
    return lst[i] + get_rec_sum(lst, i + 1)


nums = list(map(int, input().split()))
print(get_rec_sum(nums))
```

**Подвиг 4. На вход программе подается натуральное число N (N >= 2), которое читается с помощью команды:.**
```python
def fib_rec(N, f):
    if len(f) >= N:
        return f[:N]
    f.append(f[-1] + f[-2])
    return fib_rec(N, f)


N = int(input())
result = fib_rec(N, [1, 1])
```

**Подвиг 5.**
```python
def fact_rec(n):
    if n <= 1:
        return 1
    return n * fact_rec(n - 1)


n = int(input())
```

**Подвиг 6. В программе объявлен следующий многомерный список:.**
```python
d = [1, 2, [True, False], ["Москва", "Уфа", [100, 101], ['True', [-2, -1]]], 7.89]


def get_line_list(d, a=None):
    if a is None:
        a = []
    for x in d:
        if isinstance(x, list):
            get_line_list(x, a)
        else:
            a.append(x)
    return a
```

**Подвиг 7.**
```python
def get_path(n):
    if n == 1:
        return 1
    if n == 2:
        return 2
    return get_path(n - 1) + get_path(n - 2)


N = int(input())
print(get_path(N))
```

**Великий подвиг 8.**
```python
def merge(left, right):
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result


def merge_sort(lst):
    if len(lst) <= 1:
        return lst
    mid = len(lst) // 2
    return merge(merge_sort(lst[:mid]), merge_sort(lst[mid:]))


nums = list(map(int, input().split()))
print(*merge_sort(nums))
```

---

## 7.10 Анонимные (lambda) функции

**Подвиг 1.** lambda x: x; lambda x, y: x+y; lambda a: -a; lambda: "hello lambda"

**Подвиг 2.**
```python
get_sq = lambda x: x ** 2
```

**Подвиг 3.**
```python
get_div = lambda a, b: None if b == 0 else a / b
```

**Подвиг 4.**
```python
get_abs = lambda n: -n if n < 0 else n
x = float(input())
print(get_abs(x))
```

**Подвиг 5.**
```python
check = lambda st: "ra" in st
s = input()
print(check(s))
```

**Подвиг 6.**
```python
def filter_lst(it, key):
    return tuple(x for x in it if key(x))


digs = list(map(int, input().split()))
print(*filter_lst(digs, lambda x: True))
print(*filter_lst(digs, lambda x: x < 0))
print(*filter_lst(digs, lambda x: x >= 0))
print(*filter_lst(digs, lambda x: 3 <= x <= 5))
```

---

## 7.11 Области видимости. Ключевые слова global и nonlocal

**Подвиг 1.** чтобы менять глобальные переменные в локальном окружении (например, внутри функций)

**Подвиг 2.** чтобы из одной локальной области обращаться к локальной переменной из внешней локальной области для ее изменения

**Подвиг 3.**
```python
WIDTH = int(input())


def func1():
    global WIDTH
    WIDTH += 1


func1()
print(WIDTH)
```

**Подвиг 4.**
```python
def func1():
    msg = input()

    def func2():
        nonlocal msg
        msg = input()

    func2()
    print(msg)
    print(msg)


func1()
```

**Подвиг 5.**
```python
def create_global(x):
    global TOTAL
    TOTAL = x
```

---

## 7.12 Замыкания в Python. Вложенные функции

**Подвиг 1.**
```python
def counter_add():
    def inner(x):
        return x + 5
    return inner


cnt = counter_add()
k = int(input())
print(cnt(k))
```

**Подвиг 2.**
```python
def counter_add(n):
    def inner(x):
        return x + n
    return inner


cnt = counter_add(2)
k = int(input())
print(cnt(k))
```

**Подвиг 3. Реализуйте в программе следующее замыкание функций.**
```python
def outer():
    def inner(s):
        return f"<h1>{s}</h1>"
    return inner


s = input()
f = outer()
print(f(s))
```

**Подвиг 4. Реализуйте в программе следующее замыкание функций. Объявите внешнюю функцию с одним параметром tag, в который будет передаваться тег (строка).**
```python
def outer(tag):
    def inner(s):
        return f"<{tag}>{s}</{tag}>"
    return inner


tag = input()
content = input()
f = outer(tag)
print(f(content))
```

**Подвиг 5. Реализуйте в программе следующее замыкание функций. Объявите внешнюю функцию с одним параметром tp, в который будет передаваться тип коллекции (строка).**
```python
def outer(tp):
    def inner(s):
        nums = list(map(int, s.split()))
        return nums if tp == 'list' else tuple(nums)
    return inner


tp = input()
data = input()
f = outer(tp)
lst = f(data)
print(lst)
```

---

## 7.13 Декораторы функций

**Подвиг 1.**
```python
def get_sq(width, height):
    return width * height


def func_show(func):
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        print(f"Площадь прямоугольника: {result}")
        return result
    return wrapper
```

**Подвиг 2.**
```python
menu = input()


def show_menu(func):
    def wrapper(*args, **kwargs):
        lst = func(*args, **kwargs)
        for i, item in enumerate(lst, 1):
            print(f"{i}. {item}")
        return lst
    return wrapper


@show_menu
def get_menu(s):
    return s.split()
```

**Подвиг 3.**
```python
data = input()


def sort_dec(func):
    def wrapper(*args, **kwargs):
        return sorted(func(*args, **kwargs))
    return wrapper


@sort_dec
def get_list(s):
    return list(map(int, s.split()))


lst = get_list(data)
print(*lst)
```

**Подвиг 4. На вход программе поступают две строки.**
```python
s1 = input()
s2 = input()


def to_dict(func):
    def wrapper(*args, **kwargs):
        lst1, lst2 = func(*args, **kwargs)
        return dict(zip(lst1, lst2))
    return wrapper


@to_dict
def make_lists(x, y):
    return x.split(), y.split()


d = make_lists(s1, s2)
print(*sorted(d.items()))
```

**Подвиг 5.**
```python
def collapse_dec(func):
    def wrapper(*args, **kwargs):
        s = func(*args, **kwargs)
        while "--" in s:
            s = s.replace("--", "-")
        return s
    return wrapper


@collapse_dec
def translit(s):
    t = {'ё': 'yo', 'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ж': 'zh',
         'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o', 'п': 'p',
         'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'ch', 'ш': 'sh',
         'щ': 'shch', 'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya'}
    s = s.lower()
    res = ""
    for ch in s:
        if ch in " :;.,_":
            res += "-"
        elif ch in t:
            res += t[ch]
        else:
            res += ch
    return res


s = input()
print(translit(s))
```

---

## 7.14 Передача аргументов декораторам

**Подвиг 1.**
```python
data = input()


def start_dec(start):
    def decorator(func):
        def wrapper(*args, **kwargs):
            return func(*args, **kwargs) + start
        return wrapper
    return decorator


@start_dec(start=5)
def get_sum(s):
    return sum(map(int, s.split()))


print(get_sum(data))
```

**Подвиг 2.**
```python
def tag_dec(tag="h1"):
    def decorator(func):
        def wrapper(*args, **kwargs):
            s = func(*args, **kwargs)
            return f"<{tag}>{s}</{tag}>"
        return wrapper
    return decorator


@tag_dec(tag="div")
def to_lower(s):
    return s.lower()


s = input()
print(to_lower(s))
```

**Подвиг 3.**
```python
def chars_dec(chars=" !?"):
    def decorator(func):
        def wrapper(*args, **kwargs):
            s = func(*args, **kwargs)
            for ch in chars:
                s = s.replace(ch, "-")
            while "--" in s:
                s = s.replace("--", "-")
            return s
        return wrapper
    return decorator


@chars_dec(chars="?!:;,. ")
def translit(s):
    t = {'ё': 'yo', 'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ж': 'zh',
         'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o', 'п': 'p',
         'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'ch', 'ш': 'sh',
         'щ': 'shch', 'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya'}
    s = s.lower()
    res = ""
    for ch in s:
        res += t.get(ch, ch)
    return res


s = input()
print(translit(s))
```

**Подвиг 4.**
```python
from functools import wraps


def sum_dec(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        return sum(func(*args, **kwargs))
    return wrapper


@sum_dec
def get_list(s):
    '''Функция для формирования списка целых значений'''
    return list(map(int, s.split()))
```

---

## 7.15 Промежуточные испытания

**Вызов 1.**
```python
words = ['вино', 'сука', 'срок', 'арка', 'тура', 'сова', 'жара', 'день', 'жгут', 'урна', 'заяц', 'зона', 'звук', 'гора', 'гусь', 'руна', 'суша', 'тара', 'враг', 'арба', 'кара', 'поза', 'бобр', 'икра', 'слон', 'доза', 'знак', 'груз', 'глаз', 'жаба', 'база', 'дока', 'губа', 'блин', 'жена', 'доля', 'роса', 'бита', 'каюк', 'друг', 'вера', 'заря', 'дыра', 'буря', 'дача', 'вода', 'кафр', 'дума', 'драп', 'баян', 'суха', 'диво', 'грач', 'дочь', 'брат', 'дуга', 'каюр', 'крюк', 'звон', 'пола', 'вата', 'град', 'банк', 'рука', 'сока', 'урюк', 'иней', 'дека', 'борт', 'бокс', 'сухо', 'мура', 'балл', 'врач', 'долг', 'урок', 'стон', 'мука', 'азот', 'лука', 'кафе', 'жест', 'вход', 'волк', 'муха', 'блок', 'гриф', 'жбан', 'двор', 'дело', 'зима', 'ваза', 'рана', 'сток', 'змея', 'каре', 'горе', 'полк', 'роза', 'арфа', 'игра']


def find_chain_words(words, start_word, end_word, chain=None):
    def diff_one(w1, w2):
        return sum(c1 != c2 for c1, c2 in zip(w1, w2)) == 1

    queue = [[start_word]]
    visited = {start_word}
    while queue:
        path = queue.pop(0)
        if path[-1] == end_word:
            return path
        for w in words:
            if w not in visited and diff_one(path[-1], w):
                visited.add(w)
                queue.append(path + [w])
    return []


start_word = 'тара'
end_word = 'сухо'
chain_result = find_chain_words(words, start_word, end_word)
```

**Вызов 2.**
```python
import random

N = 10
size_ships = (4, 3, 3, 2, 2, 2, 1, 1, 1, 1)


def try_fill():
    board = [[0] * N for _ in range(N)]
    for ship in size_ships:
        for _ in range(3000):
            horizontal = random.randint(0, 1)
            r = random.randint(0, N - 1)
            c = random.randint(0, N - 1)
            cells = []
            ok = True
            for k in range(ship):
                rr = r if horizontal else r + k
                cc = c + k if horizontal else c
                if rr >= N or cc >= N:
                    ok = False
                    break
                cells.append((rr, cc))
            if not ok:
                continue
            for rr, cc in cells:
                for dr in (-1, 0, 1):
                    for dc in (-1, 0, 1):
                        nr, nc = rr + dr, cc + dc
                        if 0 <= nr < N and 0 <= nc < N and board[nr][nc]:
                            ok = False
            if not ok:
                continue
            for rr, cc in cells:
                board[rr][cc] = 1
            break
        else:
            return None
    return board


game_board = None
while game_board is None:
    game_board = try_fill()
```

---

## 8.1 Импорт стандартных модулей. Команды import и from

**Подвиг 1.** import time; import time as tm; from time import *

**Подвиг 2.**
```python
import math
x = float(input())
print(math.ceil(x))
```

**Подвиг 3.**
```python
from math import floor
x = float(input())
print(floor(x))
```

**Подвиг 4.**
```python
from math import factorial as fact


def factorial(n):
    p = 1
    for i in range(2, n+1):
        p *= i

    print("my factorial")
    return p
```

**Подвиг 5.**
```python
from random import seed, randint
seed(1)
print(randint(10, 50))
```

**Подвиг 6.**
```python
from random import seed, random as rnd
seed(10)
print(round(rnd(), 2))
```

**Подвиг 7.** Каждый с новой строки: import random    import math    import time; from math import floor, ceil, pi; from math import floor as fl, ceil as cl, pi

---

## 8.2 Импорт собственных модулей

**Подвиг 1.** import panda; from panda import *

**Подвиг 2.** import libs.panda; from libs.panda import *

**Подвиг 3.** import panda; from panda import *

**Подвиг 4.** import panda; from panda import PND, panda_say

**Подвиг 5.** модуль panda импортируется только один (первый) раз

**Подвиг 6.** модуль импортируется и строчка с функцией print будет выполнена

**Подвиг 7.** panda.kungfu.KUNGFU

**Подвиг 8.** __name__ == "__main__"

**Подвиг 9.** позволяет повторно импортировать модули

---

## 8.3 Установка сторонних модулей. Пакетная установка

**Подвиг 1.** отображает список установленных модулей для текущего интерпретатора

**Подвиг 2.** pip install Django; pip install Django==2.1.2; pip install -r requirements.txt

**Подвиг 3.** создает текстовый файл со списком установленных модулей и номерами их версий

**Подвиг 4.** для поиска сторонних модулей (для их последующей установки)

---

## 8.4 Пакеты (package) в Python

**Подвиг 1.** пакет - это каталог с набором модулей и обязательным файлом __init__.py

**Подвиг 2.** import panda_pack; from panda_pack import *

**Подвиг 3.** он исполняется при импорте пакета

**Подвиг 4.** import panda_pack.panda; from panda_pack.panda import *; from .panda import *

**Подвиг 5.** panda_pack.panda.PND

**Подвиг 7.** импортируется только модуль panda1

---

## 8.5 Функция open. Чтение данных из файла

**Подвиг 1.** в текущем рабочем каталоге открывается файловый поток на чтение данных из файла 'my_file.txt'; переменная head будет содержать первые три прочитанных символа; переменная v будет хранить размер файла 'my_file.txt' в байтах

**Подвиг 2.**
```python
f_log = open('log.dat', encoding='utf-8')
data = f_log.readlines()
f_log.close()
header = data[0]
last_data = data[-1]
```

**Подвиг 3.** Соответствия:
- `read()` — выполняет чтение данных от текущей позиции либо до конца файла, либо на заданное количество символов
- `readline()` — выполняет чтение данных от текущей позиции и до конца строки или файла
- `readlines()` — выполняет чтение строк из файла, начиная с текущей позиции
- `seek()` — позволяет менять значение файловой позиции (без чтения данных)
- `tell()` — возвращает значение текущей файловой позиции

**Подвиг 4.**
```python
f_inp = open('sites/links.txt', encoding='windows-1251')
f_inp.seek(0, 2)
size_file = f_inp.tell()
f_inp.close()
```

**Подвиг 5.**
```python
f_text = open('course.new.dat', encoding='utf-8')
data = f_text.read()
f_text.close()
start_5 = data[:5]
end_5 = data[-5:]
```

**Подвиг 6.**
```python
fp = open('projects/python/works.my', encoding='utf-8')
data = fp.read()
fp.close()
fragment = data[9:20]
```

**Подвиг 7.**
```python
fp = open('stuff/persons.dat', encoding='utf-8')
lines = fp.readlines()
fp.close()
num_person = 0
for i, line in enumerate(lines, 1):
    parts = line.split()
    if len(parts) >= 3 and parts[0] == "Сергей" and parts[2] == "Балакирев":
        num_person = i
        break
```

**Подвиг 8.** для освобождения ресурсов, связанных с этим файлом; чтобы не потерялись записанные данные в файл

---

## 8.6 Обработка исключения FileNotFoundError и менеджер контекста

**Подвиг 1. Выберите все верные утверждения, касающиеся следующей программы:.** менеджер контекста with автоматически закрывает файловое соединение; файл students.db открывается только на чтение данных

**Подвиг 2.**
```python
try:
    with open('diagnostics.csv', encoding='utf-8') as f:
        success_open_file = True
        header = f.readline()
        row = f.readline()
except FileNotFoundError:
    success_open_file = False
```

**Подвиг 3.**
```python
success_open_file = True
success_file_operations = True
try:
    with open('images/targets.dat', encoding='utf-8') as f:
        last_row = f.readlines()[-1]
except FileNotFoundError:
    success_open_file = False
except Exception:
    success_file_operations = False
```

**Подвиг 4.**
```python
try:
    with open('bank.csv', encoding='utf-8') as f:
        header = f.readline().strip()
        values = f.readline().strip()
    row_data = dict(zip(header.split(','), values.split(',')))
except FileNotFoundError:
    pass
```

**Подвиг 5.**
```python
try:
    with open('logs/01-01-2025/log_app.txt', encoding='utf-8') as f:
        log_errors = [line.strip() for line in f if '[ERROR]' in line]
except FileNotFoundError:
    pass
```

**Подвиг 6.**
```python
try:
    with open('python/course_text.txt', encoding='windows-1251') as f:
        text = f.read()
        idx = text.lower().find('python')
        f.seek(0)
        if idx != -1:
            f.read(idx)
except FileNotFoundError:
    pass
```

---

## 8.7 Запись данных в файл

**Подвиг 1.** если файл files.txt существует, то его открытие в режиме 'w' приведет к потере всего его содержимого

**Подвиг 2.** Соответствия:
- `r` — только чтение данных в текстовом режиме доступа
- `w` — только запись данных в текстовом режиме доступа
- `a` — только на дозапись данных в текстовом режиме доступа
- `r+` — чтение и запись данных; генерация ошибки FileNotFoundError, если файл не существует
- `w+` — чтение и запись данных; если файл не существует, то он создается; если файл существовал, то его содержимое очищается
- `a+` — чтение и дозапись данных; данные читаются целиком (во всем файле), а записываются только после имеющегося содержимого

**Подвиг 3.**
```python
msg = input()
with open('letter.txt', mode='w', encoding='utf-8') as f:
    f.write(msg)
```

**Подвиг 4.**
```python
msg = input()
with open('work_data/log_stats.txt', mode='a+', encoding='utf-8') as f:
    f.write(msg)
    f.seek(0)
    header = f.readline()
```

**Подвиг 5.** некоторые записываемые данные могут быть потеряны

**Подвиг 6.**
```python
try:
    with open('lib/text_1', encoding='utf-8') as f1, open('lib/text_2', encoding='utf-8') as f2:
        f1.readline()
        data1 = f1.read()
        f2.readline()
        data2 = f2.read()
    with open('text_all.txt', mode='w', encoding='windows-1251') as out:
        out.write(data1 + '\n' + data2)
except FileNotFoundError:
    pass
```

**Подвиг 7.**
```python
try:
    with open('lang_doc/python_base.dat', encoding='utf-8') as f1:
        data1 = f1.read()
    with open('lang_doc/java_base.dat', encoding='utf-8') as f2:
        data2 = f2.read()
    with open('lang_doc/python_base.dat', mode='w', encoding='utf-8') as f1:
        f1.write(data2)
    with open('lang_doc/java_base.dat', mode='w', encoding='utf-8') as f2:
        f2.write(data1)
except FileNotFoundError:
    pass
```

**Подвиг 8.** функции модуля pickle позволяют преобразовывать объекты разных типов в набор байтовых данных; модуль pickle небезопасен в своей работе, с точки зрения уязвимости программного кода

**Подвиг 9.** Соответствия:
- `dumps()` — кодирует объект в байтовую строку
- `loads()` — декодирует (восстанавливает) объект по байтовой строке
- `dump()` — кодирует объект с передачей байтовых данных в указанный поток
- `load()` — декодирует (восстанавливает) объект из указанного байтового потока

---

## 9.1 Выражения-генераторы

**Подвиг 1.**
```python
gen = (x for x in range(2, 10001))
```

**Подвиг 2.**
```python
a, b = map(int, input().split())
tp = tuple(x ** 2 for x in range(a, b + 1))
```

**Подвиг 3.**
```python
a, b = map(int, input().split())
gen = (abs(x) for x in range(a, b + 1))
for _ in range(5):
    print(next(gen))
```

**Подвиг 4.** sum(gen); max(gen); min(gen); list(gen); set(gen); tuple(gen)

**Подвиг 5.** меньший расход памяти; возможность оперировать очень большими объемами данных

**Подвиг 6.**
```python
a = int(input())
g1 = (abs(x) for x in range(-a, a + 1))
g2 = (x ** 3 for x in g1)
result = [next(g2) for _ in range(4)]
print(*result)
```

**Подвиг 7.**
```python
from string import ascii_lowercase
gen = (c1 + c2 for c1 in ascii_lowercase for c2 in ascii_lowercase)
result = [next(gen) for _ in range(50)]
print(*result)
```

**Подвиг 8.**
```python
cities = ["Москва", "Ульяновск", "Самара", "Уфа", "Омск", "Тула"]
gen = (cities[i % len(cities)] for i in range(1000000))
result = [next(gen) for _ in range(20)]
print(*result)
```

**Подвиг 9.**
```python
a, b = map(int, input().split())
gen = (round(0.5 * pow(a + i * 0.01, 2) - 2.0, 2) for i in range(2000))
result = [next(gen) for _ in range(20)]
print(*result)
```

---

## 9.2 Функция-генератор. Оператор yield

**Подвиг 1.**
```python
N = int(input())


def get_sum(total):
    s = 0
    for i in range(1, total + 1):
        s += i
        yield s
```

**Подвиг 2.**
```python
N = int(input())


def balak_seq(max_len):
    a = b = c = 1
    count = 0
    while count < max_len:
        if count < 3:
            yield 1
        else:
            nxt = a + b + c
            a, b, c = b, c, nxt
            yield nxt
        count += 1


g = balak_seq(N)
print(*[next(g) for _ in range(N)])
```

**Подвиг 3.**
```python
from string import ascii_lowercase, ascii_uppercase
import random

N = int(input())
chars = ascii_lowercase + ascii_uppercase + "0123456789!?@#$*"
random.seed(1)


def gen_password(n):
    while True:
        yield "".join(chars[random.randint(0, len(chars) - 1)] for _ in range(n))


g = gen_password(N)
for _ in range(5):
    print(next(g))
```

**Подвиг 4.**
```python
from string import ascii_lowercase, ascii_uppercase
import random

N = int(input())
chars = ascii_lowercase + ascii_uppercase
random.seed(1)


def gen_email(max_size):
    while True:
        name = "".join(chars[random.randint(0, len(chars) - 1)] for _ in range(max_size))
        yield name + "@mail.ru"


g = gen_email(N)
for _ in range(5):
    print(next(g))
```

**Подвиг 5.**
```python
def gen_primes():
    n = 2
    while True:
        is_p = True
        for d in range(2, int(n ** 0.5) + 1):
            if n % d == 0:
                is_p = False
                break
        if is_p:
            yield n
        n += 1


g = gen_primes()
print(*[next(g) for _ in range(20)])
```

---

## 9.3 Функция map

**Подвиг 1.**
```python
data = input().split()
m = map(float, data)
print(next(m), next(m), next(m))
```

**Подвиг 2.**
```python
lst = list(map(abs, map(int, input().split())))
print(*lst)
```

**Подвиг 3.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
lst2D = [list(map(int, row.split())) for row in lst_in]
```

**Подвиг 4.**
```python
s = input()
tp = tuple(map(lambda x: tuple(x.split("=")), s.split()))
```

**Подвиг 5.**
```python
t = {'ё': 'yo', 'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ж': 'zh',
     'з': 'z', 'и': 'i', 'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o', 'п': 'p',
     'р': 'r', 'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'ch', 'ш': 'sh',
     'щ': 'shch', 'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya'}
s = input().lower()
print("".join(map(lambda ch: t.get(ch, "-"), s)))
```

**Подвиг 6. На вход программе подается строка с названиями городов, записанных в одну строчку через пробел.**
```python
print(*map(lambda c: c if len(c) > 5 else "-", input().split()))
```

---

## 9.4 Функция filter

**Подвиг 1.**
```python
f = filter(lambda c: len(c) > 5, input().split())
print(next(f), next(f), next(f))
```

**Подвиг 2.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
tp = tuple(map(lambda x: tuple(x.split("=")), lst_in))
result = filter(lambda p: int(p[1]) >= 500, tp)
print(*[p[0] for p in result])
```

**Подвиг 3.**
```python
nums = list(map(int, input().split()))
print(*filter(lambda x: 10 <= abs(x) <= 99, nums))
```

**Подвиг 4.**
```python
a = set(map(int, input().split()))
b = set(map(int, input().split()))
result = sorted(filter(lambda x: x % 2 == 0, a & b))
print(*result)
```

**Подвиг 5.**
```python
def valid(e):
    allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_@."
    if not all(c in allowed for c in e):
        return False
    if "@" not in e:
        return False
    return "." in e[e.index("@"):]


print(*filter(valid, input().split()))
```

---

## 9.5 Функция zip

**Подвиг 1.**
```python
a = list(map(int, input().split()))
b = list(map(int, input().split()))
m = map(lambda p: p[0] * p[1], zip(a, b))
print(next(m), next(m), next(m))
```

**Подвиг 2. На вход программе подается неравномерная таблица целых чисел.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
rows = [row.split() for row in lst_in]
for r in zip(*zip(*rows)):
    print(*r)
```

**Подвиг 3.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
lst2D = [list(map(int, row.split())) for row in lst_in]
for col in zip(*lst2D):
    print(*col)
```

**Подвиг 4.**
```python
words = input().split()
for row in zip(words[0::3], words[1::3], words[2::3]):
    print(*row)
```

**Подвиг 5.**
```python
s = input()
lst = list(zip(s, range(10)))
```

---

## 9.6 Сортировка с помощью sort и sorted

**Подвиг 1.** метод sort применим только к спискам (среди базовых типов данных); метод sort сортирует список, для которого вызывается; функция sorted возвращает отсортированный список для итерируемого объекта

**Подвиг 2.**
```python
s = input()
data = list(map(int, s.split()))
lst = list(data)
lst.sort()
tp = tuple(data)
tp_lst = tuple(sorted(tp))
```

**Подвиг 3. Объявите в программе функцию со следующей сигнатурой:.**
```python
def get_sort(d):
    return [d[k] for k in sorted(d, reverse=True)]
```

**Подвиг 4.**
```python
nums = set(map(int, input().split()))
print(*sorted(nums, reverse=True)[:4])
```

**Подвиг 5.**
```python
a = sorted(map(int, input().split()))
b = sorted(map(int, input().split()), reverse=True)
print(*[x + y for x, y in zip(a, b)])
```

**Подвиг 6.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
d = {}
for item in lst_in:
    name, price = item.rsplit(":", 1)
    d[int(price)] = name


def cheapest3(dct):
    return [dct[p] for p in sorted(dct)[:3]]


print(*cheapest3(d))
```

---

## 9.7 Аргумент key для сортировки по ключу

**Подвиг 1.**
```python
rivers = input().split()
print(*sorted(rivers, key=len, reverse=True))
```

**Подвиг 2.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
d = {}
for item in lst_in:
    name, weight = item.split("=")
    d[name] = int(weight)
print(*sorted(d, key=lambda k: d[k], reverse=True))
```

**Подвиг 3.**
```python
order = {'до': 0, 'ре': 1, 'ми': 2, 'фа': 3, 'соль': 4, 'ля': 5, 'си': 6}
notes = input().split()
print(*sorted(notes, key=lambda n: order[n]))
```

**Значимый подвиг 4.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))


def conv(c):
    return int(c) if c.lstrip("-").isdigit() else c


rows = [tuple(conv(c) for c in line.split(";")) for line in lst_in]
header = rows[0]
desired = ['Имя', 'Зачет', 'Оценка', 'Номер']
col_order = sorted(range(len(header)), key=lambda i: desired.index(header[i]))
t_sorted = tuple(tuple(row[i] for i in col_order) for row in rows)
```

**Подвиг 5.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
ranks = ['рядовой', 'сержант', 'старшина', 'прапорщик', 'лейтенант',
         'капитан', 'майор', 'подполковник', 'полковник']
lst = [list(item.split("=")) for item in lst_in]
lst.sort(key=lambda x: ranks.index(x[1]))
```

---

## 9.8 Функция isinstance для проверки типов данных

**Подвиг 1.** функция isinstance выполняет проверку типов с учетом их наследования; функция type возвращает фактический тип для переданного ей аргумента (без учета наследования); пример вызова функции: isinstance(x, float); пример вызова функции: isinstance(x, (str, float)); пример вызова функции: type(x) == bool; пример вызова функции: type(x) is int; пример вызова функции: type(x) in (float, int)

**Подвиг 2.**
```python
def get_add(a, b):
    def is_num(x):
        return isinstance(x, (int, float)) and not isinstance(x, bool)
    if is_num(a) and is_num(b):
        return a + b
    if isinstance(a, str) and isinstance(b, str):
        return a + b
    return None
```

**Подвиг 3.**
```python
def get_sum(it):
    s = 0
    for x in it:
        if isinstance(x, int) and not isinstance(x, bool):
            s += x
    return s
```

**Подвиг 4.**
```python
def get_even_sum(it):
    s = 0
    for x in it:
        if isinstance(x, int) and not isinstance(x, bool) and x % 2 == 0:
            s += x
    return s
```

**Подвиг 5. Объявите в программе функцию с именем get_list_digследующей сигнатуры:.**
```python
def get_list_dig(lst):
    return [x for x in lst if isinstance(x, (int, float)) and not isinstance(x, bool)]
```

---

## 9.9 Функции all и any

**Подвиг 1.**
```python
nums = list(map(int, input().split()))
print(all(x % 2 == 0 for x in nums))
```

**Подвиг 2.**
```python
nums = list(map(float, input().split()))
print(any(x < 0 for x in nums))
```

**Подвиг 3. В программе объявите функцию с именем is_string следующей сигнатуры:.**
```python
def is_string(lst):
    return all(isinstance(x, str) for x in lst)
```

**Подвиг 4.**
```python
marks = list(map(int, input().split()))
print("отчислен" if any(m < 3 for m in marks) else "учится")
```

**Подвиг 5. На вход программе подается текущее игровое поле для игры "Крестики-нолики" в виде следующей таблицы (списка строк):.**
```python
import sys
lst_in = list(map(str.strip, sys.stdin.readlines()))
pole = [row.split() for row in lst_in]


def is_free(lst):
    return any('#' in row for row in lst)
```

---

## 10.1 Расширенное представление чисел

**Подвиг 1.** `0.01`

**Подвиг 2.** `780`

**Подвиг 3.** `10`

**Подвиг 4.** `45`

**Подвиг 5.** 45.6; 1e4; 0b111; -0b1101; 0xff; -0xa9f; 0o45

**Подвиг 6.** `169`

**Подвиг 7.** `207`

**Подвиг 8.** `8`

**Подвиг 9.** `44`

---

## 10.2 Битовые операции И, ИЛИ, НЕ, XOR

**Подвиг 1.** Соответствия:
- `~` — битовое НЕ
- `|` — битовое ИЛИ
- `&` — битовое И
- `^` — исключающее ИЛИ (XOR)
- `>>` — сдвиг бит вправо
- `<<` — сдвиг бит влево

**Подвиг 2.**
```python
n = int(input())
print(n | (1 << 3))
```

**Подвиг 3.**
```python
n = int(input())
print(n & ~(1 << 4) & ~(1 << 1))
```

**Подвиг 4.**
```python
n = int(input())
print(n ^ (1 << 3) ^ (1 << 0))
```

**Подвиг 5.**
```python
n = int(input())
print(n << 2)
```

**Подвиг 6.**
```python
n = int(input())
print(n >> 1)
```

**Подвиг 7. На вход программе подается зашифрованное слово.**
```python
key = 123
s = input()
print("".join(chr(ord(ch) ^ key) for ch in s))
```

**Подвиг 8.**
```python
n = int(input())
if n & (1 << 6) and n & (1 << 3):
    print("ДА")
else:
    print("НЕТ")
```

**Подвиг 9.**
```python
n = int(input())
if n & (1 << 5) or n & (1 << 1):
    print("ДА")
else:
    print("НЕТ")
```

---

## 10.3 Модуль random стандартной библиотеки

**Подвиг 1.** Соответствия:
- `seed` — установка "зерна" датчика случайных чисел
- `random` — генерация вещественных случайных величин в диапазоне [0; 1)
- `randint` — генерация целочисленных случайных величин в диапазоне [a; b]
- `gauss` — генерация гауссовских случайных величин
- `choice` — выбор случайного элемента из последовательности
- `shuffle` — перемешивание элементов последовательности
- `sample` — выбор случайной подпоследовательности из последовательности

**Подвиг 2.**
```python
import random
random.seed(1)
a, b = map(int, input().split())
print(round(a + random.random() * (b - a), 2))
```

**Подвиг 3.**
```python
import random
random.seed(1)
a, b = map(int, input().split())
print(random.randint(a, b))
```

**Подвиг 4. На вход программе подается строка с названиями городов, записанных через пробел.**
```python
import random
random.seed(1)
cities = input().split()
print(random.choice(cities))
```

**Подвиг 5.**
```python
import sys
import random
random.seed(1)
lst_in = list(map(str.strip, sys.stdin.readlines()))
lst2D = [list(map(int, row.split())) for row in lst_in]
cols = list(zip(*lst2D))
random.shuffle(cols)
for row in zip(*cols):
    print(*row)
```

**Подвиг 6. На вход программе подается строка с именами студентов, записанными через пробел.**
```python
import random
random.seed(1)
names = input().split()
print(*random.sample(names, 3))
```

**Значимый подвиг 7.**
```python
import random

N = int(input())


def fill():
    P = [[0] * N for i in range(N)]
    placed = 0
    attempts = 0
    while placed < 10:
        attempts += 1
        if attempts > 100000:
            return None
        r = random.randint(0, N - 1)
        c = random.randint(0, N - 1)
        if P[r][c] == 1:
            continue
        ok = True
        for dr in (-1, 0, 1):
            for dc in (-1, 0, 1):
                nr, nc = r + dr, c + dc
                if 0 <= nr < N and 0 <= nc < N and P[nr][nc] == 1:
                    ok = False
        if ok:
            P[r][c] = 1
            placed += 1
    return P


P = None
while P is None:
    P = fill()
```

---

## 10.4 Конструкция match/case. Первое знакомство

**Подвиг 1.** Выбран пункт номер 5

**Подвиг 2.** Неподдерживаемый тип запроса

**Подвиг 3.** POST-запрос

**Подвиг 4.** Ошибка загрузки страницы

**Подвиг 5.**
```python
cmd = input()
match cmd.lower():
    case "top":
        print("Команда top")
    case "bottom":
        print("Команда bottom")
    case "right":
        print("Команда right")
    case "left":
        print("Команда left")
    case _:
        print("Неверная команда")
```

**Подвиг 6.**
```python
def get_data(value):
    match value:
        case int():
            res = value
            return res
        case float():
            res = value
            return res
        case str():
            res = value
            return res

    return None
```

**Подвиг 7.**
```python
def get_data(value):
    match value:
        case int() if value > 0:
            return value
        case float() if -100 <= value <= 100:
            return value
        case str():
            return value

    return None
```

---

## 10.5 Конструкция match/case с кортежами и списками

**Подвиг 1.** Петр, Иванович, Сидоров

**Подвиг 2.** 2

**Подвиг 3.** 5

**Подвиг 4.**
```python
t = (int, str, str, float, int)
book = [t[i](x) if t[i] != str else x.strip() for i, x in enumerate(input().split(","))]

match book:
    case [_, author, title]:
        print("Yes")
    case [_, author, title, price]:
        print("Yes")
    case [_, author, title, price, year]:
        print("Yes")
    case _:
        print("No")
```

**Подвиг 5.**
```python
t = (int, str, str, float, int)
book = [t[i](x) if t[i] != str else x.strip() for i, x in enumerate(input().split(","))]

match book:
    case [_, author, title] if len(author) >= 6 and len(title) >= 10:
        print("Yes")
    case [_, author, title, price] if len(author) >= 6 and price > 0:
        print("Yes")
    case [_, author, title, year] if year >= 2020:
        print("Yes")
    case [_, author, title, price, year] if price > 0 and year >= 2020:
        print("Yes")
    case _:
        print("No")
```

---

## 10.6 Конструкция match/case со словарями и множествами

**Подвиг 1.** 1

**Подвиг 2.** case {'marks': ms, 'age': age, 'fio': fio} if age == 22: ...; case {'marks': ms, 'age': age} if age == 22: ...; case {'marks': m, 'age': 22}: ...

**Подвиг 3.** case {'marks': ms, 'age': age, 'fio': fio} if ms.count(2) > 1: ...; case {'marks': ms, 'age': age} if ms.count(2) > 1: ...; case {'marks': ms, 'age': int() | float() as age, 'fio': fio} if ms.count(2) > 1: ...; case {'marks': ms, 'fio': str(fio)} if ms.count(2) > 1: ...

**Подвиг 4.**
```python
def parse_json(data):
    match data:
        case {'access': bool() as access, 'data': list() as lst} if lst:
            return access, lst[0]
        case {'id': ids, 'data': [_, {'login': login}, _, _]}:
            return ids, login

    return None


json_data = {'id': 2, 'access': False, 'data': ['26.05.2023', {'login': '1234', 'email': 'xxx@mail.com'}, 2000, 56.4]}
```

**Подвиг 5.**
```python
def parse_json(data):
    match data:
        case {'access': True, 'data': [_, {'login': str() as login, 'email': str() as email}, *_]}:
            return login, email
        case {'id': ids, 'data': [_, {'login': login}, _, _]}:
            return ids, login

    return None


json_data = {'id': 2, 'access': True, 'data': ['26.05.2023', {'login': '1234', 'email': 'xxx@mail.com'}, 2000, 56.4]}
```

---

## 10.8 Итоговое испытание

**Итоговое испытание.** Продолжить изучение ООП языка Python на курсе "Добрый, добрый Python ООП"

