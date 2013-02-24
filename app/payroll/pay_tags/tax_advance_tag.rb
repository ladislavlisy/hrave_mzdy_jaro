# Specification: Tax Advance

class TaxAdvanceTag < PayrollTag
  def initialize
    super(TaxAdvanceTagRefer.new,
          CodeNameRefer.new(:CONCEPT_TAX_ADVANCE, :CONCEPT_TAX_ADVANCE.id2name))

  end

end