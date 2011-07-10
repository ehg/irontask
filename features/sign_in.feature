Feature: Secure access to the site
    In order to access my task list securely
    I want to be able to sign in and log out from the site, without my raw password being sent to the site 
        
        Background:
		Given a user exists 

        Scenario: User logs in with correct details
                When I go to the sign in page
                And I fill in "test" for "username"
                And I fill in "testing" for "password"
                And I press "Sign in"
                Then I should be on the tasks page
                And I should see "Sign out"

        Scenario: User logs in with incorrect details
                When I go to the sign in page
                And I fill in "cucumber" for "username"
                And I fill in "wrongpassword" for "password"
                And I press "Sign in"
                Then I should be on the sign in page
                And I should see "Wrong Username/Email and password combination."

        Scenario: User logs out
                Given I am logged in
                When I press "Sign out"
                Then I should be on the sign in page
                And I should see "You have signed out."
