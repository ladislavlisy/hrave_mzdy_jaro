Feature:
  In order to check payroll calculation
  As a payroll user
  I want to test payroll 50 examples

  Scenario: Payroll for employment
    Given Payroll process for payroll period 01 2013
    And   Employee works in Weekly schedule 40 hours
    And   Employee has 0 hours of absence
    And   Employee Salary is CZK 15000 monthly
    And   Employee is Regular Tax payer
    And   Employee is Regular Health insurance payer
    And   Employee is Regular Social insurance payer
    And   Employee is not Regular Pension savings payer
    And   Employee claims tax benefit on tax payer
    And   Employee claims no tax benefit on child
    And   Employee claims no tax benefit on disability 1
    And   Employee claims no tax benefit on disability 2
    And   Employee claims no tax benefit on disability 3
    And   Employee claims no tax benefit on preparing by studying
    And   Employee is Employer contribution for Health insurance payer
    And   Employee is Employer contribution for Social insurance payer
    When  Payroll process calculate results
    Then  Accounted tax income should be CZK 15000
    And   Premium insurance should be CZK 5100
    And   Tax base should be CZK 20100
    And   Accounted income for Health insurance should be CZK 15000
    And   Accounted income for Social insurance should be CZK 15000
    And   Contribution to Health insurance should be CZK 675
    And   Contribution to Social insurance should be CZK 975
    And   Tax advance before tax relief on payer should be CZK 3015
    And   Tax relief on payer should be CZK 2070
    And   Tax advance after relief on payer should be CZK 945
    And   Tax relief on child should be CZK 0
    And   Tax advance after relief on child should be CZK 945
    And   Tax advance should be CZK 945
    And   Tax bonus should be CZK 0
    And   Gross income should be CZK 15000
    And   Netto income should be CZK 12405