beforeEach ->
	
	@fixtures =
		Tasks:
			valid:
				'status'		:	'OK'
				'version' 	: '1.0'
				'response'	:
					'tasks' 	: [
						{
							'id' 		: '1'
							'text'	: 'Clean office'
							'date'	: new Date(2011, 7, 18)
							'done'	: false
						}
						{
							'id' 		: '2'
							'text'	: 'Clean room'
							'date'	: new Date(2011, 8, 18)
							'done'	: false
						}
					]
	
