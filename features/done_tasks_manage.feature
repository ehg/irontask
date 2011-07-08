Feature: Done tasks can be viewed and managed
    In order to keep track of my completed tasks and undo any mistakes
    I want to be able to see a list of tasks marked as done and "undo" a task
 
            Background:
                    Given I have a User account
                    And I am logged in
                    And I have tasks stored
                    And the current date is "08/07/11"
                        
            Scenario: A list of done tasks is shown
                    Given I am on the tasks page
                    When I click the "See done tasks" link
                    Then I should be on the done tasks page
                    And I should see the following tasks:
                       | Task                           | Date     |
                       | A completed task  (Home)       | 29/02/11 |
                       | Another completed task  (Work) | 29/06/11 |

            Scenario: A task is "undone"
                    Given I am on the done tasks page
                    When I click "undo" for "A completed task"
                    Then the task "A completed" task should not be saved as done
                    And I should see "You've just undone this task!"
