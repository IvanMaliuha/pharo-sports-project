Object subclass: #SportsClub
	instanceVariableNames: 'name sportsmen'
	classVariableNames: ''
	package: 'SportsProject'!

!SportsClub methodsFor: 'statistics'!
printReportIncludingStatistics
    ^ self printAllAthletes , String cr , self statisticsString! !

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


!SportsClub methodsFor: 'dialogs' stamp: 'YarynaHrynko 11/18/2026 01:23'!
addSportspersonDialog
    | dialog athlete |
    dialog := SportspersonDialog new.
    dialog openModal.
    athlete := dialog createdSportsperson.
    athlete ifNotNil: [
        self addSportsperson: athlete
    ].
    ^ athlete! !


!SportsClub methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 03:15'!
highestPaidSportsperson
    sportsmen isEmpty ifTrue: [ ^ nil ].

    ^ sportsmen inject: sportsmen first into: [ :highest :each |
        each earnings > highest earnings
            ifTrue: [ each ]
            ifFalse: [ highest ]
    ]! !

!SportsClub methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 03:12'!
top100TennisPlayers
    ^ sportsmen select: [ :each |
        (each isKindOf: TennisPlayer)
            and: [
                each worldRanking notNil
                    and: [
                        each worldRanking between: 1 and: 100
                    ]
            ]
    ]! !

