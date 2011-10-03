Feature: User can enter a new task
	In order to make a note of something I've got to do
	I want to be able to create a new task and specify when it is due. I want to specify the date by a normal format, such as "10/10/12" or by using the day of the week, "next week", "next month" or "next year"

	Background:
		Given I have signed up
		And I am logged in
		And I am on the tasks page

	Scenario: A task is entered with no due date and one list selected
		When I select the "Home" list
		And I fill in "add_task" with "Do gardening" and press enter
		And I reload the page
		Then I should see "Do gardening"

	Scenario: A task is entered with no due date and three lists selected
		When I select the "Home" list
		And I select the "Work" list
		And I fill in "add_task" with "Make tea" and press enter
		And I reload the page
		And I select the "Home" list
		Then I should see "Make tea"
		And I select the "Work" list
		Then I should see "Make tea"

	Scenario: A UK format date is specified for a task
		When I select the "Home" list
		And I fill in "add_task" with "Do gardening for 12/07/11" and press enter
		And I reload the page
		Then I should see "Do gardening"
		And I should see "12/7/2011"

	Scenario: The task's date is automatically detected
		When I select the "Home" list
		And I fill in "add_task" with "Do gardening for tomorrow" and press enter
		And I reload the page
		Then I should see "Do gardening"
		And I should see "Tomorrow"

