class SalaryMonthlyConcept < PayrollConcept
  attr_reader :amount_monthly

  def initialize(tag_code, values)
     super(:CONCEPT_SALARY_MONTHLY, :CONCEPT_SALARY_MONTHLY.id2name, tag_code)

     @amount_monthly = values[:amount_monthly]
  end

  def pending_codes
    [
      HoursWorkingTag.new,
      HoursAbsenceTag.new
    ]
  end

  def summary_codes
    [
      IncomeGrossTag.new,
      IncomeNettoTag.new,
      InsuranceSocialBaseTag.new,
      InsuranceHealthBaseTag.new,
      TaxIncomeBaseTag.new
    ]
  end
end