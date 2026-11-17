'From Pharo11.0.0 of 10 March 2025'!
Object subclass: #SportspersonFactory
    instanceVariableNames: ''
    classVariableNames: ''
    package: 'SportsProject'!

!SportspersonFactory class methodsFor: 'creation'!
createFootballPlayerFrom: aDictionary
    | player |
    self validateCommonFieldsIn: aDictionary.
    self require: #club in: aDictionary.
    self require: #annualContract in: aDictionary.
    self require: #goals in: aDictionary.
    (aDictionary at: #annualContract) isNumber
        ifFalse: [ self error: 'Annual contract must be a number' ].
    ((aDictionary at: #goals) isInteger and: [ (aDictionary at: #goals) >= 0 ])
        ifFalse: [ self error: 'Goals must be a non-negative integer' ].
    player := FootballPlayer new
        surname: (aDictionary at: #surname);
        age: (aDictionary at: #age);
        citizenship: (aDictionary at: #citizenship);
        club: (aDictionary at: #club);
        annualContract: (aDictionary at: #annualContract);
        goals: (aDictionary at: #goals);
        yourself.
    ^ player! !

!SportspersonFactory class methodsFor: 'creation'!
createTennisPlayerFrom: aDictionary
    | player prizes |
    self validateCommonFieldsIn: aDictionary.
    self require: #worldRanking in: aDictionary.
    self require: #lastTournamentPrizes in: aDictionary.
    ((aDictionary at: #worldRanking) isInteger and: [ (aDictionary at: #worldRanking) > 0 ])
        ifFalse: [ self error: 'World ranking must be a positive integer' ].
    prizes := aDictionary at: #lastTournamentPrizes.
    ((prizes isCollection) and: [ prizes allSatisfy: [ :each | each isNumber and: [ each >= 0 ] ] ])
        ifFalse: [ self error: 'Tournament prizes must be a collection of non-negative numbers' ].
    player := TennisPlayer new
        surname: (aDictionary at: #surname);
        age: (aDictionary at: #age);
        citizenship: (aDictionary at: #citizenship);
        worldRanking: (aDictionary at: #worldRanking);
        lastTournamentPrizes: prizes asArray;
        yourself.
    ^ player! !

!SportspersonFactory class methodsFor: 'creation'!
createType: aSymbol from: aDictionary
    aSymbol = #football ifTrue: [ ^ self createFootballPlayerFrom: aDictionary ].
    aSymbol = #tennis ifTrue: [ ^ self createTennisPlayerFrom: aDictionary ].
    self error: 'Unsupported sportsperson type'! !

!SportspersonFactory class methodsFor: 'validation'!
validateCommonFieldsIn: aDictionary
    self require: #surname in: aDictionary.
    self require: #age in: aDictionary.
    self require: #citizenship in: aDictionary.
    ((aDictionary at: #surname) isString and: [ (aDictionary at: #surname) notEmpty ])
        ifFalse: [ self error: 'Surname must not be empty' ].
    ((aDictionary at: #citizenship) isString and: [ (aDictionary at: #citizenship) notEmpty ])
        ifFalse: [ self error: 'Citizenship must not be empty' ].
    ((aDictionary at: #age) isInteger and: [ (aDictionary at: #age) > 0 ])
        ifFalse: [ self error: 'Age must be a positive integer' ]! !

!SportspersonFactory class methodsFor: 'validation'!
require: aKey in: aDictionary
    (aDictionary includesKey: aKey)
        ifFalse: [ self error: 'Missing required field: ', aKey asString ].
    (aDictionary at: aKey) ifNil: [ self error: 'Missing required field: ', aKey asString ]! !
