Class {
	#name : #MicFileHTMLWriterTest,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'writer',
		'factory',
		'filesystem',
		'converter'
	],
	#category : #'Microdown-HTMLExporter'
}

{ #category : #tests }
MicFileHTMLWriterTest >> generateFilesystemExample [

	| file |
	file := filesystem workingDirectory / 'anExample1.md'.
	file writeStreamDo: [ :stream | stream nextPutAll: '# Foo
@sec1

Pharo is cool

```
	this is a code
```
' ].
	file := filesystem workingDirectory / 'anExample2.md'.
	file writeStreamDo: [ :stream | stream nextPutAll: '## Bar
@sec2
Pharo is **cool**

```
	this is a code 2
```
' ]
]

{ #category : #tests }
MicFileHTMLWriterTest >> setUp [
	super setUp.
	converter := MicFileHTMLWriter new.
	filesystem := FileSystem memory.
	self generateFilesystemExample.
	
	
]

{ #category : #tests }
MicFileHTMLWriterTest >> testConvertFile [

	converter convertFile: (filesystem / 'anExample1.md') asFileReference.
	
	self assert: (filesystem / 'anExample1.html') asFileReference exists.
	self assert: (filesystem / 'anExample1.html') asFileReference contents equals: '
<h1>Foo</h1><a id="sec1"></a>
<p>Pharo is cool</p><pre><code> this is a code</code></pre>'.
]

{ #category : #tests }
MicFileHTMLWriterTest >> testConvertFile2 [

	converter convertFile: (filesystem / 'anExample2.md') asFileReference.

	self assert: (filesystem / 'anExample2.html') asFileReference exists.
	self
		assert: (filesystem / 'anExample2.html') asFileReference contents
		equals: '
<h2>Bar</h2><a id="sec2"></a>
<p>Pharo is <strong>cool</strong></p><pre><code> this is a code 2</code></pre>'
]
