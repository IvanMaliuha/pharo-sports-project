'From Pharo11.0.0 of 20 October 2025 [Build information: Pharo-11.0.0+build.750.sha.963dc3a7de9ee8e5543f6e62d25a2a283f7dcd48 (64 Bit)] on 10 November 2026 at 1:38:47.335025 pm'!
Object subclass: #SportsClubPersistence
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'SportsProject'!

!SportsClubPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 12:52'!
clubToDictionary: aClub
    | data athletes |

    data := Dictionary new.
    athletes := OrderedCollection new.

    aClub sportsmen do: [ :each |
    athletes add: (self sportspersonToDictionary: each)
].

    data at: 'name' put: aClub name.
    data at: 'sportsmen' put: athletes.

    ^ data! !

!SportsClubPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 13:02'!
dictionaryToSportsperson: data
    | athlete type |

    type := data at: 'type'.

    type = 'FootballPlayer'
        ifTrue: [ athlete := FootballPlayer new ]
        ifFalse: [
            type = 'TennisPlayer'
                ifTrue: [ athlete := TennisPlayer new ]
                ifFalse: [ self error: 'Unknown athlete type' ]
        ].

    athlete surname: (data at: 'surname').
    athlete age: (data at: 'age').
    athlete citizenship: (data at: 'citizenship').

    type = 'FootballPlayer' ifTrue: [
        athlete club: (data at: 'club').
        athlete annualContract: (data at: 'annualContract').
        athlete goals: (data at: 'goals')
    ].

    type = 'TennisPlayer' ifTrue: [
        athlete worldRanking: (data at: 'worldRanking').
        athlete lastTournamentPrizes: (data at: 'lastTournamentPrizes')
    ].

    ^ athlete! !

!SportsClubPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 12:59'!
saveClubToJSON: aClub filename: aFilename
    | data json file |

    data := self clubToDictionary: aClub.
    json := NeoJSONWriter toString: data.
    file := aFilename asFileReference.

    file writeStreamDo: [ :stream |
        stream nextPutAll: json
    ].

    ^ file! !

!SportsClubPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 13:06'!
loadClubFromJSON: aFilename
    | file json data |

    file := aFilename asFileReference.

    file exists ifFalse: [
        self error: 'JSON file does not exist'
    ].

    json := file contents.
    data := NeoJSONReader fromString: json.

    ^ self dictionaryToClub: data! !

!SportsClubPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 13:04'!
dictionaryToClub: data
    | club athletes |

    club := SportsClub new.
    club name: (data at: 'name').

    athletes := data at: 'sportsmen'.

    athletes do: [ :each |
        club addSportsperson:
            (self dictionaryToSportsperson: each)
    ].

    ^ club! !

!SportsClubPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 12:50'!
sportspersonToDictionary: anAthlete
    | data |

    data := Dictionary new.

    data at: 'type' put: anAthlete class name asString.
    data at: 'surname' put: anAthlete surname.
    data at: 'age' put: anAthlete age.
    data at: 'citizenship' put: anAthlete citizenship.

    (anAthlete isKindOf: FootballPlayer) ifTrue: [
        data at: 'club' put: anAthlete club.
        data at: 'annualContract' put: anAthlete annualContract.
        data at: 'goals' put: anAthlete goals
    ].

    (anAthlete isKindOf: TennisPlayer) ifTrue: [
        data at: 'worldRanking' put: anAthlete worldRanking.
        data at: 'lastTournamentPrizes' put: anAthlete lastTournamentPrizes
    ].

    ^ data! !
