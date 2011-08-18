beforeEach ->
	crypted_metadata = '''
	U2FsdGVkX19EY8EYmgOsKy5wzb+14U2jjy5rvKpdHIfvDryjDhBS3KhMhCGJY6Jcq8IunqEnpmzPa9mUuqFKHt2/ZKPrSdhlvvBl7ZLJdPeAaEM3Y54+uJIU7d7hlrSYJ0SP/YR+ikbUU+oIvYvTjikfcQod4NKhov2ATrslBe0ZOhUgh3BccDC4Zp1F6/ZNjMCPTrNJl0mANTJVSFaI69zkp3PPvw1PMs7iB7bP18cXN+KauAtPyr6xy5bmo7z3+VlqIh8xL+hFwp+zxtJIirxpPoq+/R/5kZtAc8ogDdo7/omCYW/ZJM1fsPMIzodpw74Dm0Sc/nsCoqgwJykhpZ+UoFay5p/eJ3T0QEi8wIw0emEnqR5kYZjXyZ9Af92i5+gjnCx3H+FL25ojyfemBpr/cM9LCHZ8EBjfmdYnah0CxH3SZpaX2qYVGTCEEtHSTuWGlU4KHNe+xtxC391kWPnKkuERqA42odu7hKdJNzw=
	'''


	@fixtures =
		Tasks:
			valid:
				'status'		:	'OK'
				'version' 	: '1.0'
				'tasks' 	: [
					{
						'id' 		: '1'
						'content' : 'U2FsdGVkX18QQL+ITiM40Pp77t5RJWo/KM+m9I0JA6YiNzK2DEtxIoJ1aQ1wEMrgcx2395VQm9zv2+MjNzMlrb5JBOAQmIwh8Ub7afKiVKQ='
						'done'	: false
					}
					{
						'id' 		: '2'
						'content' : 'U2FsdGVkX18QQL+ITiM40Pp77t5RJWo/KM+m9I0JA6YiNzK2DEtxIoJ1aQ1wEMrgcx2395VQm9zv2+MjNzMlrb5JBOAQmIwh8Ub7afKiVKQ='
						'done'	: false
					}
				]
		MetaData:
			valid:
				'status'			:	'OK'
				'version' 		: '1.0'
				'metadata' 	: crypted_metadata
												
