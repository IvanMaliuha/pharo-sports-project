'From Pharo11.0.0 of 20 October 2025 [Build information: Pharo-11.0.0+build.750.sha.963dc3a7de9ee8e5543f6e62d25a2a283f7dcd48 (64 Bit)] on 10 November 2026 at 2:00:49.134361 pm'!
TestCase subclass: #SportsClubPersistenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'SportsProject-Tests'!

!SportsClubPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 13:32'!
testJSONRoundTrip
    | club football tennis persistence loaded fileName |

    club := SportsClub new.
    club name: 'Test Sports Club'.

    football := FootballPlayer new.
    football surname: 'Mudryk'.
    football age: 25.
    football citizenship: 'Ukraine'.
    football club: 'Chelsea'.
    football annualContract: 3000000.
    football goals: 10.

    tennis := TennisPlayer new.
    tennis surname: 'Svitolina'.
    tennis age: 32.
    tennis citizenship: 'Ukraine'.
    tennis worldRanking: 15.
    tennis lastTournamentPrizes: 60000.

    club addSportsperson: football.
    club addSportsperson: tennis.

    persistence := SportsClubPersistence new.
    fileName := 'sportsclub-roundtrip-test.json'.

    [
        persistence saveClubToJSON: club filename: fileName.
        loaded := persistence loadClubFromJSON: fileName.

        self assert: loaded name equals: 'Test Sports Club'.
        self assert: loaded sportsmen size equals: 2.

        self assert: loaded sportsmen first class equals: FootballPlayer.
        self assert: loaded sportsmen first surname equals: 'Mudryk'.
        self assert: loaded sportsmen first goals equals: 10.
        self assert: loaded sportsmen first annualContract equals: 3000000.

        self assert: loaded sportsmen second class equals: TennisPlayer.
        self assert: loaded sportsmen second surname equals: 'Svitolina'.
        self assert: loaded sportsmen second worldRanking equals: 15.
        self assert: loaded sportsmen second lastTournamentPrizes equals: 60000.
    ] ensure: [
        fileName asFileReference deleteIfAbsent: [ ]
    ]! !

!SportsClubPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 13:58'!
testLoadMissingTXTFile
    | persistence fileName |

    persistence := SportsClubPersistence new.
    fileName := 'sportsclub-missing-test.txt'.

    self deny: fileName asFileReference exists.

    self
        should: [
            persistence loadClubFromTXT: fileName
        ]
        raise: Error! !

!SportsClubPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 13:57'!
testTXTRoundTrip
    | club football tennis persistence loaded fileName |

    club := SportsClub new.
    club name: 'TXT Test Club'.

    football := FootballPlayer new.
    football surname: 'Mudryk'.
    football age: 25.
    football citizenship: 'Ukraine'.
    football club: 'Chelsea'.
    football annualContract: 3000000.
    football goals: 10.

    tennis := TennisPlayer new.
    tennis surname: 'Svitolina'.
    tennis age: 32.
    tennis citizenship: 'Ukraine'.
    tennis worldRanking: 15.
    tennis lastTournamentPrizes: 60000.

    club addSportsperson: football.
    club addSportsperson: tennis.

    persistence := SportsClubPersistence new.
    fileName := 'sportsclub-txt-test.txt'.

    [
        persistence saveClubToTXT: club filename: fileName.
        loaded := persistence loadClubFromTXT: fileName.

        self assert: loaded name equals: 'TXT Test Club'.
        self assert: loaded sportsmen size equals: 2.

        self assert: loaded sportsmen first class equals: FootballPlayer.
        self assert: loaded sportsmen first surname equals: 'Mudryk'.
        self assert: loaded sportsmen first annualContract equals: 3000000.
        self assert: loaded sportsmen first goals equals: 10.

        self assert: loaded sportsmen second class equals: TennisPlayer.
        self assert: loaded sportsmen second surname equals: 'Svitolina'.
        self assert: loaded sportsmen second worldRanking equals: 15.
        self assert: loaded sportsmen second lastTournamentPrizes equals: 60000.
    ] ensure: [
        fileName asFileReference deleteIfAbsent: [ ]
    ]! !

!SportsClubPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 13:34'!
testLoadMissingFile
    | persistence fileName |

    persistence := SportsClubPersistence new.
    fileName := 'sportsclub-file-that-does-not-exist.json'.

    self deny: fileName asFileReference exists.

    self
        should: [
            persistence loadClubFromJSON: fileName
        ]
        raise: Error! !

!SportsClubPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 13:35'!
testLoadInvalidJSON
    | persistence fileName file |

    persistence := SportsClubPersistence new.
    fileName := 'sportsclub-invalid-test.json'.
    file := fileName asFileReference.

    [
        file writeStreamDo: [ :stream |
            stream nextPutAll: '{ invalid JSON }'
        ].

        self
            should: [
                persistence loadClubFromJSON: fileName
            ]
            raise: Error
    ] ensure: [
        file deleteIfAbsent: [ ]
    ]! !

!SportsClubPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 13:59'!
testLoadInvalidTXT
    | persistence fileName file |

    persistence := SportsClubPersistence new.
    fileName := 'sportsclub-invalid-test.txt'.
    file := fileName asFileReference.

    [
        file writeStreamDo: [ :stream |
            stream nextPutAll: '{ invalid STON }'
        ].

        self
            should: [
                persistence loadClubFromTXT: fileName
            ]
            raise: Error
    ] ensure: [
        file deleteIfAbsent: [ ]
    ]! !

!SportsClubPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 13:31'!
testEmptyClubRoundTrip
    | club loadedClub persistence fileName |

    club := SportsClub new.
    club name: 'Test Club'.

    persistence := SportsClubPersistence new.
    fileName := 'sportsclub-empty-test.json'.

    [
        persistence saveClubToJSON: club filename: fileName.
        loadedClub := persistence loadClubFromJSON: fileName.

        self assert: loadedClub name equals: 'Test Club'.
        self assert: loadedClub sportsmen size equals: 0.
    ] ensure: [
        fileName asFileReference deleteIfAbsent: [ ]
    ]! !
