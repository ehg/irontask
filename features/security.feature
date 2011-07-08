Feature: Data is secure in the cloud
    In order to keep my tasks private and secure
    I want to be the only person who can read them

          
            Background:
                    Given a User exists
                    And the User has Tasks stored

            Scenario: A user without the key tries to view a task
                    Given a User's Task
                    Then I should not see "tasks" 
    
            Scenario: A user with the key tries to view a task
                    Given a User's Task
                    When I decrypt my tasks with "key"
                    Then I should see "tasks" in my tasks