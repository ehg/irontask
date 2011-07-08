Feature: Contexts can be created and managed
    In order to organise tasks based on different contexts
    I want to be able to add, delete and edit the name of different contexts
            
            Scenario: Initially the first context is selected
                    Given I am a new user
                    And I am logged in
                    When I am on the tasks page
                    Then I should see "Home" context selected
                    And I should not see the "Work" context selected
            
            Scenario: The user's previously selected contexts are selected
                    Given I am a user
                    And I am logged in
                    When I am on the tasks page
                    And I select the "Work" context
                    And I select the "New Jersey" context
                    And I sign out
                    And I sign in
                    And I am on the tasks page
                    Then I should see the "Work" context selected
                    And I should see the "New Jersey" context selected
            
            Scenario: Home and Work are default contexts
                    Given I am a new user
                    And I am logged in
                    When I am on the tasks page
                    Then I should see the "Home" context
                    And I should see the "Work" context
            
            Scenario: A context is added
                    Given I am a user
                    And I am logged in
                    When I am on the tasks page
                    And I click the "Add context" button
                    Then I should see a "New context" context
                    And the "New context" context should be selected
                    When I enter "Boom" in the "New context" context
                    Then the "Boom" context should be saved
                    And I should see the "Boom" context

            Scenario: A context's name is changed
                    Given I am a user
                    And I am logged in
                    When I am on the tasks page
                    And I click the "Edit contexts" button
                    Then I should see "Home" become editable
                    And I should see "Work" become editable
                    And I should see "New Jersey" become editable
                    When I enter "NJ" in the "New Jersey" context
                    And I click the "Save context" button
                    Then the "NJ" context should be saved
                    And I should see the "NJ" context

            Scenario: A context is deleted
                    Given I am a user
                    And I am logged in
                    When I am on the tasks page
                    And I drag the "Work" context to the bin
                    Then the "Work" context should not exist
                    And I should not see the "Work" context