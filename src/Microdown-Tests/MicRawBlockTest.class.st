Class {
	#name : #MicRawBlockTest,
	#superclass : #MicElementTest,
	#category : #'Microdown-Tests-Parser'
}

{ #category : #tests }
MicRawBlockTest >> testRaw [

	| root |
	root := parser parse: '{{_Foo_}}'.
	self assert: root children first class equals: MicParagraphBlock.
	self
		assert: root children first children first text
		equals: '_Foo_'
]
