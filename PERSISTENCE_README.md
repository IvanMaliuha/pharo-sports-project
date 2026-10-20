# SportsProject — Persistence

## 1. Опис

Модуль `SportsPersistence` реалізує збереження та завантаження даних спортсменів у форматах CSV і JSON у середовищі Pharo.

Після завантаження даних відновлюються об'єкти класів `TennisPlayer` і `FootballPlayer` з відповідними полями.

Також реалізовано імітацію бази даних у пам'яті за допомогою `OrderedCollection`.

## 2. Реалізовані методи

**Робота з файлами:**
- `dataDirectory` — визначає папку для збереження даних.
- `saveToCSV:` — зберігає спортсменів у CSV.
- `loadFromCSV` / `loadAthletesFromCSV` — забезпечують читання CSV та відновлення об'єктів.
- `saveToJSON:` — зберігає спортсменів у JSON.
- `loadFromJSON` — відновлює спортсменів із JSON.

**База даних у пам'яті:**
- `initialize` — створює порожню колекцію.
- `addAthlete:` — додає спортсмена.
- `getAllAthletes` — повертає колекцію спортсменів.
- `clearDatabase` — очищає базу.

## 3. Файли даних

У папці `data/` зберігаються:

- `sportspeople.csv` — дані спортсменів у CSV.
- `sportspeople.json` — дані спортсменів у JSON.
- `test_results.txt` — результати перевірки завантаження та розрахунків.

## 4. Запуск

1. Відкрити Pharo.
2. Завантажити пакет `SportsProject`.
3. Переконатися, що в папці `Documents/pharo-sports-project/data/` є файли CSV та JSON.
4. Відкрити Playground.
5. Виконати приклад:

```smalltalk
| persistence athletes |

persistence := SportsPersistence new.
athletes := persistence loadFromJSON.

athletes size
```

Очікуваний результат: `2`.

## 5. Перевірка CSV та JSON

```smalltalk
| persistence |

persistence := SportsPersistence new.

{
    persistence loadAthletesFromCSV size = 2.
    persistence loadFromJSON size = 2
}
```

Очікуваний результат: `#(true true)`.

## 6. Перевірка доходів

Після завантаження JSON перевірено метод `earnings`:

- TennisPlayer (Svitolina): 60000.
- FootballPlayer (Mudryk): 3300000.

Після завантаження CSV отримано ті самі значення.

## 7. Результати

Успішно перевірено збереження та завантаження CSV і JSON, відновлення полів спортсменів, роботу колекції в пам'яті та обчислення доходів після завантаження.

Результати демонстрацій збережено у файлі `data/test_results.txt`.