'From Pharo11.0.0 of 20 October 2025 [Build information: Pharo-11.0.0+build.750.sha.963dc3a7de9ee8e5543f6e62d25a2a283f7dcd48 (64 Bit)] on 10 November 2026 at 4:16:43.167106 pm'!
SpPresenter subclass: #SportsClubFilePresenter
	instanceVariableNames: 'club persistence database reportPersistence saveJSONButton loadJSONButton saveTXTButton loadTXTButton saveReportButton loadReportButton saveSQLiteButton loadSQLiteButton currentClubId'
	classVariableNames: ''
	package: 'SportsProject'!

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

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:43'!
loadTXT
    | file |

    file := UIManager default
        chooseExistingFileReference: 'Open Sports Club TXT'
        extensions: #('txt')
        path: FileSystem disk workingDirectory.

    file ifNil: [ ^ self ].

    club := persistence
        loadClubFromTXT: file fullName.

    UIManager default inform: 'TXT loaded successfully!!'
! !

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:55'!
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

    UIManager default inform:
        'Club loaded: ', club name,
        ' (Athletes: ', club sportsmen size asString, ')'
! !

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

!SportsClubFilePresenter methodsFor: 'as yet unclassified' stamp: 'YarynaHrynko 11/10/2026 15:33'!
loadJSON
    | file |

    file := UIManager default
        chooseExistingFileReference: 'Open Sports Club JSON'
        extensions: #('json')
        path: FileSystem disk workingDirectory.

    file ifNil: [ ^ self ].

    club := persistence
        loadClubFromJSON: file fullName.

    UIManager default inform: 'Club loaded successfully!!'
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


!SportsClubFilePresenter methodsFor: 'accessing' stamp: 'YarynaHrynko 11/10/2026 15:35'!
club
    ^ club
! !

!SportsClubFilePresenter methodsFor: 'accessing' stamp: 'YarynaHrynko 11/10/2026 16:05'!
databasePath: aPath
    database databasePath: aPath
! !
