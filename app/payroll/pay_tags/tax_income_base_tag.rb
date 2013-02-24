# Specification: Taxable Income

class TaxIncomeBaseTag < PayrollTag
  def initialize
    super(TaxIncomeBaseTagRefer.new,
          CodeNameRefer.new(:CONCEPT_TAX_INCOME_BASE, :CONCEPT_TAX_INCOME_BASE.id2name))

  end
end