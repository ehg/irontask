Feature: Secure access to the site
	In order to access my task list securely
	I want to be able to sign in and log out from the site, without my raw password being sent to the site 

	Scenario: I see a link to sign up on the sign in page
		When I go to the sign in page
		Then I should see "Want an account? Sign up!"
		When I follow "Sign up!"
		Then I should be on the sign up page

	Scenario: User logs in with correct details
		Given I have signed up 
		When I go to the sign in page
		And I fill in "jackbauer" for "username"
		And I fill in "Ve4yStr0ngPa55w0rd!43sdfs" for "input_password"
		And I press "Sign in"
		Then I should be on the tasks page
		And I should see "(sign out)"

	Scenario: User logs in with incorrect details
		Given I have signed up 
		When I go to the sign in page
		And I fill in "cucumber" for "username"
		And I fill in "wrongpassword" for "input_password"
		And I press "Sign in"
		Then I should be on the sign in page
		And I should see "Wrong Username/Email and password combination."

	Scenario: User logs out
		Given I have signed up 
		And I am logged in
		And I am on the tasks page
		When I follow "(sign out)"
		Then I should be on the sign in page
		And I should see "You have signed out."
