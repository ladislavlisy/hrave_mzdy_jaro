Feature:
  In order to inform employees about payroll
  As a payroll accountant
  I want to send payslips by email

  Scenario: Send email with payslip to employee
    Given Payroll process for payroll period 01 2013
    And   Employee works in this period
    When  I Send payslip
    Then  I should see email with subject "Hrave Mzdy - effortlessly, promptly, clearly Ltd."
        