TestCase subclass: #SportspersonFactoryTest
    instanceVariableNames: ''
    classVariableNames: ''
    package: 'SportsProject-Tests'!

!SportspersonFactoryTest methodsFor: 'tests'!
testCreateFootballPlayer
    | data player |
    data := Dictionary newFrom: {
        #surname -> 'Dovbyk'. #age -> 27. #citizenship -> 'Ukraine'.
        #club -> 'Roma'. #annualContract -> 1000000. #goals -> 12 }.
    player := SportspersonFactory createType: #football from: data.
    self assert: (player isKindOf: FootballPlayer).
    self assert: player surname equals: 'Dovbyk'.
    self assert: player earnings equals: 1120000.! !

!SportspersonFactoryTest methodsFor: 'tests'!
testCreateTennisPlayer
    | data player |
    data := Dictionary newFrom: {
        #surname -> 'Svitolina'. #age -> 30. #citizenship -> 'Ukraine'.
        #worldRanking -> 20. #lastTournamentPrizes -> #(10000 20000 30000) }.
    player := SportspersonFactory createType: #tennis from: data.
    self assert: (player isKindOf: TennisPlayer).
    self assert: player earnings equals: 60000.! !

!SportspersonFactoryTest methodsFor: 'tests'!
testRejectInvalidAge
    | data |
    data := Dictionary newFrom: {
        #surname -> 'Example'. #age -> 0. #citizenship -> 'Ukraine'.
        #club -> 'Test'. #annualContract -> 1000. #goals -> 1 }.
    self should: [ SportspersonFactory createType: #football from: data ] raise: Error.! !

!SportspersonFactoryTest methodsFor: 'tests'!
testRejectMissingFootballField
    | data |
    data := Dictionary newFrom: {
        #surname -> 'Example'. #age -> 20. #citizenship -> 'Ukraine'.
        #annualContract -> 1000. #goals -> 1 }.
    self should: [ SportspersonFactory createType: #football from: data ] raise: Error.! !
