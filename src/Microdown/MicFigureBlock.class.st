"
I am a **figure**.

My syntax is: `![Here is a nice caption.](https://files.pharo.org/media/logo/logo.png? anchor=figanchor&width=80)`

You should get the following picture: 
![Here is a nice caption.](https://files.pharo.org/media/logo/logo.png anchor=figanchor&width=80)

I have a resources, i.e. an object referencing either a file (in relative or absolute manner) or an Url, that refers to a given image object.

What is important to see is that there is a space between the url arguments and microdown arguments. 
"
Class {
	#name : #MicFigureBlock,
	#superclass : #MicInlineBlockWithUrl,
	#instVars : [
		'parameters',
		'reference'
	],
	#category : #'Microdown-ModelInline'
}

{ #category : #accessing }
MicFigureBlock class >> localFileOrExternalReference: aString [

	| localFileIndicator |
	localFileIndicator := 'file://'.
	^ (aString beginsWith: localFileIndicator)
		  ifTrue: [ aString allButFirst: localFileIndicator size ]
		  ifFalse: [ aString ]
]

{ #category : #converting }
MicFigureBlock >> accept: aVisitor [
 	^ aVisitor visitFigure: self
]

{ #category : #'as yet unclassified' }
MicFigureBlock >> alt [
  ^ self arguments at: #alt ifAbsent: ['']
]

{ #category : #'as yet unclassified' }
MicFigureBlock >> alt: aString [
    self arguments at: #alt put: aString
]

{ #category : #accessing }
MicFigureBlock >> anchor [
	^self arguments at: #anchor 
	ifAbsent: [ nil ] 
]

{ #category : #accessing }
MicFigureBlock >> arguments [
	^ parameters
]

{ #category : #accessing }
MicFigureBlock >> arguments: aDictionary [
	parameters := aDictionary
]

{ #category : #visiting }
MicFigureBlock >> closeMe [
	"We used this circumvoluted way to use the parsing on arguments provided by the URL parser
	There is a distinction between the URL (with it potential arguments) and external parameters such as the size and label. 
	The URL and the external parameters are separated by a space.
	
	So the user can express http://www.pharo.org/figures/goo.png?cookieOne=90&cookieTwo=foo size=80&label=ref12"

	| split |
	split := url splitOnFirst: Character space.
	self reference: (MicResourceReference fromUri: split first).
	self arguments: (MicArgumentsSplitter withString: (split second ifNil: [ '' ])) arguments.
	self captionElements: (self inlineParse: substring).
	self children: captionElements
]

{ #category : #testing }
MicFigureBlock >> hasAnchor [
	^self anchor isNotNil
]

{ #category : #testing }
MicFigureBlock >> hasArgumentNamed: asString [

	| label |
	label := self arguments at: asString ifAbsent: [ ^ false ].
	^ label isEmptyOrNil not
]

{ #category : #accessing }
MicFigureBlock >> hasArguments [

	^ parameters keys isNotEmpty
]

{ #category : #testing }
MicFigureBlock >> hasCaption [ 	
	^ captionElements notNil 
]

{ #category : #testing }
MicFigureBlock >> hasChildren [
	^ self children notEmpty.
]

{ #category : #testing }
MicFigureBlock >> hasLabel [

	^ self hasArgumentNamed: 'label'
]

{ #category : #testing }
MicFigureBlock >> hasWidth [

	^ self hasArgumentNamed: 'size'
]

{ #category : #accessing }
MicFigureBlock >> initialize [

	super initialize.
	parameters := OrderedDictionary new
]

{ #category : #accessing }
MicFigureBlock >> kind [
	self flag: #todo. 
	"remove me"
 	^ #figure
]

{ #category : #accessing }
MicFigureBlock >> localFileOrExternalReference [

	^ self class localFileOrExternalReference: reference originalString asString
]

{ #category : #accessing }
MicFigureBlock >> openingDelimiter [

 	^ MicFigureNameOpenerDelimiter markup
]

{ #category : #accessing }
MicFigureBlock >> originUrl [
	^ self properties at: #originUrl ifAbsent: [ 
		^ url ]
]

{ #category : #printing }
MicFigureBlock >> printOn: aStream [
 		aStream nextPut: $!;
 			nextPut: $[;
 			nextPutAll: self caption;
 			nextPut: $];
 			nextPut: $(.
		aStream nextPutAll: url. 
		aStream nextPut: $).
 		
]

{ #category : #accessing }
MicFigureBlock >> reference [

	^ reference
]

{ #category : #accessing }
MicFigureBlock >> reference: anObject [

	reference := anObject
]

{ #category : #accessing }
MicFigureBlock >> resources [ 

	^ url 
]

{ #category : #accessing }
MicFigureBlock >> resources: micResources [

	url := micResources
]
