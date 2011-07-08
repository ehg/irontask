Feature: Management of tasks
    In order to see what tasks I have to do and when
    I want to be able to view a list of my tasks.  I also want to be able to mark tasks as done, put off, modify and delete existing tasks. I also want to be able to set a task to recur.
            
            Background:
                    Given I have a User account
                    And I am logged in
                    And I have tasks stored
                    And I am on the tasks page
                    And the current date is "08/07/11"
            
            Scenario: A list of tasks is shown with one context selected
                    When I select the "Home" context
                    Then I should see the following tasks:
                        | Task                          | Date      |
                        | Buy cheese and milk and bread | Yesterday |
                        | Tidy up room                  | Today     |
                        | Do laundry                    | Thursday  |
                        | Pay credit card bill          | 29/12/11  |
                    And "Yesterday" should be underlined
                    And "Yesterday" should be bold
                    And "Today" should be bold 
   
            
            Scenario: A list of tasks is shown with three contexts selected
                    When I select the "Home" context
                    And I select the "Work" context
                    Then I should see the following tasks:
                        | Task                          | Date      |
                        | Buy cheese and milk and bread | Yesterday |
                        | Tidy up room                  | Today     |
                        | Write cucumber features       | Today     |
                        | Do laundry                    | Thursday  |
                        | Pay credit card bill          | 29/07/11  |
                        | Sort Github repos             | 29/12/11  |
                    And "Yesterday" should be underlined
                    And "Yesterday" should be bold
                    And "Today" should be bold 
 
            Scenario: A task is marked as done
                    When I select the "Home" context
                    And I mark "Do laundry" as done
                    Then I should not see "Do laundry"
                    And "Do laundry" should be saved as done

            Scenario: A task is put off
                    When I select the "Home" context
                    And I put off "Do laundry"
                    Then I should see "Friday"
                    And "Do laundry" should have the date "14/07/11" saved

            Scenario: A task's date is modified
                    When I select the "Home" context
                    And I press "29/07/11"
                    And I enter "29/08/11"
                    And I press return
                    Then "Pay credit card bill" should have the date "29/08/11"
                    And "Pay credit card bill" should have the date "29/08/11" saved
                    

            Scenario: A task is deleted
                    When I select the "Home" context
                    And I drag the "Do laundry" task to the bin
                    Then I should not see "Do laundry"
                    And "Do laundry" should not exist
                    
            Scenario: A user specifies a daily recurrency
                    When I select the "Home" context
                    And I press "29/07/11"
                    And I click the "recur" button
                    And I select "weekly"
                    And I click the "OK" button
                    Then "Pay credit card bill" should have an enabled recurs icon
                    And "Pay credit card bill" should be saved as a recurrent task
     
            Scenario: A user specifies a task not to recur
                    When I select the "Home" context
                    And I press "29/07/11"
                    And I click the "recur" button
                    And I select "don't recur"
                    And I click the "OK" button
                    Then "Pay credit card bill" should have a disabled recurs icon
                    And "Pay credit card bill" should not be a recurrent task
