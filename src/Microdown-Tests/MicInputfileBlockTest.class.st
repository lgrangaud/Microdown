Class {
	#name : #MicInputfileBlockTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'Microdown-Tests-Extensions'
}

{ #category : #running }
MicInputfileBlockTest >> setUp [
	super setUp.
	parser := MicroDownParser new
]

{ #category : #tests }
MicInputfileBlockTest >> testMicInputfileIsNotRelativeFilePath [
	| mic |
	mic := parser parse: '?{inputFile|path=/chapters/withStyle.mic}?'.
	self assert: mic children first children first path path equals: '/chapters/withStyle.mic'
]

{ #category : #tests }
MicInputfileBlockTest >> testMicInputfileIsRelativeFilePath [
	| mic |
	mic := parser parse: '?{inputFile|path=chapters/withStyle.mic}?'.
	mic children first children first path: mic children first children first originalPath.
	self assert: mic children first children first path path equals: 'chapters/withStyle.mic'
]

{ #category : #tests }
MicInputfileBlockTest >> testMicInputfilePath [
	| mic |
	mic := parser parse: '?{inputFile|path=chapters/withStyle.mic}?'.
	self assert: mic children first children first path path equals: 'chapters/withStyle.mic' 
]

{ #category : #tests }
MicInputfileBlockTest >> testMicInputfilePathError [
	| mic |
	mic := parser parse: '?{inputFile|path:errror=fchapters/withStyle.mic}?'.
	self assert: mic children first children first path class equals: MicInvalidResourceReference.
	self 
		assert: mic children first children first path originalString 
		equals: 'inputFile|path:errror=fchapters/withStyle.mic'
]
