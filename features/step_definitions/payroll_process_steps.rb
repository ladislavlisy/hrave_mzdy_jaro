CAPTURE_MONEY = Transform /^(CZK) (\d+)$/ do |currency_symbol, money|
  money.to_i
end

CAPTURE_HOURS = Transform /^(\d+)$/ do |hours|
  hours.to_i
end

CAPTURE_COUNT = Transform /^(\d+)$/ do |count|
  count.to_i
end

CAPTURE_BOOL = Transform /^(YES|NO)$/ do |flag|
  if flag=='YES'
    1
  else
    0
  end
end

CAPTURE_TAXES = Transform /^(DECLARE|YES|NO)$/ do |flag|
  if flag=='DECLARE'
    3
  elsif flag=='YES'
    1
  else
    0
  end
end

CAPTURE_3BOOL = Transform /^(YES|NO)\:(YES|NO)\:(YES|NO)$/ do |flag1, flag2, flag3|
  flags = 0
  if flag1=='YES'
    flags += 1
  end
  if flag2=='YES'
    flags += 10
  end
  if flag3=='YES'
    flags += 100
  end
  flags
end

module PayrollProcessTest
  def my_payroll_period
    @my_payroll_period  ||= FactoryGirl.build(:periodJan2013)
  end

  def my_payroll_process
    @my_payroll_process ||= init_payroll_process(my_payroll_period)
  end

  def init_payroll_process(period)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, period)
    return payroll_process
  end

  def calculate_payroll_process
    empty_value = {}
    gross_tag = @my_payroll_process.add_term(PayTagGateway::REF_INCOME_GROSS, empty_value)
    netto_tag = @my_payroll_process.add_term(PayTagGateway::REF_INCOME_NETTO, empty_value)
    @my_payroll_process.evaluate(netto_tag)
  end

  def get_result_income_base(result_ref)
    results = @my_payroll_process.get_results

    result_select = results.select do |key, _|
      key.code == result_ref.code
    end
    result_value = result_select.inject (0)  do |agr, item|
      agr + item.last.income_base
    end
  end

  def get_result_employee_base(result_ref)
    results = @my_payroll_process.get_results

    result_select = results.select do |key, _|
      key.code == result_ref.code
    end
    result_value = result_select.inject (0)  do |agr, item|
      agr + item.last.employee_base
    end
  end

  def get_result_payment(result_ref)
    results = @my_payroll_process.get_results

    result_select = results.select do |key, _|
      key.code == result_ref.code
    end
    result_value = result_select.inject (0)  do |agr, item|
      agr + item.last.payment
    end
  end

  def get_result_tax_relief(result_ref)
    results = @my_payroll_process.get_results

    result_select = results.select do |key, _|
      key.code == result_ref.code
    end
    result_value = result_select.inject (0)  do |agr, item|
      agr + item.last.tax_relief
    end
  end

  def get_result_after_reliefA(result_ref)
    results = @my_payroll_process.get_results

    result_select = results.select do |key, _|
      key.code == result_ref.code
    end
    result_value = result_select.inject (0)  do |agr, item|
      agr + item.last.after_reliefA
    end
  end

  def get_result_after_reliefC(result_ref)
    results = @my_payroll_process.get_results

    result_select = results.select do |key, _|
      key.code == result_ref.code
    end
    result_value = result_select.inject (0)  do |agr, item|
      agr + item.last.after_reliefC
    end
  end

  def get_result_amount(result_ref)
    results = @my_payroll_process.get_results

    result_select = results.select do |key, _|
      key.code == result_ref.code
    end
    result_value = result_select.inject (0)  do |agr, item|
      agr + item.last.amount
    end
  end
end
World(PayrollProcessTest)

Given /^Payroll process for payroll period (\d+) (\d+)$/ do |arg1, arg2|
  my_payroll_process
end

