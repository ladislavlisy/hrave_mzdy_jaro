class SalaryBaseTag < PayrollTag
  def initialize
    super(:TAG_SALARY_BASE, :TAG_SALARY_BASE.id2name,
          CodeNameRefer.new(:CONCEPT_SALARY_MONTHLY, :CONCEPT_SALARY_MONTHLY.id2name))
  end
end