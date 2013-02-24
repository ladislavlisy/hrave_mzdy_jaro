class SalaryBaseTag < PayrollTag
  def initialize
    super(SalaryBaseTagRefer.new,
          CodeNameRefer.new(:CONCEPT_SALARY_MONTHLY, :CONCEPT_SALARY_MONTHLY.id2name))
  end
end