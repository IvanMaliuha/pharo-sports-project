'From Pharo11.0.0 of 10 March 2025'!
SpPresenter subclass: #SportspersonDialog
    instanceVariableNames: 'typeDropList surnameInput ageInput citizenshipInput footballFields tennisFields clubInput contractInput goalsInput rankingInput prizesInput result'
    classVariableNames: ''
    package: 'SportsProject'!


!SportspersonDialog methodsFor: 'initialization'!
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
    result := nil.! !

!SportspersonDialog methodsFor: 'initialization'!
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
        add: (self newButton label: 'Cancel'; action: [ self close ]; yourself);
        yourself.
    self layout: (SpBoxLayout newVertical
        add: (self newLabel label: 'Sportsperson type');
        add: typeDropList;
        add: commonLayout;
        add: footballFields;
        add: tennisFields;
        add: buttons;
        yourself).! !

!SportspersonDialog methodsFor: 'initialization'!
initializeWindow: aWindowPresenter
    aWindowPresenter title: 'Add a sportsperson'.! !

!SportspersonDialog methodsFor: 'accessing'!
createdSportsperson
    ^ result! !

!SportspersonDialog methodsFor: 'private'!
updateTypeFields
    | isFootball |
    isFootball := typeDropList selectedItem = 'Football player'.
    footballFields ifNotNil: [ footballFields visible: isFootball ].
    tennisFields ifNotNil: [ tennisFields visible: isFootball not ].! !

!SportspersonDialog methodsFor: 'private'!
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
        self close.
    ] on: Error do: [ :error | UIManager default inform: error messageText ].! !
