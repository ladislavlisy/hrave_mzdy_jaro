# spec/factories/payroll_tasks.rb
FactoryGirl.define do
  factory :payroll_period do
    factory :periodJan2013 do
      code 201301
      name 'January 2013'
    end

    factory :periodNoName do
      code 201301
      name ''
    end
  end
end

FactoryGirl.define do
  factory :payroll_task do
    association :payroll_period, factory: :periodJan2013
    task_start { Time.now }
    task_end nil

    factory :task_example do
      description 'Payroll task (January 2013)'
      company_name 'Payroll The Game'
      payrolee_name 'Ladislav Lisy'
      employee_name 'Novakova Lucie'
      employer_name 'Jana Stefanikova'
      employee_numb '00010'
      department 'IT crowd'
      empl_salary 150000
      tax_declare true
      tax_payer true
      tax_study false
      tax_disab1 false
      tax_disab2 false
      tax_disab3 false
      tax_child1 false
      tax_child2 false
      tax_child3 false
      tax_child4 false
      tax_child5 false
      ins_health true
      ins_social true
      min_health true
    end

    factory :task_empty do
      description ''
    end

  end
end
