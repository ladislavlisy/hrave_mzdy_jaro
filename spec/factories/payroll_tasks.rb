# spec/factories/payroll_tasks.rb
FactoryGirl.define do
  factory :payroll_period do
    factory :periodJan2013 do
      code 201301
      name "January 2013"
    end

    factory :periodNoName do
      code 201301
      name ""
    end
  end
end

FactoryGirl.define do
  factory :payroll_task do
    association :payroll_period, factory: :periodJan2013
    task_start { Time.now }
    task_end nil

    factory :task_example do
      description "Payroll task (January 2013)"
    end

    factory :task_empty do
      description ""
    end

  end
end
