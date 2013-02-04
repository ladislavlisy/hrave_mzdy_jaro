class AmountMonthlyConcept < PayrollConcept
  attr_reader :amount_monthly

  def initialize(tag_code, values)
     super(:CONCEPT_AMOUNT_MONTHLY, :CONCEPT_AMOUNT_MONTHLY.id2name, tag_code)

     @amount_monthly = values[:amount_monthly]
  end

  def pending_codes
    [ ScheduleWorkTag.new ]
  end

  def summary_codes
    [
      IncomeGrossTag.new,
      IncomeNettoTag.new,
      InsuranceSocialBaseTag.new,
      InsuranceHealthBaseTag.new,
      IncomeTaxableTag.new
    ]
  end
end