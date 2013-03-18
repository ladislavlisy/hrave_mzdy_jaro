class IncomeBaseResult < PayrollResult
  attr_reader :income_base
  attr_reader :employee_base
  attr_reader :employer_base

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @income_base = values[:income_base] || 0
    @employee_base = values[:employee_base] || 0
    @employer_base = values[:employer_base] || 0
    @interest_code = values[:interest_code] || 0
    @minimum_asses = values[:minimum_asses] || 0
    @declare_code  = values[:declare_code] || 0
  end

  def interest?
    @interest_code!=0
  end

  def declared?
    @declare_code!=0
  end

  def minimum_assessment?
    @minimum_asses!=0
  end
end