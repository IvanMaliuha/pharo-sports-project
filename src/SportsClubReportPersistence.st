'From Pharo11.0.0 of 20 October 2025 [Build information: Pharo-11.0.0+build.750.sha.963dc3a7de9ee8e5543f6e62d25a2a283f7dcd48 (64 Bit)] on 10 November 2026 at 4:15:14.740247 pm'!
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
