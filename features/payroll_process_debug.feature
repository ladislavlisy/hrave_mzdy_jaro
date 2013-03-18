Feature:
  In order to check payroll calculation
  As a payroll user
  I want to test payroll with 50 examples in table

  Scenario Outline: Payroll for employment in table
    Given Payroll process for payroll period <period>
    And   Employee works in Weekly schedule <schedule> hours
    And   Employee has <absence> hours of absence
    And   Employee Salary is <salary> monthly
    And   <tax payer> Employee is Regular Tax payer
    And   <health payer> Employee is Regular Health insurance payer with <health minim>
    And   <social payer> Employee is Regular Social insurance payer
    And   <pension payer> Employee is Regular Pension savings payer
    And   <tax payer benefit> Employee claims tax benefit on tax payer
    And   Employee claims tax benefit on <tax child benefit> child
    And   <tax disability benefit> Employee claims tax benefit on disability
    And   <tax studying benefit> Employee claims tax benefit on preparing by studying
    And   <health employer> Employee is Employer contribution for Health insurance payer
    And   <social employer> Employee is Employer contribution for Social insurance payer
    When  Payroll process calculate results
    Then  Accounted tax income should be <tax income>
    And   Premium insurance should be <premium insurance>
    And   Tax base should be <tax base>
    And   Accounted income for Health insurance should be <health base>
    And   Accounted income for Social insurance should be <social base>
    And   Contribution to Health insurance should be <health ins>
    And   Contribution to Social insurance should be <social ins>
    And   Tax advance before tax relief on payer should be <tax before>
    And   Tax relief on payer should be <payer relief>
    And   Tax advance after relief on payer should be <tax after A relief>
    And   Tax relief on child should be <child relief>
    And   Tax advance after relief on child should be <tax after C relief>
    And   Tax advance should be <tax advance>
    And   Tax bonus should be <tax bonus>
    And   Gross income should be <gross income>
    And   Netto income should be <netto income>
  Examples:
    | period  | schedule | absence | salary       | tax payer | health payer | health minim | social payer | pension payer | tax payer benefit | tax child benefit | tax disability benefit | tax studying benefit | health employer | social employer | tax income   | premium insurance | tax base     | health base  | social base  | health ins | social ins | tax before | payer relief | tax after A relief | child relief | tax after C relief | tax advance | tax bonus | gross income | netto income |
    | 01 2013 | 40       | 0       | CZK 5000     | YES       | YES          | YES          | YES          | NO            | NO                | 0                 | NO:NO:NO               | NO                   | YES             | YES             | CZK 5000     | CZK 1700          | CZK 0        | CZK 8000     | CZK 5000     | CZK 630    | CZK 325    | CZK 0      | CZK 0        | CZK 0              | CZK 0        | CZK 0              | CZK 0       | CZK 0     | CZK 5000     | CZK 3040     |
