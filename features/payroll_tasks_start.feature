Feature: Start a new payroll task
  In order to get results from payroll task
  As a payroll accountant
  I want to start a new payroll task

  Scenario: "can get to start page of payroll task"
    Given I am on "the homepage"
    When I follow "Start payroll task"
    Then I should see title "Start a new payroll task"

  Scenario: "can dispatch specification of payroll task"
    Given I am on "the homepage"
    When I follow "Start payroll task"
    And I select "January 2013" from "Payroll period"
    And I fill im "Description" with "Payroll Task 1"
    And I submit "Calculate payroll"
    Then I should see title "Payroll task - Get results"
