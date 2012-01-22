Feature: Sign up
	In order to use the site
	I want to be able to enter a username and password and be registered with the site, without having to enter any details that would compromise my anonymity.
	As a site owner, I want only a certain selection of people to be able to join the site.

	Scenario: I sign up with a username and strong password
		When I go to the sign up page
		And I fill in "username" with "jackbauer"
		And I fill in "password" with "Ve4yStr0ngPa55w0rd!43sdfs"
		And I fill in "confirm_password" with "Ve4yStr0ngPa55w0rd!43sdfs"
		And I wait
		And I press "Sign me up!"
		Then I should see "We'll now take you to the sign in page"
		#		And I should be on the sign in page

	Scenario: I sign up with a username and weak password
		When I go to the sign up page
		And I fill in "username" with "jackbauer"
		And I fill in "password" with "weakling"
		And I fill in "confirm_password" with "weakling"
		And I press "Sign me up!"
		Then I should see "That isn't very secure."

	Scenario: I sign up with an empty username
		When I go to the sign up page
		And I fill in "username" with ""
		And I fill in "password" with "Ve4yStr0ngPa55w0rd!43sdfs"
		And I fill in "confirm_password" with "Ve4yStr0ngPa55w0rd!43sdfs"
		And I press "Sign me up!"
		Then I should see "A user name or email address is required!"

	Scenario: I sign up with a username that has already been taken
		Given I have signed up
		When I go to the sign up page
		And I fill in "username" with "jackbauer"
		And I fill in "password" with "Ve4yStr0ngPa55w0rd!43sdfs"
		And I fill in "confirm_password" with "Ve4yStr0ngPa55w0rd!43sdfs"
		And I wait
		And I press "Sign me up!"
		Then I should see "That's taken :( Please choose another."
	
	Scenario: I sign up with an empty password
		When I go to the sign up page
		And I fill in "username" with "jackbauer"
		And I fill in "password" with ""
		And I fill in "confirm_password" with "Ve4yStr0ngPa55w0rd!43sdfs"
		And I press "Sign me up!"
		Then I should see "A password is required!"
	
	Scenario: My password does not match my confirmed password
		When I go to the sign up page
		And I fill in "username" with "jackbauer"
		And I fill in "password" with "jumpingjesusohlawwwd"
		And I fill in "confirm_password" with "Ve4yStr0ngPa55w0rd!43sdfs"
		And I press "Sign me up!"
		Then I should see "This doesn't match your password!"

