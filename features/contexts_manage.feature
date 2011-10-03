Feature: lists can be created and managed
	In order to organise tasks based on different lists
	I want to be able to add, delete and edit the name of different lists

	Background:
		Given I have signed up
		And I am logged in

	Scenario: Initially the first list is selected
		When I am on the tasks page
		Then I should see the "Home" list selected
		And I should not see the "Work" list selected

	Scenario: The user's previously selected lists are selected
		When I am on the tasks page
		And I select the "Work" list
		And I reload the page
		Then I should see the "Work" list selected

	Scenario: Home and Work are default lists
		When I am on the tasks page
		Then I should see the "Home" list
		And I should see the "Work" list

	Scenario: A list is added
		When I am on the tasks page
		And I click "#add-context"
		Then I should see an input box 
		When I fill in "context_input" with "Boom" and press enter 
		And I reload the page
		Then I should see the "Boom" list

	Scenario: A list's name is changed
		When I am on the tasks page
		And I double click the "Work" list
		Then I should see an input box
		When I fill in "context_input" with "Play" and press enter 
		And I reload the page
		Then I should see the "Play" list

	Scenario: A list is deleted
		When I am on the tasks page
		And I drag the "Work" list to the rubbish bin
		Then I should not see the "Work" list
		When I reload the page
		Then I should not see the "Work" list
