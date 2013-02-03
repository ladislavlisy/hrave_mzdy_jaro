class AmountMonthlyConcept < PayrollConcept
  attr_reader :amount_monthly

  def initialize(values)
     super(:CONCEPT_AMOUNT_MONTHLY, :CONCEPT_AMOUNT_MONTHLY.id2name)

     @amount_monthly = values[:amount_monthly]
  end

  def pending_codes
    [ ScheduleWorkTag.new ]
  end
end