And /^Employee works in Weekly schedule (#{CAPTURE_HOURS}) hours$/ do |hours|
  schedule_work_value = {hours_weekly: hours}
  schedule_term_value = {date_from: nil, date_end: nil}

  my_payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
  my_payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
end

And /^Employee has (#{CAPTURE_HOURS}) hours of absence$/ do |hours|
  absence_hours_value = {hours: hours}
  my_payroll_process.add_term(PayTagGateway::REF_HOURS_ABSENCE, absence_hours_value)
end

And /^Employee Salary is (#{CAPTURE_MONEY}) monthly$/ do |salary|
  salary_amount_value = {amount_monthly: salary}
  my_payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
end

And /^Employee Contract is (#{CAPTURE_MONEY}) monthly$/ do |contract|
  pending # express the regexp above with the code you wish you had
end

And /^(#{CAPTURE_TAXES}) Employee is Regular Tax payer$/ do |yes_no|
  tax_interest = yes_no!=0 ? 1 : 0
  tax_declare  = yes_no==3 ? 1 : 0
  interest_value = {interest_code: tax_interest, declare_code: tax_declare}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_INCOME_BASE, interest_value)
end

And /^(#{CAPTURE_BOOL}) Employee is Regular Health insurance payer with (#{CAPTURE_BOOL})$/ do |yes_no, minim|
  interest_value = {interest_code: yes_no, minimum_asses: minim}
  my_payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH_BASE, interest_value)
  my_payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH, interest_value)
end

And /^(#{CAPTURE_BOOL}) Employee is Regular Social insurance payer$/ do |yes_no|
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL_BASE, interest_value)
  my_payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL, interest_value)
end

And /^(#{CAPTURE_BOOL}) Employee is Regular Pension savings payer$/ do |yes_no|
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_SAVINGS_PENSIONS, interest_value)
end

And /^(#{CAPTURE_BOOL}) Employee claims tax benefit on tax payer$/ do |yes_no|
  relief_value = {relief_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_value)
end

And /^Employee claims tax benefit on (#{CAPTURE_COUNT}) child$/ do |count|
  relief_value = {relief_code: 1}
  count.times do
    my_payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_value)
  end
end

And /^(#{CAPTURE_3BOOL}) Employee claims tax benefit on disability$/ do |yes_no|
  relief_value = {
      relief_code_1: (yes_no % 10),
      relief_code_2: ((yes_no/10) % 10),
      relief_code_3: ((yes_no/100) % 10)
  }
  my_payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_DISABILITY, relief_value)
end

And /^(#{CAPTURE_BOOL}) Employee claims tax benefit on preparing by studying$/ do |yes_no|
  relief_value = {relief_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_STUDYING, relief_value)
end

And /^(#{CAPTURE_BOOL}) Employee is Employer contribution for Health insurance payer$/ do |yes_no|
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH, interest_value)
end

And /^(#{CAPTURE_BOOL}) Employee is Employer contribution for Social insurance payer$/ do |yes_no|
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL, interest_value)
end

When /^Payroll process calculate results$/ do
  calculate_payroll_process
end

Then /^Accounted tax income should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_income_base(PayTagGateway::REF_TAX_INCOME_BASE)
  result_value.should == amount
end

And /^Premium insurance should be (#{CAPTURE_MONEY})$/ do |amount|
  result_health = get_result_payment(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH)
  result_social = get_result_payment(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL)
  result_value = result_health + result_social
  result_value.should == amount
end

And /^Tax base should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_income_base(PayTagGateway::REF_TAX_ADVANCE_BASE)
  result_value.should == amount
end

And /^Accounted income for Health insurance should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_employee_base(PayTagGateway::REF_INSURANCE_HEALTH_BASE)
  result_value.should == amount
end

And /^Accounted income for Social insurance should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_employee_base(PayTagGateway::REF_INSURANCE_SOCIAL_BASE)
  result_value.should == amount
end

And /^Contribution to Health insurance should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_payment(PayTagGateway::REF_INSURANCE_HEALTH)
  result_value.should == amount
end

And /^Contribution to Social insurance should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_payment(PayTagGateway::REF_INSURANCE_SOCIAL)
  result_value.should == amount
end

And /^Tax advance before tax relief on payer should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_payment(PayTagGateway::REF_TAX_ADVANCE)
  result_value.should == amount
end

And /^Tax relief on payer should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_tax_relief(PayTagGateway::REF_TAX_RELIEF_PAYER)
  result_value.should == amount
end

And /^Tax advance after relief on payer should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_after_reliefA(PayTagGateway::REF_TAX_ADVANCE_FINAL)
  result_value.should == amount
end

And /^Tax relief on child should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_tax_relief(PayTagGateway::REF_TAX_RELIEF_CHILD)
  result_value.should == amount
end

And /^Tax advance after relief on child should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_after_reliefC(PayTagGateway::REF_TAX_ADVANCE_FINAL)
  result_value.should == amount
end

And /^Tax advance should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_payment(PayTagGateway::REF_TAX_ADVANCE_FINAL)
  result_value.should == amount
end

And /^Tax bonus should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_payment(PayTagGateway::REF_TAX_BONUS_CHILD)
  result_value.should == amount
end

And /^Gross income should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_amount(PayTagGateway::REF_INCOME_GROSS)
  result_value.should == amount
end

And /^Netto income should be (#{CAPTURE_MONEY})$/ do |amount|
  result_value = get_result_amount(PayTagGateway::REF_INCOME_NETTO)
  result_value.should == amount
end

And /^Employee works in employment with:$/ do |specs_table|
  # table is a Cucumber::Ast::Table
  @payroll_specs = specs_table
  absence_hours_value = {hours: hours}
  my_payroll_process.add_term(PayTagGateway::REF_HOURS_ABSENCE, absence_hours_value)
  salary_amount_value = {amount_monthly: salary}
  my_payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_INCOME_BASE, interest_value)
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH_BASE, interest_value)
  my_payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH, interest_value)
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL_BASE, interest_value)
  my_payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL, interest_value)
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_SAVINGS_PENSIONS, interest_value)
  relief_value = {relief_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_value)
  relief_value = {relief_code: (count if yes_no==1)}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_value)
  relief_value = {relief_code: yes_no.mod(10)}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_DISABILITY, relief_value)
  relief_value = {relief_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_STUDYING, relief_value)
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH, interest_value)
  interest_value = {interest_code: yes_no}
  my_payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL, interest_value)
end

Then /^Payroll results should be:$/ do |result_table|
  # table is a Cucumber::Ast::Table
end