!SportsClub methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 03:09'!
topScorers
    | footballers maxGoals |

    footballers := sportsmen select: [ :each |
        each isKindOf: FootballPlayer
    ].

    footballers isEmpty ifTrue: [ ^ #() ].

    maxGoals := (footballers collect: [ :each |
        each goals
    ]) max.

    ^ footballers select: [ :each |
        each goals = maxGoals
    ]! !

!SportsClub methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 03:13'!
footballContracts
    | footballers |

    footballers := sportsmen select: [ :each |
        each isKindOf: FootballPlayer
    ].

    ^ footballers asSortedCollection: [ :a :b |
        a annualContract >= b annualContract
    ]! !

!SportsClub methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 03:11'!
top10TennisPlayers
    ^ sportsmen select: [ :each |
        (each isKindOf: TennisPlayer)
            and: [
                each worldRanking notNil
                    and: [
                        each worldRanking between: 1 and: 10
                    ]
            ]
    ]! !


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


!SportsClub methodsFor: 'printing' stamp: 'YarynaHrynko 11/18/2026 03:39'!
printAllAthletes
    ^ String streamContents: [ :stream |
        stream nextPutAll: 'Sports Club: '.
        stream nextPutAll: self name.
        stream cr; cr.
        stream nextPutAll: (self printAthletes: sportsmen)
    ]! !

!SportsClub methodsFor: 'printing'!
printAthletes: aCollection
    ^ String streamContents: [ :stream |
        aCollection isEmpty
            ifTrue: [ stream nextPutAll: 'No athletes found.' ]
            ifFalse: [
                aCollection do: [ :each |
                    stream nextPutAll: each printString; cr ] ] ]! !

!SportsClub methodsFor: 'printing'!
displayAthletesOfClass: aSportspersonClass
    | output |
    output := self printAthletesOfClass: aSportspersonClass.
    Transcript show: output; cr.
    UIManager default inform: output.
    ^ output! !

!SportsClub methodsFor: 'printing'!
displayAllAthletes
    | output |
    output := self printAllAthletes.
    Transcript show: output; cr.
    UIManager default inform: output.
    ^ output! !

!SportsClub methodsFor: 'printing'!
printAthletesOfClass: aSportspersonClass
    | selected |
    selected := sportsmen select: [ :each | each isKindOf: aSportspersonClass ].
    ^ self printAthletes: selected! !


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


SpPresenter subclass: #SportsClubFilePresenter
	instanceVariableNames: 'club persistence database reportPersistence saveJSONButton loadJSONButton saveTXTButton loadTXTButton saveReportButton loadReportButton saveSQLiteButton loadSQLiteButton currentClubId mainPresenter'
	classVariableNames: ''
	package: 'SportsProject'!

!SportsClubFilePresenter methodsFor: 'initialization' stamp: 'YarynaHrynko 11/10/2026 16:07'!
initializePresenters
    super initializePresenters.

    persistence := SportsClubPersistence new.
    database := SportsClubDatabase new.
    reportPersistence := SportsClubReportPersistence new.

    club := SportsClub new.
    club name: 'New Sports Club'.
    currentClubId := nil.

    saveJSONButton := self newButton.
    saveJSONButton label: 'Save JSON'.
    saveJSONButton action: [ self saveJSON ].

    loadJSONButton := self newButton.
    loadJSONButton label: 'Load JSON'.
    loadJSONButton action: [ self loadJSON ].

    saveTXTButton := self newButton.
    saveTXTButton label: 'Save TXT'.
    saveTXTButton action: [ self saveTXT ].

    loadTXTButton := self newButton.
    loadTXTButton label: 'Load TXT'.
    loadTXTButton action: [ self loadTXT ].

    saveReportButton := self newButton.
    saveReportButton label: 'Save Report'.
    saveReportButton action: [ self saveReport ].

    loadReportButton := self newButton.
    loadReportButton label: 'Load Report'.
    loadReportButton action: [ self loadReport ].

    saveSQLiteButton := self newButton.
    saveSQLiteButton label: 'Save SQLite'.
    saveSQLiteButton action: [ self saveSQLite ].

    loadSQLiteButton := self newButton.
    loadSQLiteButton label: 'Load SQLite'.
    loadSQLiteButton action: [ self loadSQLite ]
! !


!SportsClubFilePresenter methodsFor: 'layout' stamp: 'YarynaHrynko 11/10/2026 15:51'!
defaultLayout
    ^ SpBoxLayout newTopToBottom
        spacing: 10;
        add: saveJSONButton;
        add: loadJSONButton;
        add: saveTXTButton;
        add: loadTXTButton;
        add: saveReportButton;
        add: loadReportButton;
        add: saveSQLiteButton;
        add: loadSQLiteButton;
        yourself
! !


!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:47'!
loadReport
    | file report |

    file := UIManager default
        chooseExistingFileReference: 'Open Sports Club Report'
        extensions: #('txt')
        path: FileSystem disk workingDirectory.

    file ifNil: [ ^ self ].

    report := reportPersistence
        loadReportFromFile: file fullName.

    UIManager default inform: report
! !

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:52'!
saveSQLite
    | clubId |

    database createTables.

    clubId := database saveClub: club.

    currentClubId := clubId.

    UIManager default inform:
        'Club saved to SQLite!! ID: ', clubId asString
! !

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:28'!
saveJSON
    | file |

    file := UIManager default
        chooseForSaveFileReference: 'Save Sports Club JSON'
        extensions: #('json')
        path: FileSystem disk workingDirectory.

    file ifNil: [ ^ self ].

    persistence
        saveClubToJSON: club
        filename: file fullName.

    UIManager default inform: 'Club saved successfully!!'
! !

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 02:58'!
loadTXT
    | file |

    file := UIManager default
        chooseExistingFileReference: 'Open Sports Club TXT'
        extensions: #('txt')
        path: FileSystem disk workingDirectory.

    file ifNil: [ ^ self ].

    club := persistence loadClubFromTXT: file fullName.

    mainPresenter ifNotNil: [
        mainPresenter club: club
    ].

    UIManager default inform: 'TXT loaded successfully!!'.! !

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 03:02'!
loadSQLite
    | input clubId loadedClub |

    input := UIManager default
        request: 'Enter Club ID:'
        initialAnswer: '2'.

    input ifNil: [ ^ self ].

    input := input trimBoth.

    input isEmpty ifTrue: [ ^ self ].

    (input allSatisfy: [ :char | char isDigit ])
        ifFalse: [
            UIManager default inform: 'Please enter a valid numeric ID'.
            ^ self
        ].

    clubId := input asNumber.

    loadedClub := [
        database loadClub: clubId
    ] on: Error do: [ :error |
        UIManager default inform: 'Club not found or cannot be loaded'.
        ^ self
    ].

    club := loadedClub.
    currentClubId := clubId.

    mainPresenter ifNotNil: [
        mainPresenter club: club
    ].

    UIManager default inform:
        'Club loaded: ', club name,
        ' (Athletes: ', club sportsmen size asString, ')'.! !

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:45'!
saveReport
    | file report |

    file := UIManager default
        chooseForSaveFileReference: 'Save Sports Club Report'
        extensions: #('txt')
        path: FileSystem disk workingDirectory.

    file ifNil: [ ^ self ].

    report := String streamContents: [ :stream |
        stream nextPutAll: 'Sports Club Report'; cr.
        stream nextPutAll: 'Club: '; nextPutAll: club name; cr.
        stream nextPutAll: 'Total athletes: '.
        stream nextPutAll: club sportsmen size asString; cr.
        stream nextPutAll: 'Football players: '.
        stream nextPutAll:
            (club sportsmen count: [ :each |
                each isKindOf: FootballPlayer ]) asString; cr.
        stream nextPutAll: 'Tennis players: '.
        stream nextPutAll:
            (club sportsmen count: [ :each |
                each isKindOf: TennisPlayer ]) asString
    ].

    reportPersistence
        saveReport: report
        toFile: file fullName.

    UIManager default inform: 'Report saved successfully!!'
! !

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:37'!
saveTXT
    | file |

    file := UIManager default
        chooseForSaveFileReference: 'Save Sports Club TXT'
        extensions: #('txt')
        path: FileSystem disk workingDirectory.

    file ifNil: [ ^ self ].

    persistence
        saveClubToTXT: club
        filename: file fullName.

    UIManager default inform: 'TXT saved successfully!!'
! !

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 02:56'!
loadJSON
    | file |

    file := UIManager default
        chooseExistingFileReference: 'Open Sports Club JSON'
        extensions: #('json')
        path: FileSystem disk workingDirectory.

    file ifNil: [ ^ self ].

    club := persistence loadClubFromJSON: file fullName.

    mainPresenter ifNotNil: [
        mainPresenter club: club
    ].

    UIManager default inform: 'Club loaded successfully!!'.! !


!SportsClubFilePresenter methodsFor: 'accessing' stamp: 'YarynaHrynko 11/10/2026 15:35'!
club
    ^ club
! !

!SportsClubFilePresenter methodsFor: 'accessing' stamp: 'YarynaHrynko 11/18/2026 02:09'!
mainPresenter: aPresenter
    mainPresenter := aPresenter.! !

!SportsClubFilePresenter methodsFor: 'accessing' stamp: 'YarynaHrynko 11/10/2026 16:05'!
databasePath: aPath
    database databasePath: aPath
! !

!SportsClubFilePresenter methodsFor: 'accessing' stamp: 'YarynaHrynko 11/18/2026 01:56'!
club: aSportsClub
    club := aSportsClub.! !


SpPresenter subclass: #SportsClubMainPresenter
	instanceVariableNames: 'club athletesList addButton removeButton statisticsButton filesButton analysisButton'
	classVariableNames: ''
	package: 'SportsProject'!

!SportsClubMainPresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/18/2026 03:18'!
showAthleteAnalysis
    | report highest |

    highest := club highestPaidSportsperson.

    report := String streamContents: [ :stream |
        stream nextPutAll: 'ATHLETE ANALYSIS'; cr; cr.

        stream nextPutAll: 'Top scorers:'; cr.
        club topScorers do: [ :athlete |
            stream nextPutAll: athlete surname.
            stream nextPutAll: ' - '.
            stream nextPutAll: athlete goals asString; cr
        ].

        stream cr; nextPutAll: 'Top 10 tennis players:'; cr.
        club top10TennisPlayers do: [ :athlete |
            stream nextPutAll: athlete surname; cr
        ].

        stream cr; nextPutAll: 'Top 100 tennis players:'; cr.
        club top100TennisPlayers do: [ :athlete |
            stream nextPutAll: athlete surname; cr
        ].

        stream cr; nextPutAll: 'Football contracts:'; cr.
        club footballContracts do: [ :athlete |
            stream nextPutAll: athlete surname.
            stream nextPutAll: ' - '.
            stream nextPutAll: athlete annualContract asString; cr
        ].

        stream cr; nextPutAll: 'Highest paid sportsperson:'; cr.
        highest
            ifNil: [ stream nextPutAll: 'No athletes' ]
            ifNotNil: [
                stream nextPutAll: highest surname.
                stream nextPutAll: ' - '.
                stream nextPutAll: highest earnings asString
            ]
    ].

    UIManager default inform: report.! !


!SportsClubMainPresenter methodsFor: 'accessing' stamp: 'YarynaHrynko 11/18/2026 02:05'!
club: aSportsClub
    club := aSportsClub.
    athletesList items: club sportsmen.! !


!SportsClubMainPresenter methodsFor: 'initialization' stamp: 'YarynaHrynko 11/18/2026 03:45'!
initializePresenters
    athletesList := self newTable.

    athletesList
        addColumn: (SpStringTableColumn
            title: 'Surname'
            evaluated: [ :athlete | athlete surname ]);

        addColumn: (SpStringTableColumn
            title: 'Sport'
            evaluated: [ :athlete |
                (athlete isKindOf: FootballPlayer)
                    ifTrue: [ 'Football' ]
                    ifFalse: [ 'Tennis' ] ]);

        addColumn: (SpStringTableColumn
            title: 'Age'
            evaluated: [ :athlete | athlete age asString ]);

        addColumn: (SpStringTableColumn
            title: 'Citizenship'
            evaluated: [ :athlete | athlete citizenship ]);

        addColumn: (SpStringTableColumn
            title: 'Club / Ranking'
            evaluated: [ :athlete |
                (athlete isKindOf: FootballPlayer)
                    ifTrue: [ athlete club ]
                    ifFalse: [ athlete worldRanking asString ] ]);

        addColumn: (SpStringTableColumn
            title: 'Contract / Prizes'
            evaluated: [ :athlete |
                (athlete isKindOf: FootballPlayer)
                    ifTrue: [ athlete annualContract asString ]
                    ifFalse: [ athlete lastTournamentPrizes printString ] ]);

        addColumn: (SpStringTableColumn
            title: 'Earnings'
            evaluated: [ :athlete | athlete earnings asString ]).

    athletesList items: club sportsmen.

    addButton := self newButton.
    addButton label: 'Add sportsperson'.
    addButton action: [
        club addSportspersonDialog.
        athletesList items: club sportsmen
    ].

    removeButton := self newButton.
    removeButton label: 'Remove sportsperson'.
    removeButton action: [
        | selectedAthlete |
        selectedAthlete := athletesList selectedItem.
        selectedAthlete ifNotNil: [
            club removeSportsperson: selectedAthlete.
            athletesList items: club sportsmen
        ]
    ].

    statisticsButton := self newButton.
    statisticsButton label: 'Show statistics'.
    statisticsButton action: [
        UIManager default inform: club statisticsString
    ].

    filesButton := self newButton.
    filesButton label: 'Files'.
    filesButton action: [
        | filePresenter |
        filePresenter := SportsClubFilePresenter new.
        filePresenter club: club.
        filePresenter mainPresenter: self.
        filePresenter open
    ].

    analysisButton := self newButton.
    analysisButton label: 'Athlete analysis'.
    analysisButton action: [
        self showAthleteAnalysis
    ].

    self initializeLayout.! !

!SportsClubMainPresenter methodsFor: 'initialization' stamp: 'YarynaHrynko 11/18/2026 01:33'!
initialize
    club := SportsClub new.
    super initialize.! !

!SportsClubMainPresenter methodsFor: 'initialization' stamp: 'YarynaHrynko 11/18/2026 01:36'!
initializeWindow: aWindowPresenter
    aWindowPresenter title: 'Sports Club Management'.
    aWindowPresenter initialExtent: 800@600! !

!SportsClubMainPresenter methodsFor: 'initialization' stamp: 'YarynaHrynko 11/18/2026 03:19'!
initializeLayout
    self layout: (SpBoxLayout newTopToBottom
        spacing: 10;
        add: athletesList;
        add: addButton expand: false;
        add: removeButton expand: false;
        add: statisticsButton expand: false;
        add: analysisButton expand: false;
        add: filesButton expand: false;
        yourself).! !


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

!SportsClubPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 13:55'!
loadClubFromTXT: aFilename
    | file text data |

    file := aFilename asFileReference.

    file exists ifFalse: [
        self error: 'TXT file does not exist'
    ].

    text := file contents.
    data := STON fromString: text.

    ^ self dictionaryToClub: data! !

!SportsClubPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 13:54'!
saveClubToTXT: aClub filename: aFilename
    | data text file |

    data := self clubToDictionary: aClub.
    text := STON toString: data.
    file := aFilename asFileReference.

    file writeStreamDo: [ :stream |
        stream nextPutAll: text
    ].

    ^ file! !

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


Object subclass: #SportsClubReportPersistence
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'SportsProject'!

!SportsClubReportPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:02'!
loadReportFromFile: aFileName
    | file |

    file := aFileName asFileReference.

    file exists ifFalse: [
        self error: 'Report file not found'
    ].

    ^ file readStreamDo: [ :stream |
        stream upToEnd
    ]
! !

!SportsClubReportPersistence methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:00'!
saveReport: aReport toFile: aFileName
    | file normalizedText |

    file := aFileName asFileReference.

    normalizedText := aReport asString
        copyReplaceAll: String crlf with: String lf.

    normalizedText := normalizedText
        copyReplaceAll: String cr with: String lf.

    file writeStreamDo: [ :stream |
        stream nextPutAll: normalizedText
    ].

    ^ file
! !


Object subclass: #SportsDemo
	instanceVariableNames: 'sportsmen'
	classVariableNames: ''
	package: 'SportsProject'!

!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:48'!
demonstrateArithmetic
    | first second |
    sportsmen size < 2 ifTrue: [ ^ self ].

    first := sportsmen first earnings.
    second := sportsmen second earnings.

    Transcript
        show: 'Sum: ';
        show: (first + second) printString;
        cr.

    Transcript
        show: 'Difference: ';
        show: (first - second) printString;
        cr.

    Transcript
        show: 'Product: ';
        show: (first * second) printString;
        cr.

    second ~= 0
        ifTrue: [
            Transcript
                show: 'Division: ';
                show: (first / second) printString;
                cr ].
    ^ self! !

!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:45'!
runFullDemonstration
    self displayAll.
    self richestSportspersonAndCheckFootball.
    self demonstrateArithmetic.
    self increaseAgeForAll.
    self ukrainianSportsmen.
    ^ sportsmen! !

!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:47'!
richestSportspersonAndCheckFootball
    | richest |
    sportsmen isEmpty ifTrue: [ ^ nil ].
    richest := sportsmen first.
    sportsmen do: [ :athlete |
        athlete earnings > richest earnings
            ifTrue: [ richest := athlete ] ].
    Transcript
        show: 'Richest sportsperson: ';
        show: richest surname;
        show: ', earnings: ';
        show: richest earnings printString;
        cr.
    Transcript
        show: 'Is football player: ';
        show: (richest isKindOf: FootballPlayer) printString;
        cr.
    ^ richest! !

!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:50'!
ukrainianSportsmen
    | ukrainian |
    ukrainian := sportsmen select: [ :athlete |
        athlete citizenship = 'Ukraine' ].

    Transcript show: 'Ukrainian sportspeople:'; cr.
    ukrainian do: [ :athlete |
        Transcript show: athlete printString; cr ].

    ^ ukrainian! !

!SportsDemo methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/20/2026 23:50'!
increaseAgeForAll
    sportsmen do: [ :athlete |
        athlete increaseAge ].
    Transcript
        show: 'Age increased for all sportspeople.';
        cr.
    ^ sportsmen! !


!SportsDemo methodsFor: 'accessing'!
sportsmen
    ^ sportsmen copy! !


!SportsDemo methodsFor: 'initialization'!
initialize
    super initialize.
    sportsmen := OrderedCollection new.
    self createDefaultSportsmen! !

!SportsDemo methodsFor: 'initialization'!
createDefaultSportsmen
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
    sportsmen addAll: { shevchenko. mudryk. haaland. svitolina. alcaraz }! !


!SportsDemo methodsFor: 'dialogs'!
addNewSportspersonDialog
    | choice |
    choice := UIManager default chooseFrom: #('Enter manually' 'Import from file') title: 'Add sportsperson'.
    choice = 1 ifTrue: [ ^ self inputSportspersonFromKeyboard ].
    choice = 2 ifTrue: [ ^ self importSportsmenFromFile ].
    ^ nil! !


!SportsDemo methodsFor: 'displaying'!
displayAll
    | result |
    result := String streamContents: [ :stream |
        sportsmen do: [ :each | stream nextPutAll: each printString; cr ] ].
    Transcript show: '=== ALL SPORTSPERSONS ==='; cr; show: result; cr.
    UIManager default inform: result! !


!SportsDemo methodsFor: 'adding' stamp: 'YarynaHrynko 11/18/2026 03:25'!
addSportsperson: aSportsperson
    sportsmen add: aSportsperson.
    ^ aSportsperson! !


Object subclass: #SportsPersistence
	instanceVariableNames: 'database'
	classVariableNames: ''
	package: 'SportsProject'!

!SportsPersistence methodsFor: 'initialization' stamp: 'YarynaHrynko 10/20/2026 22:13'!
initialize
    super initialize.
    database := OrderedCollection new.! !


!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 22:12'!
loadFromJSON
    | file data athletes |

    file := self dataDirectory / 'sportspeople.json'.

    file exists ifFalse: [ ^ OrderedCollection new ].

    data := STONJSON fromString: file contents.
    athletes := OrderedCollection new.

    data do: [ :item |
        | athlete type |

        type := item at: 'type'.
        athlete := nil.

        type = 'TennisPlayer'
            ifTrue: [
                athlete := TennisPlayer new.
                athlete worldRanking: (item at: 'worldRanking').
                athlete lastTournamentPrizes:
                    (item at: 'lastTournamentPrizes') asOrderedCollection
            ]
            ifFalse: [
                type = 'FootballPlayer'
                    ifTrue: [
                        athlete := FootballPlayer new.
                        athlete club: (item at: 'club').
                        athlete annualContract: (item at: 'annualContract').
                        athlete goals: (item at: 'goals')
                    ]
            ].

        athlete ifNotNil: [
            athlete surname: (item at: 'surname').
            athlete age: (item at: 'age').
            athlete citizenship: (item at: 'citizenship').

            athletes add: athlete
        ]
    ].

    ^ athletes! !

!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 21:36'!
saveToCSV: athletes
    | file |

    file := self dataDirectory / 'sportspeople.csv'.

    file ensureDelete.
file writeStreamDo: [ :stream |
        stream nextPutAll:
            'type,surname,age,citizenship,worldRanking,lastTournamentPrizes,club,annualContract,goals'.
        stream cr.

        athletes do: [ :athlete |
            | fields |

            fields := OrderedCollection new.

            fields add: athlete class name asString.
            fields add: athlete surname.
            fields add: athlete age asString.
            fields add: athlete citizenship.

            (athlete isKindOf: TennisPlayer)
                ifTrue: [
                    fields add: athlete worldRanking asString.
                    fields add: (';' join:
    (athlete lastTournamentPrizes collect: [ :prize |
        prize asString
    ])).
                    fields addAll: #('' '' '') ]
                ifFalse: [
                    fields addAll: #('' '').
                    fields add: athlete club.
                    fields add: athlete annualContract asString.
                    fields add: athlete goals asString ].

            stream nextPutAll: (',' join: fields).
            stream cr
        ]
    ].! !

!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 21:13'!
dataDirectory
    | repository directory |
    repository := IceRepository registry detect: [ :each | each name = 'pharo-sports-project' ] ifNone: [ nil ].
    directory := repository
        ifNotNil: [ repository location / 'data' ]
        ifNil: [ FileLocator documents / 'pharo-sports-project' / 'data' ].
    directory ensureCreateDirectory.
    ^ directory! !

!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 21:31'!
loadAthletesFromCSV
    | lines athletes |

    lines := self loadFromCSV.
    athletes := OrderedCollection new.

    lines allButFirst do: [ :line |
        | fields athlete |

        fields := line splitOn: ','.

        fields first = 'TennisPlayer'
            ifTrue: [
                athlete := TennisPlayer new.
                athlete worldRanking: fields fifth asNumber.
                athlete lastTournamentPrizes:
    ((fields sixth splitOn: ';') collect: [ :prize |
        prize asNumber
    ]).
            ]
            ifFalse: [
                fields first = 'FootballPlayer'
                    ifTrue: [
                        athlete := FootballPlayer new.
                        athlete club: fields seventh.
                        athlete annualContract: fields eighth asNumber.
                        athlete goals: fields ninth asNumber
                    ]
                    ifFalse: [
                        self error: 'Unknown athlete type'
                    ]
            ].

        athlete surname: fields second.
        athlete age: fields third asNumber.
        athlete citizenship: fields fourth.

        athletes add: athlete
    ].

    ^ athletes! !

!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 21:24'!
loadFromCSV
    | file lines |

    file := self dataDirectory / 'sportspeople.csv'.

    file exists ifFalse: [
        self error: 'CSV file not found'
    ].

    lines := OrderedCollection new.

    file readStreamDo: [ :stream |
        [ stream atEnd ] whileFalse: [
            lines add: stream nextLine
        ]
    ].

    ^ lines! !

!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 22:16'!
addAthlete: anAthlete
    database add: anAthlete.
    ^ anAthlete! !

!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 22:10'!
saveToJSON: athletes
    | file data |

    file := self dataDirectory / 'sportspeople.json'.

    data := athletes collect: [ :athlete |
        (athlete isKindOf: TennisPlayer)
            ifTrue: [
                Dictionary new
                    at: 'type' put: 'TennisPlayer';
                    at: 'surname' put: athlete surname;
                    at: 'age' put: athlete age;
                    at: 'citizenship' put: athlete citizenship;
                    at: 'worldRanking' put: athlete worldRanking;
                    at: 'lastTournamentPrizes' put: athlete lastTournamentPrizes asArray;
                    yourself
            ]
            ifFalse: [
                Dictionary new
                    at: 'type' put: 'FootballPlayer';
                    at: 'surname' put: athlete surname;
                    at: 'age' put: athlete age;
                    at: 'citizenship' put: athlete citizenship;
                    at: 'club' put: athlete club;
                    at: 'annualContract' put: athlete annualContract;
                    at: 'goals' put: athlete goals;
                    yourself
            ]
    ].

    file parent ensureCreateDirectory.

    file writeStreamDo: [ :stream |
        stream nextPutAll: (STONJSON toString: data asArray)
    ].! !

!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 22:17'!
getAllAthletes
    ^ database copy! !

!SportsPersistence methodsFor: 'persistence' stamp: 'YarynaHrynko 10/20/2026 22:19'!
clearDatabase
    database removeAll.! !


TestCase subclass: #SportsPersistenceTest
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'SportsProject'!

!SportsPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 10/20/2026 22:46'!
testInMemoryDatabase
    | persistence athletes storedAthletes |

    persistence := SportsPersistence new.

    self assert: persistence getAllAthletes size equals: 0.

    athletes := persistence loadFromJSON.

    athletes do: [ :athlete |
        persistence addAthlete: athlete
    ].

    storedAthletes := persistence getAllAthletes.

    self assert: storedAthletes size equals: 2.
    self assert: storedAthletes first surname equals: 'Svitolina'.
    self assert: storedAthletes second surname equals: 'Mudryk'.

    persistence clearDatabase.

    self assert: persistence getAllAthletes size equals: 0.! !

!SportsPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 10/20/2026 22:45'!
testLoadFromJSON
    | persistence athletes tennis football |

    persistence := SportsPersistence new.
    athletes := persistence loadFromJSON.

    self assert: athletes size equals: 2.

    tennis := athletes detect: [ :each |
        each isKindOf: TennisPlayer
    ].

    football := athletes detect: [ :each |
        each isKindOf: FootballPlayer
    ].

    self assert: tennis surname equals: 'Svitolina'.
    self assert: tennis worldRanking equals: 15.
    self assert: tennis earnings equals: 60000.

    self assert: football surname equals: 'Mudryk'.
    self assert: football club equals: 'Chelsea'.
    self assert: football earnings equals: 3300000.! !

!SportsPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 10/20/2026 22:44'!
testLoadFromCSV
    | persistence athletes tennis football |

    persistence := SportsPersistence new.
    athletes := persistence loadAthletesFromCSV.

    self assert: athletes size equals: 2.

    tennis := athletes detect: [ :each |
        each isKindOf: TennisPlayer
    ].

    football := athletes detect: [ :each |
        each isKindOf: FootballPlayer
    ].

    self assert: tennis surname equals: 'Svitolina'.
    self assert: tennis worldRanking equals: 15.
    self assert: tennis earnings equals: 60000.

    self assert: football surname equals: 'Mudryk'.
    self assert: football club equals: 'Chelsea'.
    self assert: football earnings equals: 3300000.! !


Object subclass: #Sportsperson
	instanceVariableNames: 'surname age citizenship'
	classVariableNames: ''
	package: 'SportsProject'!
!Sportsperson commentStamp: 'IvanMaliuha 10/18/2026 19:53' prior: 0!
Abstract base class representing a sportsperson.
Stores surname, age and citizenship.
Subclasses define their own earnings calculation.!


!Sportsperson methodsFor: 'comparing' stamp: 'IvanMaliuha 10/18/2026 19:55'!
> anotherSportsperson
    ^ self earnings > anotherSportsperson earnings! !

!Sportsperson methodsFor: 'comparing' stamp: 'IvanMaliuha 10/18/2026 19:55'!
< anotherSportsperson
    ^ self earnings < anotherSportsperson earnings! !

!Sportsperson methodsFor: 'comparing' stamp: 'IvanMaliuha 10/18/2026 19:55'!
<= anotherSportsperson
    ^ self earnings <= anotherSportsperson earnings! !


!Sportsperson methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/18/2026 19:49'!
increaseAge
    age := age + 1! !

!Sportsperson methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/18/2026 19:54'!
earnings
    self subclassResponsibility! !


!Sportsperson methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 19:48'!
age: anInteger
    age := anInteger! !

!Sportsperson methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 19:50'!
citizenship: aString
    citizenship := aString! !

!Sportsperson methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 19:49'!
citizenship
    ^ citizenship! !

!Sportsperson methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 19:48'!
age
    ^ age! !

!Sportsperson methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 19:47'!
surname
    ^ surname! !

!Sportsperson methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 19:47'!
surname: aString
    surname := aString! !


!Sportsperson methodsFor: 'arithmetic' stamp: 'IvanMaliuha 10/18/2026 19:56'!
/ anotherSportsperson
    anotherSportsperson earnings = 0
        ifTrue: [ self error: 'Division by zero' ].
    ^ self earnings / anotherSportsperson earnings! !

!Sportsperson methodsFor: 'arithmetic' stamp: 'IvanMaliuha 10/18/2026 19:56'!
* anotherSportsperson
    ^ self earnings * anotherSportsperson earnings! !

!Sportsperson methodsFor: 'arithmetic' stamp: 'IvanMaliuha 10/18/2026 19:56'!
- anotherSportsperson
    ^ self earnings - anotherSportsperson earnings! !

!Sportsperson methodsFor: 'arithmetic' stamp: 'IvanMaliuha 10/18/2026 19:56'!
+ anotherSportsperson
    ^ self earnings + anotherSportsperson earnings! !


!Sportsperson methodsFor: 'printing' stamp: 'IvanMaliuha 10/18/2026 19:58'!
printOn: aStream
    aStream
        nextPutAll: self class name asString;
        nextPutAll: ' ';
        nextPutAll: surname;
        nextPutAll: ', age: ';
        print: age;
        nextPutAll: ', citizenship: ';
        print: citizenship;
        nextPutAll: ', earnings: ';
        print: self earnings! !


Sportsperson subclass: #FootballPlayer
	instanceVariableNames: 'club annualContract goals'
	classVariableNames: ''
	package: 'SportsProject'!

!FootballPlayer methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/18/2026 20:03'!
earnings
    ^ annualContract * (1 + (goals / 100))! !


!FootballPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:03'!
club: aString
    club := aString! !

!FootballPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:03'!
goals
    ^ goals! !

!FootballPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:03'!
goals: anInteger
    goals := anInteger! !

!FootballPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:02'!
club
    ^ club! !

!FootballPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:03'!
annualContract
    ^ annualContract! !

!FootballPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:03'!
annualContract: aNumber
    annualContract := aNumber! !


SpPresenter subclass: #SportspersonDialog
	instanceVariableNames: 'typeDropList surnameInput ageInput citizenshipInput footballFields tennisFields clubInput contractInput goalsInput rankingInput prizesInput result'
	classVariableNames: ''
	package: 'SportsProject'!

!SportspersonDialog methodsFor: 'initialization' stamp: 'YarynaHrynko 11/18/2026 01:17'!
initializeLayout
    | commonLayout footballLayout tennisLayout buttons |
    commonLayout := SpBoxLayout newVertical
        add: (self newLabel label: 'Surname'); add: surnameInput;
        add: (self newLabel label: 'Age'); add: ageInput;
        add: (self newLabel label: 'Citizenship'); add: citizenshipInput;
        yourself.
    footballLayout := SpBoxLayout newVertical
        add: (self newLabel label: 'Club'); add: clubInput;
        add: (self newLabel label: 'Annual contract'); add: contractInput;
        add: (self newLabel label: 'Goals'); add: goalsInput;
        yourself.
    tennisLayout := SpBoxLayout newVertical
        add: (self newLabel label: 'World ranking'); add: rankingInput;
        add: (self newLabel label: 'Prizes (3 values separated by commas)'); add: prizesInput;
        yourself.
    footballFields := self newPresenter.
    footballFields layout: footballLayout.
    tennisFields := self newPresenter.
    tennisFields layout: tennisLayout.
    buttons := SpBoxLayout newHorizontal
        add: (self newButton label: 'Create'; action: [ self createSportsperson ]; yourself);
        add: (self newButton label: 'Cancel'; action: [ self window close ]; yourself);
        yourself.
    self layout: (SpBoxLayout newVertical
        add: (self newLabel label: 'Sportsperson type');
        add: typeDropList;
        add: commonLayout;
        add: footballFields;
        add: tennisFields;
        add: buttons;
        yourself).! !

!SportspersonDialog methodsFor: 'initialization' stamp: 'YarynaHrynko 11/18/2026 00:49'!
initializePresenters
    super initializePresenters.
    typeDropList := self newDropList.
    typeDropList items: #('Football player' 'Tennis player').
    typeDropList selectIndex: 1.
    typeDropList whenSelectedItemChangedDo: [ :item | self updateTypeFields ].
    surnameInput := self newTextInput.
    ageInput := self newTextInput.
    citizenshipInput := self newTextInput.
    clubInput := self newTextInput.
    contractInput := self newTextInput.
    goalsInput := self newTextInput.
    rankingInput := self newTextInput.
    prizesInput := self newTextInput.
    result := nil.
	 self initializeLayout! !

!SportspersonDialog methodsFor: 'initialization' stamp: 'YarynaHrynko 11/18/2026 01:06'!
initializeWindow: aWindowPresenter
    aWindowPresenter title: 'Add a sportsperson'.
    aWindowPresenter initialExtent: 600@750! !


!SportspersonDialog methodsFor: 'accessing'!
createdSportsperson
    ^ result! !


!SportspersonDialog methodsFor: 'private' stamp: 'YarynaHrynko 11/18/2026 00:56'!
updateTypeFields
    | isFootball |

    isFootball := typeDropList selectedItem = 'Football player'.

    isFootball
        ifTrue: [
            footballFields show.
            tennisFields hide
        ]
        ifFalse: [
            footballFields hide.
            tennisFields show
        ].! !

!SportspersonDialog methodsFor: 'private' stamp: 'YarynaHrynko 11/18/2026 01:12'!
createSportsperson
    | data type prizes |
    [
        data := Dictionary new.
        data at: #surname put: surnameInput text asString.
        data at: #age put: ageInput text asString asNumber.
        data at: #citizenship put: citizenshipInput text asString.
        typeDropList selectedItem = 'Football player'
            ifTrue: [
                data at: #club put: clubInput text asString.
                data at: #annualContract put: contractInput text asString asNumber.
                data at: #goals put: goalsInput text asString asNumber.
                type := #football ]
            ifFalse: [
                data at: #worldRanking put: rankingInput text asString asNumber.
                prizes := (prizesInput text asString findTokens: ',') collect: [ :each | each asNumber ].
                data at: #lastTournamentPrizes put: prizes.
                type := #tennis ].
        result := SportspersonFactory createType: type from: data.
	 	  self window close.
    ] on: Error do: [ :error | UIManager default inform: error messageText ].! !


Object subclass: #SportspersonFactory
	instanceVariableNames: ''
	classVariableNames: ''
	package: 'SportsProject'!
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

SportspersonFactory class
	instanceVariableNames: ''!

!SportspersonFactory class methodsFor: 'validation'!
require: aKey in: aDictionary
    (aDictionary includesKey: aKey)
        ifFalse: [ self error: 'Missing required field: ', aKey asString ].
    (aDictionary at: aKey) ifNil: [ self error: 'Missing required field: ', aKey asString ]! !

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


!SportspersonFactory class methodsFor: 'creation'!
createType: aSymbol from: aDictionary
    aSymbol = #football ifTrue: [ ^ self createFootballPlayerFrom: aDictionary ].
    aSymbol = #tennis ifTrue: [ ^ self createTennisPlayerFrom: aDictionary ].
    self error: 'Unsupported sportsperson type'! !

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


Sportsperson subclass: #TennisPlayer
	instanceVariableNames: 'worldRanking lastTournamentPrizes'
	classVariableNames: ''
	package: 'SportsProject'!

!TennisPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:00'!
worldRanking
    ^ worldRanking! !

!TennisPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:00'!
worldRanking: anInteger
    worldRanking := anInteger! !

!TennisPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:00'!
lastTournamentPrizes
    ^ lastTournamentPrizes! !

!TennisPlayer methodsFor: 'accessing' stamp: 'IvanMaliuha 10/18/2026 20:01'!
lastTournamentPrizes: aCollection
    lastTournamentPrizes := aCollection! !


!TennisPlayer methodsFor: 'as yet unclassified' stamp: 'IvanMaliuha 10/18/2026 20:01'!
earnings
    ^ lastTournamentPrizes
        inject: 0
        into: [ :sum :prize | sum + prize ]! !
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

!SportsClubOutputTest methodsFor: 'tests'!
testPrintByCategory
    | output |
    output := club printAthletesOfClass: FootballPlayer.
    self assert: (output includesSubstring: 'Dovbyk').
    self deny: (output includesSubstring: 'Svitolina').! !

!SportsClubOutputTest methodsFor: 'tests'!
testPrintAllAthletes
    | output |
    output := club printAllAthletes.
    self assert: (output includesSubstring: 'Dovbyk').
    self assert: (output includesSubstring: 'Svitolina').! !


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


TestCase subclass: #SportsClubReportPersistenceTest
	instanceVariableNames: 'persistence testFilePath'
	classVariableNames: ''
	package: 'SportsProject-Tests'!

!SportsClubReportPersistenceTest methodsFor: 'running' stamp: 'YarynaHrynko 11/10/2026 15:04'!
tearDown
    [
        testFilePath ifNotNil: [
            | file |
            file := testFilePath asFileReference.

            file exists ifTrue: [
                file delete
            ]
        ]
    ] ensure: [
        super tearDown
    ]
! !

!SportsClubReportPersistenceTest methodsFor: 'running' stamp: 'YarynaHrynko 11/10/2026 15:04'!
setUp
    super setUp.

    persistence := SportsClubReportPersistence new.

    testFilePath := (FileSystem disk workingDirectory
        / ('sportsclub-report-', UUID new asString, '.txt')) fullName
! !


!SportsClubReportPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 15:05'!
testLoadMissingReport
    self
        should: [
            persistence loadReportFromFile: testFilePath
        ]
        raise: Error
! !

!SportsClubReportPersistenceTest methodsFor: 'tests' stamp: 'YarynaHrynko 11/10/2026 15:05'!
testSaveAndLoadReport
    | originalReport loadedReport |

    originalReport := 'Sports Club Report
Total athletes: 2
Football players: 1
Tennis players: 1'.

    persistence
        saveReport: originalReport
        toFile: testFilePath.

    loadedReport := persistence
        loadReportFromFile: testFilePath.

    self assert:
        (testFilePath asFileReference exists).

    self assert:
        (loadedReport copyReplaceAll: String cr with: String lf)
        equals:
        (originalReport copyReplaceAll: String cr with: String lf)
! !


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
testRejectMissingFootballField
    | data |
    data := Dictionary newFrom: {
        #surname -> 'Example'. #age -> 20. #citizenship -> 'Ukraine'.
        #annualContract -> 1000. #goals -> 1 }.
    self should: [ SportspersonFactory createType: #football from: data ] raise: Error.! !

!SportspersonFactoryTest methodsFor: 'tests'!
testRejectInvalidAge
    | data |
    data := Dictionary newFrom: {
        #surname -> 'Example'. #age -> 0. #citizenship -> 'Ukraine'.
        #club -> 'Test'. #annualContract -> 1000. #goals -> 1 }.
    self should: [ SportspersonFactory createType: #football from: data ] raise: Error.! !

!SportspersonFactoryTest methodsFor: 'tests'!
testCreateTennisPlayer
    | data player |
    data := Dictionary newFrom: {
        #surname -> 'Svitolina'. #age -> 30. #citizenship -> 'Ukraine'.
        #worldRanking -> 20. #lastTournamentPrizes -> #(10000 20000 30000) }.
    player := SportspersonFactory createType: #tennis from: data.
    self assert: (player isKindOf: TennisPlayer).
    self assert: player earnings equals: 60000.! !
