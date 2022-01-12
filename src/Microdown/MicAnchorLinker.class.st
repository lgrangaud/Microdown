Class {
	#name : #MicAnchorLinker,
	#superclass : #MicrodownVisitor,
	#category : #Microdown
}

{ #category : #visiting }
MicAnchorLinker >> visitHeader: aHeader [

	| siblings position potentialAnchor | 
	siblings := aHeader parent children.
	position := siblings identityIndexOf: aHeader.
	"header is not the last one"
	siblings size > position
		ifTrue: [ potentialAnchor := siblings at: position + 1.
					potentialAnchor class = MicAnchorBlock 
							ifTrue: [ potentialAnchor target: aHeader ] ]
]
