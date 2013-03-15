class TaxReliefStudyingConcept < PayrollConcept
  TAG_ADVANCE = PayTagGateway::REF_TAX_ADVANCE.code
  TAG_RELIEF_PAYER = PayTagGateway::REF_TAX_RELIEF_PAYER.code
  TAG_RELIEF_DISABILITY = PayTagGateway::REF_TAX_RELIEF_DISABILITY.code
  TAG_CLAIM_BASE = PayTagGateway::REF_TAX_CLAIM_STUDYING.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_RELIEF_STUDYING, tag_code)
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
      TaxReliefPayerTag.new,
      TaxReliefDisabilityTag.new,
      TaxClaimStudyingTag.new
    ]
  end

  def calc_category
    CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    advance_base_value = get_result_by(results, TAG_ADVANCE)
    relief_claim_value = get_result_by(results, TAG_CLAIM_BASE)
    relief_payer_value = get_result_by(results, TAG_RELIEF_PAYER)
    relief_disab_value = get_result_by(results, TAG_RELIEF_DISABILITY)

    tax_relief_value = relief_payer_value.tax_relief +
                       relief_disab_value.tax_relief
    tax_claims_value = relief_claim_value.tax_relief

    relief_value = relief_amount(advance_base_value.payment,
                                 tax_relief_value,
                                 tax_claims_value)

    TaxReliefResult.new(@tag_code, @code, self, {tax_relief: relief_value})
  end

  def relief_amount(tax_advance, tax_relief, tax_claims)
    tax_after_relief = tax_advance - tax_relief
    tax_claims - [0, tax_claims - tax_after_relief].max
  end
end
