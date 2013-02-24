# Specification: Gross Income

class IncomeGrossTag < PayrollTag
  def initialize
    super(IncomeGrossTagRefer.new,
          CodeNameRefer.new(:CONCEPT_INCOME_GROSS, :CONCEPT_INCOME_GROSS.id2name))

  end
end