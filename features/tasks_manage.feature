Feature: Management of tasks
	In order to see what tasks I have to do and when
	I want to be able to view a list of my tasks.  
	I also want to be able to mark tasks as done, put off, modify and delete existing tasks. 
	I also want to be able to set a task to recur.

	Background:
		Given I have signed up 
		And I am logged in
		And I have entered my tasks for today
		And I am on the tasks page

	Scenario: A list of tasks is shown with one list selected
		When I select the "Home" list
		Then I should see the following tasks:
			| Task                          | Date      	|
			| Buy cheese and milk and bread | Yesterday 	|
			| Tidy up room                  | Today     	|
			| Do laundry                    | {Calced}	  |
			| Pay credit card bill          | 29/12/2011  |

			#	Scenario: A list of tasks is shown with two lists selected
			#		When I select the "Home" list
			#		And I hold down ctrl
			#		And I select the "Work" list
			#		And I release ctrl
			#		Then I should see the following tasks:
			#			| Task                          | Date     		 |
			#			| Buy cheese and milk and bread | Yesterday		 |
			#			| Tidy up room                  | Today    		 |
			#			| Write cucumber features       | Today    		 |
			#			| Do laundry                    | Monday	 		 |
			#			| Pay credit card bill          | 29/07/2011 	 |
			#			| Sort Github repos             | 29/12/2011 	 |

	Scenario: A task is marked as done
		When I select the "Home" list
		And I mark "Do laundry" as done
		Then I should see "Do laundry" crossed out

	Scenario: A task is put off
		When I select the "Home" list
		And I put off "Do laundry"
		And I reload the page
		Then I should see the date increase by one day 

	Scenario: A task's text is modified
		When I select the "Home" list
		And I double click on "Do laundry"
		And I fill in "text_input" with "Do laundry (white wash)" and press enter
		And I reload the page
		Then I should see "Do laundry (white wash)"

	Scenario: A task's date is modified
		When I select the "Home" list
		And I double click on the "29/12/2011" date
		And I fill in "date_input" with "29/08/11" and press enter
		And I reload the page
		Then I should see "29/8/2011"

	Scenario: A task is deleted
		When I select the "Home" list
		And I drag the "Do laundry" task to the rubbish bin
		Then I should not see "Do laundry"
		When I reload the page
		Then I should not see "Do laundry"

