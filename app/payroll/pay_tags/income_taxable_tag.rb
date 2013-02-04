# Specification: Taxable Income

class IncomeTaxableTag < PayrollTag
  def initialize
    super(:TAG_INCOME_TAXABLE, :TAG_INCOME_TAXABLE.id2name,
          CodeNameRefer.new(:CONCEPT_INCOME_TAXABLE, :CONCEPT_INCOME_TAXABLE.id2name))

  end
end