TestCase subclass: #SportsClubOutputTest
    instanceVariableNames: 'club football tennis'
    classVariableNames: ''
    package: 'SportsProject-Tests'!

!SportsClubOutputTest methodsFor: 'running'!
setUp
    super setUp.
    club := SportsClub new.
    football := FootballPlayer new
        surname: 'Dovbyk'; age: 27; citizenship: 'Ukraine';
        club: 'Roma'; annualContract: 1000000; goals: 10; yourself.
    tennis := TennisPlayer new
        surname: 'Svitolina'; age: 30; citizenship: 'Ukraine';
        worldRanking: 20; lastTournamentPrizes: #(10000 20000 30000); yourself.
    club addSportsperson: football.
    club addSportsperson: tennis.! !

!SportsClubOutputTest methodsFor: 'tests'!
testPrintAllAthletes
    | output |
    output := club printAllAthletes.
    self assert: (output includesSubstring: 'Dovbyk').
    self assert: (output includesSubstring: 'Svitolina').! !

!SportsClubOutputTest methodsFor: 'tests'!
testPrintByCategory
    | output |
    output := club printAthletesOfClass: FootballPlayer.
    self assert: (output includesSubstring: 'Dovbyk').
    self deny: (output includesSubstring: 'Svitolina').! !

!SportsClubOutputTest methodsFor: 'tests'!
testStatistics
    | output |
    output := club statisticsString.
    self assert: (output includesSubstring: 'Athletes: 2').
    self assert: (output includesSubstring: 'Highest earner: Dovbyk').! !

!SportsClubOutputTest methodsFor: 'tests'!
testEmptyClub
    | emptyClub |
    emptyClub := SportsClub new.
    self assert: emptyClub printAllAthletes equals: 'No athletes found.'.
    self assert: emptyClub statisticsString equals: 'Athletes: 0'.! !
