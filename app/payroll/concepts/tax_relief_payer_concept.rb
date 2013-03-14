class TaxReliefPayerConcept < PayrollConcept
  TAG_ADVANCE = PayTagGateway::REF_TAX_ADVANCE.code
  TAG_CLAIM_BASE = PayTagGateway::REF_TAX_CLAIM_PAYER.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_RELIEF_PAYER, tag_code)
    init_values(values)
  end

  def init_values(values)
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def pending_codes
    [
      TaxAdvanceTag.new,
      TaxClaimPayerTag.new
    ]
  end

  def calc_category
    CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    advance_base_value = get_result_by(results, TAG_ADVANCE)
    relief_claim_value = get_result_by(results, TAG_CLAIM_BASE)
    relief_value = relief_amount(advance_base_value.payment,
                                relief_claim_value.tax_relief)

    TaxReliefPayerResult.new(@tag_code, @code, self, {tax_relief: relief_value})
  end

  def relief_amount(tax_advance, tax_claims)
    tax_claims - [0, tax_claims - tax_advance].max
  end
end
