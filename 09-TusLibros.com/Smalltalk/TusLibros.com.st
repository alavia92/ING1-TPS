!classDefinition: #TusLibrosTEST category: #'TusLibros.com'!
TestCase subclass: #TusLibrosTEST
	instanceVariableNames: 'aCart aCatalog anItem1 anItem2 anItem3 aValidCreditCard anExpiredCreditCard aSalesBook aMerchantProcessorBehaviour aCashier'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 03:52:14'!
XXtest11aCatalogDoesNotRegisterAnItemWithNonPositivePrice

	| aCatalog |
	
	aCatalog := Catalog new.
	
	self 
		should: [ aCatalog add: anItem1 with: -1 * peso]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Catalog canNotRegisterAnItemWithNonPositivePriceErrorDescription.
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 21:11:51'!
XXtest12aTicketRecordsBoughtItems

	| aTicket |
	
	self addItemsToCatalog.
	self addItemsToCart.
	
	aTicket := aCashier checkout: aCart with: aValidCreditCard .
	
	self assert: (aTicket includes: anItem1 ).
	self assert: (aTicket includes: anItem3 ).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 21:12:03'!
XXtest13aTicketDoesNotRecordsNotBoughtItems

	| aTicket |
	
	self addItemsToCatalog.
	
	aCart add: anItem1 .
	
	aTicket := aCashier checkout: aCart with: aValidCreditCard .
	
	self assert: (aTicket includes: anItem1 ).
	self deny: (aTicket includes: anItem2 ).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:51:17'!
addItemsToCart

	aCart add: anItem1.
	aCart add: anItem2.
	aCart add: anItem3.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:46:48'!
addItemsToCatalog

	aCatalog add: anItem1 with: 10 * peso.
	aCatalog add: anItem2 with: 5 * peso.
	aCatalog add: anItem3 with: 2.5 * peso.
	! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:04:54'!
debit: anAmount from: aCreditCard
	^aMerchantProcessorBehaviour value: anAmount value: aCreditCard .! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:01:51'!
setUp

	aCatalog _ Catalog new.
	
	aCart _ Cart with: aCatalog.
	
	anItem1 _ 'anItem1'.
	anItem2 _ 'anItem2'.
	anItem3 _ 'anItem3'.
	
	aSalesBook _ OrderedCollection new.
	
	aCashier _ Cashier with: self and: aSalesBook and: self.
		
	aValidCreditCard _ CreditCard withExpiration: (December, 2018).
	anExpiredCreditCard _ CreditCard withExpiration: (March, 2017).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/26/2017 23:37:03'!
test01whenACartIsCreatedIsEmpty
	
	self assert: aCart isEmpty.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:43:46'!
test02whenAnItemIsAddedToACartIsNotEmpty

	self addItemsToCatalog.
	self addItemsToCart.

	self deny: aCart isEmpty. ! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:43:27'!
