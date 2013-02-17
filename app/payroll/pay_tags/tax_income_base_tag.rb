# Specification: Taxable Income

class TaxIncomeBaseTag < PayrollTag
  def initialize
    super(:TAG_TAX_INCOME_BASE, :TAG_TAX_INCOME_BASE.id2name,
          CodeNameRefer.new(:CONCEPT_TAX_INCOME_BASE, :CONCEPT_TAX_INCOME_BASE.id2name))

  end
end