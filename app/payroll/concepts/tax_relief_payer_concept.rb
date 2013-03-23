require_relative '../results/tax_relief_result'

class TaxReliefPayerConcept < PayrollConcept
  TAG_ADVANCE = PayTagGateway::REF_TAX_ADVANCE.code
  TAG_CLAIM_PAYER = PayTagGateway::REF_TAX_CLAIM_PAYER.code
  TAG_CLAIM_DISAB = PayTagGateway::REF_TAX_CLAIM_DISABILITY.code
  TAG_CLAIM_STUDY = PayTagGateway::REF_TAX_CLAIM_STUDYING.code

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
      TaxClaimPayerTag.new,
      TaxClaimDisabilityTag.new,
      TaxClaimStudyingTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    advance_base_value = get_result_by(results, TAG_ADVANCE)
    relief_claim_payer = get_result_by(results, TAG_CLAIM_PAYER)
    relief_claim_disab = get_result_by(results, TAG_CLAIM_DISAB)
    relief_claim_study = get_result_by(results, TAG_CLAIM_STUDY)

    tax_relief_value = 0
    tax_claims_value = relief_claim_payer.tax_relief +
                       relief_claim_disab.tax_relief +
                       relief_claim_study.tax_relief
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