test03canNotAddAnItemOutsideTheCatalogToACart

	self 
		should: [ self addItemsToCart. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cart canNotAddItemFromOtherStoreErrorDescription.
			self assert: aCart isEmpty.
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:53:06'!
test04aCartRecordsItemsAdded

	self addItemsToCatalog.
	self addItemsToCart .
	
	self deny: aCart isEmpty.
	self assert: (aCart includes: anItem1).
	self assert: (aCart includes: anItem3).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 20:42:12'!
test05aCartDoesNotRecordsNotAddedItems

	self addItemsToCatalog.
	aCart add: anItem1 .
	
	self deny: aCart isEmpty.
	self assert: (aCart includes: anItem1).
	self deny: (aCart includes: anItem2).! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 20:44:32'!
test06aCartRecordsQuantityOfItemsAdded

	self addItemsToCatalog.
	aCart add: anItem1 quantity: 3.

	self deny: aCart isEmpty.
	self assert: (aCart quantityOf: anItem1) = 3.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 21:15:25'!
test07canNotAddNonPositiveQuantityOfItemsToACart

	self addItemsToCatalog.
	
	self 
		should: [ aCart add: anItem1 quantity: -8. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cart canNotAddNonPositiveQuantityOfItemsErrorDescription.
			self assert: aCart isEmpty.
		].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 19:44:24'!
test08canNotCheckoutAnEmptyCart

	self addItemsToCatalog.
	
	self
		should: [aCashier checkout: aCart with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier canNotCheckoutAnEmptyCartErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 19:44:39'!
test09canNotCheckoutWithAnExpiredCreditCard

	self addItemsToCatalog.
	self addItemsToCart.
	
	self
		should: [ aCashier checkout: aCart with: anExpiredCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText	equals: Cashier canNotCheckoutWithAnExpiredCreditCardErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:11:59'!
test10aCashierCheckoutACartWithItemsAndReturnsTicketWithCorrectAmount
"renombrar"
	| aTicket debitedAmount debitedCard |
	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | debitedAmount := anAmount . debitedCard := aCreditCard .].
	
	aTicket _ aCashier checkout: aCart with: aValidCreditCard.
	
	self assert: aTicket total = (17.5 * peso).
	
	self assert: aSalesBook size = 1.
	self assert: aTicket total = aSalesBook first.
	
	self assert: aTicket total = debitedAmount .
	self assert: aValidCreditCard = debitedCard .! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:59:22'!
test11aCashierCanNotCheckoutACartWithItemsUsingStolenCreditCard

	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | self error: Cashier stolenCreditCardErrorDescription ].
	
	self should: [ aCashier checkout: aCart with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier stolenCreditCardErrorDescription .
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:18:36'!
test12aCashierCanNotCheckoutACartWithItemsUsinACreditCardWithoutFunds

	self addItemsToCatalog.
	self addItemsToCart.
	
	aMerchantProcessorBehaviour := [:anAmount :aCreditCard | self error: Cashier cardWithoutFundsErrorDescription ].
		
	self should: [aCashier checkout: aCart with: aValidCreditCard ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: Cashier cardWithoutFundsErrorDescription.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 01:07:01'!
test13anUnregisteredUserCantCreateACart
	| xxx |
	xxx := XXX new.
	self should: [xxx createCartwith: 'invalidUser' and: 'invalidPassword'.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: XXX userOrPasswordInvalidErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 01:59:45'!
test14aRegisteredUserCreateACartAndObtainACartID
	| xxx aCartID |
	
	xxx := XXX new.
	xxx registerClient: 'validUser' with: 'validPassword'.
	aCartID := xxx createCartwith: 'validUser' and: 'validPassword'.
	self assert: aCartID = 1.! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 02:00:02'!
test15aRegisteredUserWithInvalidPasswordCantCreateACart
	| xxx |
	
	xxx := XXX new.
	xxx registerClient: 'validUser' with: 'validPassword'.
	
	self should: [xxx createCartwith: 'validUser' and: 'invalidPassword'.]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: XXX userOrPasswordInvalidErrorDescription .
			].! !

!TusLibrosTEST methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:09:52'!
today

	^FixedGregorianDate yearNumber: 2017 monthNumber: 10 dayNumber: 30.! !


!classDefinition: #Cart category: #'TusLibros.com'!
Object subclass: #Cart
	instanceVariableNames: 'content catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:08:45'!
add: anItem

	(catalog includes: anItem) ifFalse: [ self error: Cart canNotAddItemFromOtherStoreErrorDescription ].
	content add: anItem.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:08:50'!
add: anItem quantity: aQuantity 

	(aQuantity > 0) ifFalse: [ self error: Cart canNotAddNonPositiveQuantityOfItemsErrorDescription ].
	aQuantity timesRepeat: [ self add: anItem ].! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 01:48:34'!
includes: anItem 

	^content includes: anItem.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:08:57'!
initializeWith: aCatalog

	content := OrderedCollection new. 
	catalog := aCatalog.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:09:05'!
isEmpty

	^content isEmpty.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:09:13'!
quantityOf: anItem 
	| quantity |
	
	quantity := 0.
	content do: [ :aContainedItem | (anItem = aContainedItem) ifTrue: [ quantity := quantity + 1 ] ].
	^quantity.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:53:45'!
total
	| totalPrice |
	
	totalPrice := 0.
	content do: [ :aContainedItem | totalPrice := totalPrice + (catalog priceOf: aContainedItem) ].
	^totalPrice.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #'TusLibros.com'!
Cart class
	instanceVariableNames: 'catalog'!

!Cart class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/28/2017 23:45:57'!
canNotAddItemFromOtherStoreErrorDescription
	^'invalid item'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 00:07:54'!
canNotAddNonPositiveQuantityOfItemsErrorDescription
	^'invalid quantity'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'yn 10/26/2017 20:17:48'!
with: aCatalog 
	^self new initializeWith: aCatalog.! !


!classDefinition: #Cashier category: #'TusLibros.com'!
Object subclass: #Cashier
	instanceVariableNames: 'calendar salesBook merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:57:14'!
checkout: aCart with: aCreditCard

	(aCart isEmpty) ifTrue: [ self error: Cashier canNotCheckoutAnEmptyCartErrorDescription ].
	
	(aCreditCard isExpired: calendar today monthOfYear) ifTrue: [ self error: Cashier canNotCheckoutWithAnExpiredCreditCardErrorDescription ].
	
	merchantProcessor debit: (aCart total) from: aCreditCard.

	salesBook add: aCart total.
	
	^Ticket with: (aCart total).! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 20:49:08'!
initializeWith: aCalendar and: aSalesBook and: aMerchanProcessor

	calendar := aCalendar .
	salesBook := aSalesBook .
	merchantProcessor := aMerchanProcessor.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #'TusLibros.com'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/29/2017 06:13:03'!
canNotCheckoutAnEmptyCartErrorDescription

	^'cant checkout empty cart'.! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:25:21'!
canNotCheckoutWithAnExpiredCreditCardErrorDescription
	^'cant checkout with expired credit card'! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 04:45:10'!
cardWithoutFundsErrorDescription
	^'card without funds'! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 04:43:43'!
stolenCreditCardErrorDescription
	^'stolen card'.! !

!Cashier class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/2/2017 04:15:14'!
with: aCalendar and: aSalesBook and: aMerchanProcessorAdapter

	^self new initializeWith: aCalendar and: aSalesBook and: aMerchanProcessorAdapter.! !


!classDefinition: #Catalog category: #'TusLibros.com'!
Object subclass: #Catalog
	instanceVariableNames: 'content'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Catalog methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 19:06:31'!
add: anItem with: aPrice
	aPrice < 0 ifTrue: [ self error: Catalog canNotRegisterAnItemWithNonPositivePriceErrorDescription ].
	content at: anItem  put: aPrice.! !

!Catalog methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:51:17'!
includes: anItem

	^content includesKey: anItem.! !

!Catalog methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:44:47'!
initialize

	content := Dictionary new.! !

!Catalog methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 18:46:03'!
priceOf: anItem

	^content at: anItem .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Catalog class' category: #'TusLibros.com'!
Catalog class
	instanceVariableNames: ''!

!Catalog class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 19:05:36'!
canNotRegisterAnItemWithNonPositivePriceErrorDescription

	^'invalid price'! !


!classDefinition: #CreditCard category: #'TusLibros.com'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!CreditCard methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:36:07'!
initializeWith: anExpirationMonthAndYear

	expiration := anExpirationMonthAndYear.! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:38:48'!
isExpired: aMonthAndYear

	^expiration  < aMonthAndYear .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #'TusLibros.com'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 03:36:01'!
withExpiration: anExpirationMonthAndYear

	^self new initializeWith: anExpirationMonthAndYear.! !


!classDefinition: #Ticket category: #'TusLibros.com'!
Object subclass: #Ticket
	instanceVariableNames: 'total content'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!Ticket methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 19:24:12'!
includes: anItem 
	^content at: anItem! !

!Ticket methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:31:26'!
initializeWith: aTotalTransactionCost

	total := aTotalTransactionCost ! !

!Ticket methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:22:40'!
total

	^total.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Ticket class' category: #'TusLibros.com'!
Ticket class
	instanceVariableNames: ''!

!Ticket class methodsFor: 'as yet unclassified' stamp: 'a-lavia 10/30/2017 04:30:53'!
with: aTotalTransactionCost

	^self new initializeWith: aTotalTransactionCost .! !


!classDefinition: #XXX category: #'TusLibros.com'!
Object subclass: #XXX
	instanceVariableNames: 'clients'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros.com'!

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 01:58:18'!
createCartwith: aClientID and: aPassword
	|aClientPassword|
	aClientPassword := clients at: aClientID ifAbsent: [self error: XXX userOrPasswordInvalidErrorDescription].
	aClientPassword  = aPassword ifFalse: [self error: XXX userOrPasswordInvalidErrorDescription ].
	^1.! !

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 01:40:08'!
initialize
	clients := Dictionary new.! !

!XXX methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 01:43:42'!
registerClient: aClientID with: aPassword
	clients at: aClientID put: aPassword .! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'XXX class' category: #'TusLibros.com'!
XXX class
	instanceVariableNames: ''!

!XXX class methodsFor: 'as yet unclassified' stamp: 'a-lavia 11/5/2017 13:29:42'!
userOrPasswordInvalidErrorDescription
	'user or password invalid'.! !