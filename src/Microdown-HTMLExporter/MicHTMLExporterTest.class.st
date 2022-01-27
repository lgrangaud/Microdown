Class {
	#name : #MicHTMLExporterTest,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'writer',
		'factory'
	],
	#category : #'Microdown-HTMLExporter'
}

{ #category : #utilities }
MicHTMLExporterTest >> parse: aString andCheckWeGet: aResultingString [
	
	| mic |
	mic := parser parse: 	aString.
	writer visit: mic.
	self assert: writer contents equals: aResultingString
]

{ #category : #accessing }
MicHTMLExporterTest >> parser [
	^ parser
]

{ #category : #running }
MicHTMLExporterTest >> setUp [
	super setUp.
	parser := MicroDownParser new.
	writer := MicHTMLWriter new.
	factory := MicMicrodownSnippetFactory new
]

{ #category : #'tests - paragraph' }
MicHTMLExporterTest >> testAccents [

	self parse: 'éà' andCheckWeGet:  '
<p>&eacute;&agrave;</p>'
]

{ #category : #tests }
MicHTMLExporterTest >> testAnchor [

	self parse: factory anchorSample andCheckWeGet:  '<a id="test"></a>'
	
]

{ #category : #tests }
MicHTMLExporterTest >> testAnchorIsAttachedToItsTarget [
	| linker doc |
	linker := MicAnchorLinker new.
	doc := MicroDownParser parse: '
this is a sentence

#Header1
@sec1'.
	linker visit: doc.
	self assert: doc children second class equals: MicHeaderBlock.
	self assert: doc children third class equals: MicAnchorBlock.
	self assert: doc children third target class equals: MicHeaderBlock
	
]

{ #category : #tests }
MicHTMLExporterTest >> testCodeCreatesInnerText [

	| code |
	code := (self parser parse: '```a b```') children first.
	self assert: code class equals: MicCodeBlock.
	self assert: code firstTag equals: 'a b```'
]

{ #category : #tests }
MicHTMLExporterTest >> testCodeWithoutParam [

	| doc |
	doc := (parser parse: '```
ab
```') children first.
	writer visit: doc.
	self assert: writer contents equals: '<pre><code>ab</code></pre>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testFigure [

	self parse: factory figureSample andCheckWeGet: '
<p><img src="/anUrl" alt="Foo"/><figcaption>Foo</figcaption>
</p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testFigureItalic [

	self parse: factory figureItalicSample andCheckWeGet: '
<p><img src="/anUrl" alt="_Foo_" class="figureTest" width="80"/><figcaption><em>Foo</em></figcaption>
</p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testFigureNested [

	self parse: factory figureNestedSample andCheckWeGet: '
<p><img src="/anUrl" alt="**Foo_**" class="figureTest" width="80"/><figcaption><strong>Foo_</strong></figcaption>
</p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testFigureReal [

	self parse: factory figureRealSample andCheckWeGet: '
<p><img src="figures/logo.png" alt="A logo png under figures folder" class="figureTest" width="80"/><figcaption>A logo png under figures folder</figcaption>
</p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testFigureStrike [

	self parse: factory figureStrikeSample andCheckWeGet: '
<p><img src="/anUrl" alt="~Foo~" class="figureTest" width="80"/><figcaption><strike>Foo</strike></figcaption>
</p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testFigureWithLabelWithoutSize [

	self
		parse: factory figureWithLabelWithoutSizeSample
		andCheckWeGet: '
<p><img src="/anUrl" alt="Foo" class="figureTest"/><figcaption>Foo</figcaption>
</p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testFigureWithoutCaption [

	self parse: factory figureWithoutCaptionSample andCheckWeGet: '
<p><img src="/anUrl" alt="" class="figureTest" width="80"/><figcaption></figcaption>
</p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testGoutDeFraise [

	self parse: factory figureGoutDeFraise andCheckWeGet: '
<p><img src="un-gout-de-fraise.jpg" alt="Proposition pour le thème : _Un goût de fraise_"/><figcaption>Proposition pour le th&egrave;me : <em>Un goût de fraise</em></figcaption>
</p>'
]

{ #category : #tests }
MicHTMLExporterTest >> testHeaderLevel1 [

	self parse: factory headerLevel1Sample andCheckWeGet: writer usedNewLine , '<h1>Foo</h1>'
	
]

{ #category : #tests }
MicHTMLExporterTest >> testHeaderLevel2 [

	self
		parse: factory headerLevel2Sample
		andCheckWeGet: writer usedNewLine , '<h2>Foo</h2>'
]

{ #category : #'tests - paragraph' }
MicHTMLExporterTest >> testParagraph [
	
	self parse: factory paragraphSample andCheckWeGet: writer usedNewLine ,'<p>Foo</p>'
]

{ #category : #'tests - paragraph' }
MicHTMLExporterTest >> testParagraphLongWithAccents [

	self parse: factory paragraphOnMultipleLinesSample andCheckWeGet: '
<p>Je ne connais pas la peur, car la peur tue l''esprit. La peur est la petite mort qui conduit &agrave; l''oblit&eacute;ration totale. J''affonterai ma peur. Je lui permettrais de passer sur moi, au travers de moi. Et lorsqu''elle sera pass&eacute;e, je tournerai mon oeil interieur sur son chemin. Et l&agrave; o&ugrave; elle sera pass&eacute;e, il n''y aura plus rien, rien que moi.</p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testParagraphNestedSample [

	self parse: factory paragraphNestedSample andCheckWeGet:  '
<p>this is a <strong><em>paragraph</em></strong></p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testParagraphWithBold [

	self parse: factory paragraphBoldSample andCheckWeGet:  '
<p>this is a <strong>paragraph</strong></p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testParagraphWithBoldItalic [

	self
		parse: factory paragraphWithBoldItalicHeaderSample
		andCheckWeGet: '
<h1>Header1</h1>
<h2>Header2</h2>
<p>this is a paragraph with <strong>bold text</strong> and <em>italic text</em></p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testParagraphWithBoldItalicHeader [

	self
		parse: factory paragraphWithBoldItalicHeaderSample
		andCheckWeGet: '
<h1>Header1</h1>
<h2>Header2</h2>
<p>this is a paragraph with <strong>bold text</strong> and <em>italic text</em></p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testParagraphWithItalic [

	self parse: factory paragraphItalicSample andCheckWeGet: '
<p>this is a <em>paragraph</em></p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testParagraphWithMonospace [

	self parse: factory paragraphMonospaceSample andCheckWeGet:  '
<p>this is a <code>paragraph</code></p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testQuote [

	self parse: factory quoteSample andCheckWeGet: 
	'<q>Foo</q>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testStrike [

	self parse: factory strikethroughFormatSample andCheckWeGet: '
<p><strike>Foo</strike></p>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testTable [

	| micTable |
	micTable := parser parse: factory tableSample.
	writer visit: micTable.
	self assert: writer contents equals: '
<table>
<tr><th>aaab</th><th>jkhjh</th></tr>
<tr><td>bar</td><td>rab</td></tr>
</table>'
]

{ #category : #'tests - list' }
MicHTMLExporterTest >> testUnorderedList [

	self parse: factory unorderedListWithTwoItemsSample andCheckWeGet: '
<ul>
<li>Foo</li>
<li>Bar</li>
</ul>'
]

{ #category : #'tests - formats' }
MicHTMLExporterTest >> testfigure [

	self parse: factory figureSample andCheckWeGet: '
<p><img src="/anUrl" alt="Foo"/><figcaption>Foo</figcaption>
</p>'
]

{ #category : #'tests - list' }
MicHTMLExporterTest >> testorderedList [

	self parse: factory orderedListWithTwoItemsSample andCheckWeGet: '
<ol>
<li>first</li>
<li>second</li>
</ol>'.
]

{ #category : #'tests - list' }
MicHTMLExporterTest >> testorderedListEmpty [

	self parse: factory orderedListEmptySample andCheckWeGet: '
<ol>
<li>.</li>
</ol>'
]
