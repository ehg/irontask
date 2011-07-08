Feature: Secure access to the site
    In order to access my task list securely
    I want to be able to sign in and log out from the site, without my raw password being sent to the site 
        
        Background:
                Given I have a User account
        
        Scenario: User logs in with correct details
                When I go to the sign in page
                And I fill in "cucumber" in "username"
                And I fill in "password" in "password"
                And I press "Sign in"
                Then my password should not be sent in plain text
                And I should be logged in
                And I should be on the tasks page
                And I should see "Sign out"

        Scenario: User logs in with incorrect details
                When I go to the sign in page
                And I fill in "cucumber" in "username"
                And I fill in "wrongpassword" in "password"
                And I press "Sign in"
                Then my password should not be sent in plain text
                And I should not be logged in
                And I should be on the sign in page
                And I should see "Unrecognised user name/password!"

        Scenario: User logs out
                Given I am logged in
                When I press "Sign out"
                Then I should not be logged in
                And I should be on the sign in page
                And I should see "You have signed out."