Class {
	#name : #MicHTMLWriter,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'canvas',
		'arguments'
	],
	#category : #'Microdown-HTMLExporter'
}

{ #category : #initialization }
MicHTMLWriter >> canvasClass [

	^ MicHTMLCanvas
]

{ #category : #accessing }
MicHTMLWriter >> contents [ 
	^ canvas contents
]

{ #category : #visiting }
MicHTMLWriter >> createAnchorWith: anId [

	canvas tag
		name: 'a';
		parameterAt: 'id' put: anId;
		with: ''
]

{ #category : #visiting }
MicHTMLWriter >> exportImgFor: aFigure [

	| img |
	img := canvas tag
		       name: 'img';
		       parameterAt: 'src' put: aFigure localFileOrExternalReference;
		       yourself.
	img parameterAt: 'alt' put: (aFigure hasChildren
			 ifTrue: [ aFigure text ]
			 ifFalse: [ '' ]).
	aFigure hasLabel ifTrue: [ 
		img parameterAt: 'class' put: (aFigure arguments at: 'label') ].
	aFigure hasWidth ifTrue: [ 
		img parameterAt: 'width' put: (aFigure arguments at: 'size') ].
	img closeTag.
	canvas tag
		name: 'figcaption';
		with: [ 
			aFigure hasCaption ifTrue: [ 
					self visitAll: aFigure captionElements ] ].
	canvas newLine
]

{ #category : #initialization }
MicHTMLWriter >> initialize [ 
	| stream |
	super initialize.
	stream := MicOutputStream new setStream: (WriteStream on: (String new: 1000)).
	canvas := self canvasClass on: stream.
	
]

{ #category : #visiting }
MicHTMLWriter >> isSyntaxHighlightingPossible [

	^ true
]

{ #category : #visiting }
MicHTMLWriter >> languageForScript: aScript [

	^ aScript language isSpecified
		  ifTrue: [ aScript language ]
		  ifFalse: [ self configuration defaultScriptLanguage ]
]

{ #category : #visiting }
MicHTMLWriter >> localFileOrExternalReference [
	^ self class localFileOrExternalReference: self reference
]

{ #category : #initialization }
MicHTMLWriter >> usedNewLine [
	"Return the encoded new line. Useful for tests."
	
	^ canvas stream usedNewLine
]

{ #category : #visiting }
MicHTMLWriter >> visitAnchor: anAnchor [

	self createAnchorWith: anAnchor label 
]

{ #category : #visiting }
MicHTMLWriter >> visitBold: aBoldText [

	canvas tag
		name: 'strong';
		with: [ super visitBold: aBoldText ]
]

{ #category : #visiting }
MicHTMLWriter >> visitCode: aCodeBlock [

	canvas tag
		name: 'pre';
		with: [ 
			| code |
			code := canvas tag
				        name: 'code';
				        yourself.
			code with: [ canvas lines: aCodeBlock body ] ].
	aCodeBlock hasCaption ifTrue: [ 
		canvas tag
			name: 'figcaption';
			with: [ 
				aCodeBlock hasLabel ifTrue: [ 
						self createAnchorWith: aCodeBlock label.
						self writeCounterForScript: aCodeBlock ].
				aCodeBlock hasCaption ifTrue: [ 
						self visitAll: aCodeBlock caption children ] ] ].

]

{ #category : #visiting }
MicHTMLWriter >> visitFigure: aFigure [

	self exportImgFor: aFigure
]

{ #category : #visiting }
MicHTMLWriter >> visitHeader: aHeader [

	canvas newLine.	
	canvas tag 
		name: 'h',  aHeader level asString;
		with: aHeader header
	
]

{ #category : #visiting }
MicHTMLWriter >> visitItalic: aItalicText [

	canvas tag
		name: 'em';
		with: [ super visitItalic: aItalicText ]
]

{ #category : #visiting }
MicHTMLWriter >> visitMonospace: aMonospace [

	canvas tag
		name: 'code';
		with: [ super visitMonospace: aMonospace ]
]

{ #category : #'visiting - list' }
MicHTMLWriter >> visitOrderedList: anOrderedList [

	canvas newLine.
	canvas tag
		name: 'ol';
		with: [ 
			canvas newLine.
			super visitOrderedList: anOrderedList ]
]

{ #category : #'visiting - list' }
MicHTMLWriter >> visitOrderedListItem: anOrderedListItem [

	canvas tag
		name: 'li';
		with: anOrderedListItem text.
	canvas newLine
]

{ #category : #visiting }
MicHTMLWriter >> visitParagraph: aParagraph [

	canvas newLine.
	canvas tag
				name: 'p';
				with: [ super visitParagraph: aParagraph ]
]

{ #category : #visiting }
MicHTMLWriter >> visitQuote: aQuote [

	canvas tag
		name: 'q';
		with: [ 
			super visitMonospace: aQuote ]
]

{ #category : #'visiting - list' }
MicHTMLWriter >> visitStrike: aStrike [

	canvas tag
		name: 'strike';
		with: [ super visitStrike: aStrike ]
]

{ #category : #visiting }
MicHTMLWriter >> visitTable: aTable [

	| restRows |
	canvas newLine.
	canvas tag
		name: 'table';
		with: [ 
			canvas newLine.
			aTable hasHeader
				ifTrue: [ 
					self writeTableHeaders: aTable rows first. 
					restRows := aTable rows allButFirst  ] 
				ifFalse: [ restRows := aTable rows ].
			self writeTableRows: restRows.
			 ]
]

{ #category : #visiting }
MicHTMLWriter >> visitText: aText [

	canvas nextPutAll: aText text
]

{ #category : #visiting }
MicHTMLWriter >> visitUnorderedList: anUnorderedList [

	canvas newLine.
	canvas tag
		name: 'ul';
		with: [ canvas newLine. super visitUnorderedList: anUnorderedList  ]
]

{ #category : #visiting }
MicHTMLWriter >> visitUnorderedListItem: anUnorderedListItem [
	"will not work with we have text decorators such as bold, italic, monospace"
	
	canvas tag
		name: 'li';
		with: anUnorderedListItem text.
	canvas newLine
]

{ #category : #visiting }
MicHTMLWriter >> writeCounter: aCounter [

	"Write on the canvas the string representation of ==aCounter=="

	^ aCounter elements
		  do: [ :each | self writeCounterElement: each ]
		  separatedBy: [ self writeCounterElementSeparator ]
]

{ #category : #visiting }
MicHTMLWriter >> writeCounterDefinitionSeparator [

	canvas nextPutAll: '. '
]

{ #category : #visiting }
MicHTMLWriter >> writeCounterElement: aCounterElement [

	canvas nextPutAll: aCounterElement asString
]

{ #category : #visiting }
MicHTMLWriter >> writeCounterElementSeparator [

	canvas nextPut: $.
]

{ #category : #visiting }
MicHTMLWriter >> writeCounterForScript: aScript [

	aScript counter isValidCounter ifFalse: [ ^ self ].
	self writeCounter: aScript counter.
	self writeCounterDefinitionSeparator
]

{ #category : #writing }
MicHTMLWriter >> writeTableHeaders: headers [
	canvas tag
		name: 'tr';
		with: [ headers do: [ :cell | canvas tag name: 'th'; with: [self visitAll: cell]] ].
	canvas newLine
		
]

{ #category : #writing }
MicHTMLWriter >> writeTableRows: rows [
	rows do: [ :row |
		canvas tag
			name: 'tr';
			with: [ row do: [ :cell | canvas tag name: 'td'; with: [self visitAll: cell]] ].
		canvas newLine]
		
]
