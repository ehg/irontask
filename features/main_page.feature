Feature: When I got to the main page of the site, if I'm not signed in I want a splash page. If I am logged in, I want to go to my tasks.

	Scenario: I am not signed in
		Given I am on the home page
		Then I should be on the sign in page

	Scenario: I am signed in
		Given I have signed up
		And I am logged in
		When I go to the home page
		Then I should be on the tasks page
