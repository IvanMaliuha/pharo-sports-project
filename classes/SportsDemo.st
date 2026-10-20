'From Pharo11.0.0 of 10 March 2025 [Build information: Pharo-11.0.0+build.742.sha.88cf2b274465e1f48f1351cc4922ebe4b850f67f (64 Bit)] on 20 October 2026 at 11:59:44.274 pm'!Object subclass: #SportsDemo	instanceVariableNames: 'sportsmen'	classVariableNames: ''	package: 'SportsProject'!!SportsDemo methodsFor: 'accessing'!sportsmen
    ^ sportsmen copy! !!SportsDemo methodsFor: 'initialization'!createDefaultSportsmen
    | shevchenko mudryk haaland svitolina alcaraz |
    shevchenko := FootballPlayer new
        surname: 'Shevchenko'; age: 47; citizenship: 'Ukraine';
        club: 'Milan'; annualContract: 5000000; goals: 25; yourself.
    mudryk := FootballPlayer new
        surname: 'Mudryk'; age: 23; citizenship: 'Ukraine';
        club: 'Chelsea'; annualContract: 3500000; goals: 10; yourself.
    haaland := FootballPlayer new
        surname: 'Haaland'; age: 24; citizenship: 'Norway';
        club: 'Manchester City'; annualContract: 20000000; goals: 40; yourself.
    svitolina := TennisPlayer new
        surname: 'Svitolina'; age: 29; citizenship: 'Ukraine';
        worldRanking: 17; lastTournamentPrizes: #(350000 450000 400000); yourself.
    alcaraz := TennisPlayer new
        surname: 'Alcaraz'; age: 21; citizenship: 'Spain';
        worldRanking: 2; lastTournamentPrizes: #(2500000 3000000 4000000); yourself.
    sportsmen addAll: { shevchenko. mudryk. haaland. svitolina. alcaraz }! !!SportsDemo methodsFor: 'initialization'!initialize
    super initialize.
    sportsmen := OrderedCollection new.
    self createDefaultSportsmen! !!SportsDemo methodsFor: 'displaying'!displayAll
    | result |
    result := String streamContents: [ :stream |
        sportsmen do: [ :each | stream nextPutAll: each printString; cr ] ].
    Transcript show: '=== ALL SPORTSPERSONS ==='; cr; show: result; cr.
    UIManager default inform: result! !!SportsDemo methodsFor: 'dialogs'!addNewSportspersonDialog
    | choice |
    choice := UIManager default chooseFrom: #('Enter manually' 'Import from file') title: 'Add sportsperson'.
    choice = 1 ifTrue: [ ^ self inputSportspersonFromKeyboard ].
    choice = 2 ifTrue: [ ^ self importSportsmenFromFile ].
    ^ nil! !!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:50'!increaseAgeForAll    sportsmen do: [ :athlete |        athlete increaseAge ].    Transcript        show: 'Age increased for all sportspeople.';        cr.    ^ sportsmen! !!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:47'!richestSportspersonAndCheckFootball    | richest |    sportsmen isEmpty ifTrue: [ ^ nil ].    richest := sportsmen first.    sportsmen do: [ :athlete |        athlete earnings > richest earnings            ifTrue: [ richest := athlete ] ].    Transcript        show: 'Richest sportsperson: ';        show: richest surname;        show: ', earnings: ';        show: richest earnings printString;        cr.    Transcript        show: 'Is football player: ';        show: (richest isKindOf: FootballPlayer) printString;        cr.    ^ richest! !!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:45'!runFullDemonstration    self displayAll.    self richestSportspersonAndCheckFootball.    self demonstrateArithmetic.    self increaseAgeForAll.    self ukrainianSportsmen.    ^ sportsmen! !!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:50'!ukrainianSportsmen    | ukrainian |    ukrainian := sportsmen select: [ :athlete |        athlete citizenship = 'Ukraine' ].    Transcript show: 'Ukrainian sportspeople:'; cr.    ukrainian do: [ :athlete |        Transcript show: athlete printString; cr ].    ^ ukrainian! !!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:48'!demonstrateArithmetic    | first second |    sportsmen size < 2 ifTrue: [ ^ self ].    first := sportsmen first earnings.    second := sportsmen second earnings.    Transcript        show: 'Sum: ';        show: (first + second) printString;        cr.    Transcript        show: 'Difference: ';        show: (first - second) printString;        cr.    Transcript        show: 'Product: ';        show: (first * second) printString;        cr.    second ~= 0        ifTrue: [            Transcript                show: 'Division: ';                show: (first / second) printString;                cr ].    ^ self! !