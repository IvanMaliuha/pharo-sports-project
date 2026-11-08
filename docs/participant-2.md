# Реалізація частини учасника 2

## Файли

- \`classes/SportsClub.st\` — клас клубу, колекція спортсменів, додавання/видалення, текстове виведення всіх спортсменів або за класом, статистика.
- \`classes/SportspersonFactory.st\` — створення \`FootballPlayer\` або \`TennisPlayer\` з даних та перевірка обов'язкових полів.
- \`classes/SportspersonDialog.st\` — форма Spec 2.0 для введення спільних і типоспецифічних полів.
- \`tests/SportsClubOutputTest.st\` — тести виведення та статистики.
- \`tests/SportspersonFactoryTest.st\` — тести створення об'єктів і валідації.

## Імпорт у Pharo

Імпортувати файли по черзі:
1. \`SportsClub.st\`
2. \`SportspersonFactory.st\`
3. \`SportspersonDialog.st\`
4. обидва файли тестів.

Перед імпортом мають бути завантажені наявні класи \`Sportsperson\`, \`FootballPlayer\` і \`TennisPlayer\`.

## Використання

\`\`\`smalltalk
club := SportsClub new.
club addSportsperson: (FootballPlayer new
    surname: 'Dovbyk'; age: 27; citizenship: 'Ukraine';
    club: 'Roma'; annualContract: 1000000; goals: 12; yourself).
club printAllAthletes.
club printAthletesOfClass: FootballPlayer.
club statisticsString.
\`\`\`

Відкрити форму додавання:

\`\`\`smalltalk
club addSportspersonDialog.
\`\`\`

Фабрика може створювати об'єкти без GUI:

\`\`\`smalltalk
SportspersonFactory createType: #football from: aDictionary.
SportspersonFactory createType: #tennis from: aDictionary.
\`\`\`

## Примітка щодо моделі

У вихідному архіві та гілці \`feature/club-core\` наявні типи \`Sportsperson\`, \`FootballPlayer\` і \`TennisPlayer\`. Класу \`Programmer\` у цих вихідних файлах немає, тому форма й фабрика реалізовані для двох наявних підкласів. Клас \`SportsClub\` додано в цій гілці, оскільки його вихідного файлу в отриманій версії гілки не було.
