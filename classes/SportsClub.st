'From Pharo11.0.0 of 10 March 2025'!
Object subclass: #SportsClub
    instanceVariableNames: 'name sportsmen'
    classVariableNames: ''
    package: 'SportsProject'!

!SportsClub methodsFor: 'initialization'!
initialize
    super initialize.
    name := 'Sports Club'.
    sportsmen := OrderedCollection new! !

!SportsClub methodsFor: 'accessing'!
name
    ^ name! !

!SportsClub methodsFor: 'accessing'!
name: aString
    name := aString! !

!SportsClub methodsFor: 'accessing'!
sportsmen
    ^ sportsmen copy! !

!SportsClub methodsFor: 'adding/removing'!
addSportsperson: aSportsperson
    (aSportsperson isKindOf: Sportsperson)
        ifFalse: [ self error: 'Only Sportsperson instances can be added' ].
    sportsmen add: aSportsperson.
    ^ aSportsperson! !

!SportsClub methodsFor: 'adding/removing'!
removeSportsperson: aSportsperson
    ^ sportsmen remove: aSportsperson ifAbsent: [ nil ]! !

!SportsClub methodsFor: 'printing'!
printAllAthletes
    ^ self printAthletes: sportsmen! !

!SportsClub methodsFor: 'printing'!
printAthletesOfClass: aSportspersonClass
    | selected |
    selected := sportsmen select: [ :each | each isKindOf: aSportspersonClass ].
    ^ self printAthletes: selected! !

!SportsClub methodsFor: 'printing'!
printAthletes: aCollection
    ^ String streamContents: [ :stream |
        aCollection isEmpty
            ifTrue: [ stream nextPutAll: 'No athletes found.' ]
            ifFalse: [
                aCollection do: [ :each |
                    stream nextPutAll: each printString; cr ] ] ]! !

!SportsClub methodsFor: 'printing'!
displayAllAthletes
    | output |
    output := self printAllAthletes.
    Transcript show: output; cr.
    UIManager default inform: output.
    ^ output! !

!SportsClub methodsFor: 'printing'!
displayAthletesOfClass: aSportspersonClass
    | output |
    output := self printAthletesOfClass: aSportspersonClass.
    Transcript show: output; cr.
    UIManager default inform: output.
    ^ output! !

!SportsClub methodsFor: 'statistics'!
statisticsString
    | total average richest totalEarnings |
    total := sportsmen size.
    total = 0 ifTrue: [ ^ 'Athletes: 0' ].
    totalEarnings := sportsmen inject: 0 into: [ :sum :each | sum + each earnings ].
    average := totalEarnings / total.
    richest := sportsmen first.
    sportsmen do: [ :each | each earnings > richest earnings ifTrue: [ richest := each ] ].
    ^ String streamContents: [ :stream |
        stream
            nextPutAll: 'Athletes: '; print: total; cr;
            nextPutAll: 'Total earnings: '; print: totalEarnings; cr;
            nextPutAll: 'Average earnings: '; print: average; cr;
            nextPutAll: 'Highest earner: '; nextPutAll: richest surname;
            nextPutAll: ' ('; print: richest earnings; nextPutAll: ')' ]! !

!SportsClub methodsFor: 'statistics'!
printReportIncludingStatistics
    ^ self printAllAthletes , String cr , self statisticsString! !

!SportsClub methodsFor: 'dialogs'!
addSportspersonDialog
    | dialog athlete |
    dialog := SportspersonDialog new.
    dialog open.
    athlete := dialog createdSportsperson.
    athlete ifNotNil: [ self addSportsperson: athlete ].
    ^ athlete! !
