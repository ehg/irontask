Feature: Sign up
    In order to use the site
    I want to be able to enter a username and password and be registered with the site, without having to enter any details that would compromise my anonymity
    
    Scenario: User signs up with a username and strong password
                When I go to the sign up page
                And I fill in "Username" with "jackbauer"
                And I fill in "Password" with "Ve4yStr0ngPa55w0rd!43sdfs"
                And I fill in "Confirm password" with "Ve4yStr0ngPa55w0rd!43sdfs"
                And I press "Sign up"
                Then I should see "Thanks! You've signed up."

        Scenario: User signs up with a username and weak password
                When I go to the sign up page
                And I fill in "Username" with "jackbauer"
                And I fill in "Password" with "weak"
                And I fill in "Confirm password" with "weak"
                And I press "Sign up"
                Then I should see "That password isn't very strong."

        Scenario: User signs up with an empty username and password
                When I go to the sign up page
                And I fill in "Username" with ""
                And I fill in "Password" with ""
                And I fill in "Confirm password" with ""
                And I press "Sign up"
                Then I should see "You need to enter a password."

