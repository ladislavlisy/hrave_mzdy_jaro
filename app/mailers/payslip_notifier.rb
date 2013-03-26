class PayslipNotifier < ActionMailer::Base
  default from: "hrave.mzdy@gmail.com"

  def send_payslip(to_email, tag_employee_name, tag_employer_name, tag_employee_numb)
    mail(:to => to_email, :subject => tag_employer_name)
  end
end
