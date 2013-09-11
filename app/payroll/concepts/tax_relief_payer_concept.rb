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

  def compute_result_value(advance_base, relief_value, claims_value)
    relief_amount(advance_base, relief_value, claims_value)
  end

  def evaluate(period, tag_config, results)
    tax_advance_value = tax_payment_result(results, TAG_ADVANCE)
    relief_claim_payer = tax_claim_result(results, TAG_CLAIM_PAYER)
    relief_claim_disab = tax_claim_result(results, TAG_CLAIM_DISAB)
    relief_claim_study = tax_claim_result(results, TAG_CLAIM_STUDY)

    tax_relief_value = 0
    tax_claims_value = relief_claim_payer + relief_claim_disab + relief_claim_study

    relief_value = compute_result_value(tax_advance_value, tax_relief_value, tax_claims_value)

    result_values = {tax_relief: relief_value}

    TaxReliefResult.new(@tag_code, @code, self, result_values)
  end

  def relief_amount(tax_advance, tax_relief, tax_claims)
    tax_after_relief = tax_advance - tax_relief
    tax_claims - [0, tax_claims - tax_after_relief].max
  end
end
