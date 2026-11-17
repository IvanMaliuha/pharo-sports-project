'From Pharo11.0.0 of 20 October 2025 [Build information: Pharo-11.0.0+build.750.sha.963dc3a7de9ee8e5543f6e62d25a2a283f7dcd48 (64 Bit)] on 10 November 2026 at 4:18:17.333582 pm'!
TestCase subclass: #SportsClubDatabaseTest
	instanceVariableNames: 'database testDatabasePath'
	classVariableNames: ''
	package: 'SportsProject-Tests'!

!SportsClubDatabaseTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 14:55'!
testLoadUnknownAthleteType
    | connection clubId |

    connection := database openConnection.

    [
        connection
            execute: 'INSERT INTO clubs (name) VALUES (?)'
            with: { 'Invalid Club' }.

        clubId := ((connection execute:
            'SELECT last_insert_rowid() AS club_id') next)
                at: 'club_id'.

        connection
            execute:
                'INSERT INTO athletes (
                    club_id, type, surname, age, citizenship
                ) VALUES (?, ?, ?, ?, ?)'
            with: {
                clubId.
                'UnknownPlayer'.
                'Test'.
                20.
                'Ukraine'
            }
    ] ensure: [
        connection close
    ].

    self
        should: [ database loadClub: clubId ]
        raise: Error
! !

!SportsClubDatabaseTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 14:51'!
testSaveAndLoadEmptyClub
    | club loadedClub clubId |

    club := SportsClub new.
    club name: 'Test Club'.

    clubId := database saveClub: club.
    loadedClub := database loadClub: clubId.

    self assert: loadedClub name equals: 'Test Club'.
    self assert: loadedClub sportsmen size equals: 0
! !

!SportsClubDatabaseTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 14:53'!
testSaveAndLoadClubWithAthletes
    | club football tennis clubId loadedClub
      loadedFootball loadedTennis |

    club := SportsClub new.
    club name: 'Sports Test Club'.

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

    clubId := database saveClub: club.
    loadedClub := database loadClub: clubId.

    self assert: loadedClub name equals: 'Sports Test Club'.
    self assert: loadedClub sportsmen size equals: 2.

    loadedFootball := loadedClub sportsmen
        detect: [ :each | each isKindOf: FootballPlayer ].

    loadedTennis := loadedClub sportsmen
        detect: [ :each | each isKindOf: TennisPlayer ].

    self assert: loadedFootball surname equals: 'Mudryk'.
    self assert: loadedFootball age equals: 25.
    self assert: loadedFootball citizenship equals: 'Ukraine'.
    self assert: loadedFootball club equals: 'Chelsea'.
    self assert: loadedFootball annualContract equals: 3000000.
    self assert: loadedFootball goals equals: 10.

    self assert: loadedTennis surname equals: 'Svitolina'.
    self assert: loadedTennis age equals: 32.
    self assert: loadedTennis citizenship equals: 'Ukraine'.
    self assert: loadedTennis worldRanking equals: 15.
    self assert: loadedTennis lastTournamentPrizes equals: 60000
! !

!SportsClubDatabaseTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 14:54'!
testLoadNonexistentClub
    self
        should: [ database loadClub: 999999 ]
        raise: Error
! !


!SportsClubDatabaseTest methodsFor: 'running' stamp: 'YarynaHrynko 11/10/2026 14:50'!
tearDown
    [
        testDatabasePath ifNotNil: [
            | file |
            file := testDatabasePath asFileReference.

            file exists ifTrue: [
                file delete
            ]
        ]
    ] ensure: [
        super tearDown
    ]
! !

!SportsClubDatabaseTest methodsFor: 'running' stamp: 'YarynaHrynko 11/10/2026 14:49'!
setUp
    super setUp.

    testDatabasePath := (FileSystem disk workingDirectory
        / ('sportsclub-test-', UUID new asString, '.db')) fullName.

    database := SportsClubDatabase new.
    database databasePath: testDatabasePath.
    database createTables
! !
