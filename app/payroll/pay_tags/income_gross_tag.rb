# Specification: Gross Income

class IncomeGrossTag < PayrollTag
  def initialize
    super(:TAG_INCOME_GROSS, :TAG_INCOME_GROSS.id2name,
          CodeNameRefer.new(:CONCEPT_INCOME_GROSS, :CONCEPT_INCOME_GROSS.id2name))

  end
end