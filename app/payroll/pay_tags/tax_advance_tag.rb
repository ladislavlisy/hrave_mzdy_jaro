# Specification: Tax Advance

class TaxAdvanceTag < PayrollTag
  def initialize
    super(:TAG_TAX_ADVANCE, :TAG_TAX_ADVANCE.id2name,
          CodeNameRefer.new(:CONCEPT_TAX_ADVANCE, :CONCEPT_TAX_ADVANCE.id2name))

  end

end