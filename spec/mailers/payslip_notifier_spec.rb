require 'spec_helper'
require 'email_spec'

describe PayslipNotifier do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, period)
  end

  it 'Should create Email Payroll' do

    empty_value = {}
    tag_employee_numb = '00010'
    tag_employee_dept = 'IT crowd'
    tag_employee_name = 'Ladislav Lisy'
    tag_employer_name = 'Hrave Mzdy - effortlessly, promptly, clearly Ltd.'
    tag_employee_mail = 'ladislav.lisy@seznam.cz'

    PayslipNotifier.send_payslip(tag_employee_mail, tag_employee_name,
                                 tag_employer_name, tag_employee_numb)

    test_email = find_email!(tag_employee_mail)
    test_email.subject.should include(tag_employer_name)
  end
end
