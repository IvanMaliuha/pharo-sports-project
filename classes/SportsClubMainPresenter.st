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


