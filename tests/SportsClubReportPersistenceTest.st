'From Pharo11.0.0 of 20 October 2025 [Build information: Pharo-11.0.0+build.750.sha.963dc3a7de9ee8e5543f6e62d25a2a283f7dcd48 (64 Bit)] on 10 November 2026 at 4:19:15.697207 pm'!
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
