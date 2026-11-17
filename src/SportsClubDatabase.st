'From Pharo11.0.0 of 20 October 2025 [Build information: Pharo-11.0.0+build.750.sha.963dc3a7de9ee8e5543f6e62d25a2a283f7dcd48 (64 Bit)] on 10 November 2026 at 4:11:46.410119 pm'!
Object subclass: #SportsClubDatabase
	instanceVariableNames: 'databasePath'
	classVariableNames: ''
	package: 'SportsProject'!

!SportsClubDatabase methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 14:34'!
saveClub: aClub
    | connection clubId cursor |

    connection := self openConnection.

    [
        [
            connection execute: 'BEGIN TRANSACTION'.

            connection
                execute: 'INSERT INTO clubs (name) VALUES (?)'
                with: { aClub name }.

            cursor := connection execute:
                'SELECT last_insert_rowid() AS club_id'.

            clubId := (cursor next) at: 'club_id'.

            aClub sportsmen do: [ :athlete |
                connection
                    execute:
                        'INSERT INTO athletes (
                            club_id, type, surname, age, citizenship,
                            football_club, annual_contract, goals,
                            world_ranking, tournament_prizes
                        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
                    with: {
                        clubId.
                        athlete class name asString.
                        athlete surname.
                        athlete age.
                        athlete citizenship.
                        (athlete isKindOf: FootballPlayer)
                            ifTrue: [ athlete club ]
                            ifFalse: [ nil ].
                        (athlete isKindOf: FootballPlayer)
                            ifTrue: [ athlete annualContract ]
                            ifFalse: [ nil ].
                        (athlete isKindOf: FootballPlayer)
                            ifTrue: [ athlete goals ]
                            ifFalse: [ nil ].
                        (athlete isKindOf: TennisPlayer)
                            ifTrue: [ athlete worldRanking ]
                            ifFalse: [ nil ].
                        (athlete isKindOf: TennisPlayer)
                            ifTrue: [ athlete lastTournamentPrizes ]
                            ifFalse: [ nil ]
                    }
            ].

            connection execute: 'COMMIT'

        ] on: Error do: [ :error |
            connection execute: 'ROLLBACK'.
            error pass
        ]

    ] ensure: [
        connection close
    ].

    ^ clubId
! !

!SportsClubDatabase methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 14:40'!
loadClub: aClubId
    | connection clubCursor athleteCursor row club athleteRow |

    connection := self openConnection.

    [
        clubCursor := connection
            execute: 'SELECT name FROM clubs WHERE id = ?'
            with: { aClubId }.

        row := clubCursor next.

        row ifNil: [
            self error: 'Club not found'
        ].

        club := SportsClub new.
        club name: (row at: 'name').

        athleteCursor := connection
            execute: 'SELECT * FROM athletes WHERE club_id = ?'
            with: { aClubId }.

        athleteRow := athleteCursor next.

        [ athleteRow notNil ] whileTrue: [
            club addSportsperson:
                (self rowToSportsperson: athleteRow).

            athleteRow := athleteCursor next
        ]

    ] ensure: [
        connection close
    ].

    ^ club
! !

!SportsClubDatabase methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 14:45'!
createTables
    | connection |

    connection := self openConnection.

    [
        connection execute:
            'CREATE TABLE IF NOT EXISTS clubs (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL
            )'.

        connection execute:
            'CREATE TABLE IF NOT EXISTS athletes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                club_id INTEGER NOT NULL,
                type TEXT NOT NULL,
                surname TEXT NOT NULL,
                age INTEGER,
                citizenship TEXT,
                football_club TEXT,
                annual_contract INTEGER,
                goals INTEGER,
                world_ranking INTEGER,
                tournament_prizes INTEGER,
                FOREIGN KEY (club_id) REFERENCES clubs(id)
            )'

    ] ensure: [
        connection close
    ]
! !

!SportsClubDatabase methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 14:38'!
rowToSportsperson: aRow
    | athlete type |

    type := aRow at: 'type'.

    type = 'FootballPlayer'
        ifTrue: [
            athlete := FootballPlayer new.

            athlete club: (aRow at: 'football_club').
            athlete annualContract: (aRow at: 'annual_contract').
            athlete goals: (aRow at: 'goals')
        ]
        ifFalse: [
            type = 'TennisPlayer'
                ifTrue: [
                    athlete := TennisPlayer new.

                    athlete worldRanking: (aRow at: 'world_ranking').
                    athlete lastTournamentPrizes:
                        (aRow at: 'tournament_prizes')
                ]
                ifFalse: [
                    self error: 'Unknown sportsperson type'
                ]
        ].

    athlete surname: (aRow at: 'surname').
    athlete age: (aRow at: 'age').
    athlete citizenship: (aRow at: 'citizenship').

    ^ athlete
! !

!SportsClubDatabase methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 16:01'!
openConnection
    | fileName |

    fileName := databasePath
        ifNil: [
            (FileSystem disk workingDirectory
                / 'sportsclub.db') fullName
        ].

    ^ SQLite3Connection openOn: fileName
! !


!SportsClubDatabase methodsFor: 'accessing' stamp: 'YarynaHrynko 11/10/2026 14:43'!
databasePath: aPath
    databasePath := aPath! !
