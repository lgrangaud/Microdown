Extension { #name : #MicCodeBlock }

{ #category : #'*Microdown-Evaluator' }
MicCodeBlock >> eval: aBoolean [
	arguments at: #eval put: aBoolean

]

{ #category : #'*Microdown-Evaluator' }
MicCodeBlock >> evaluate [

	| content |
	content := self evaluationString.
	^ [ (MicAbstractBlock new parserClass new parse: content) children ]
		on: Error
		do: [ :e | MicBoldFormatBlock new children: { (MicTextBlock new substring: e messageText) } ]
]

{ #category : #'*Microdown-Evaluator' }
MicCodeBlock >> evaluationString [
	^ String
		streamContents: [ :stream | 
			| evaluator |
			evaluator := MicCodeblockEvaluatorEnv new
				setStream: stream;
				yourself.
			[ self class compiler
				source: self body;
				logged: false;
				receiver: evaluator;
				evaluate ]
				on: Error
				do: [ :e | 
					stream
						nextPutAll: '= ';
						nextPutAll: e description ] ]
]

{ #category : #'*Microdown-Evaluator' }
MicCodeBlock >> isEvaluated [ 
	arguments at: #eval ifAbsent: [ ^ false ].
	^ arguments at: #eval
]
