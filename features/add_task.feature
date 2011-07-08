Feature: User can enter a new task
    In order to make a note of something I've got to do
    I want to be able to create a new task and specify when it is due. I want to specify the date by a normal format, such as "10/10/12" or by using the day of the week, "next week", "next month" or "next year"

            Background:
                    Given I have a User account
                    And I am logged in
                    And I have tasks stored
                    And I am on the tasks page
                    And the current date is "08/07/11"

            Scenario: A task is entered with no due date and one context selected
                    When I select the "Home" context
                    And I enter "Do gardening" in "newtask"
                    Then I should see "Do gardening"
                    And "Do gardening" should be saved in the "Home" context

            Scenario: A task is entered with no due date and three contexts selected
                    When I select the "Home" context
                    And I select the "Work" context
                    And I enter "Make tea" in "newtask"
                    Then I should see "Make tea"
                    And "Make tea" should be saved in the "Home" context 
                    And "Make tea" should be saved in the "Work" context 

            Scenario: A UK format date is specified for a task
                     When I select the "Home" context
                    And I enter "Do gardening for 12/07/11" in "newtask"
                    Then I should see "Do gardening"
                    And I should see "12/07/11"
                    And "Do gardening" should be saved in the "Home" context
                    And "Do gardening" should be saved with the date "12/07/11"
           

            Scenario: The task's date is automatically detected
                    When I select the "Home" context
                    And I enter "Do gardening for tomorrow" in "newtask"
                    Then I should see "Do gardening"
                    And I should see "09/07/11"
                    And "Do gardening" should be saved in the "Home" context
                    And "Do gardening" should be saved with the date "09/07/11"
                    
            Scenario: The task's recurrence is automatically detected
                    When I select the "Home" context
                    And I enter "Do gardening for tomorrow every week" in "newtask"
                    Then I should see "Do gardening"
                    And I should see "09/07/11"
                    And "Do gardening" should be saved in the "Home" context
                    And "Do gardening" should be saved with the date "09/07/11"
                    And "Do gardening" should recur "weekly"