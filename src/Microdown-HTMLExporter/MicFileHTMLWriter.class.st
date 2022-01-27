Class {
	#name : #MicFileHTMLWriter,
	#superclass : #MicrodownVisitor,
	#category : #'Microdown-HTMLExporter'
}

{ #category : #'as yet unclassified' }
MicFileHTMLWriter >> convertFile: aFile [

	|doc write fileref |
	fileref := aFile asFileReference.
	doc := Microdown new parse: fileref contents.

	write := MicHTMLWriter new.
	write visit: doc.

	(fileref parent / (fileref basenameWithoutExtension: 'md'), 'html') asFileReference 
		writeStreamDo: [ :st | st nextPutAll: write contents ]


]
