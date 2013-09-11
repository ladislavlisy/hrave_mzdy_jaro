require_relative '../results/tax_relief_result'

class TaxReliefChildConcept < PayrollConcept
  TAG_ADVANCE = PayTagGateway::REF_TAX_ADVANCE.code
  TAG_RELIEF_PAYER = PayTagGateway::REF_TAX_RELIEF_PAYER.code
  TAG_CLAIM_BASE = PayTagGateway::REF_TAX_CLAIM_CHILD.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_RELIEF_CHILD, tag_code)
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
      TaxClaimChildTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_NETTO
  end

  def compute_result_value(advance_base, relief_value, claims_value)
    relief_amount(advance_base, relief_value, claims_value)
  end

  def evaluate(period, tag_config, results)
    tax_advance = tax_payment_result(results, TAG_ADVANCE)
    tax_relief = tax_relief_result(results, TAG_RELIEF_PAYER)
    relief_claim = sum_relief_by(results, TAG_CLAIM_BASE)

    relief_value = compute_result_value(tax_advance, tax_relief, relief_claim)

    result_values = {tax_relief: relief_value}

    TaxReliefResult.new(@tag_code, @code, self, result_values)
  end

  def sum_relief_by(results, pay_tag)
    result_hash = results.select { |key,_| key.code==pay_tag }
    result_suma = result_hash.inject (0)  do |agr, item|
      agr + item.last.tax_relief
    end
  end

  def relief_amount(tax_advance, tax_relief, tax_claims)
    tax_after_relief = tax_advance - tax_relief
    tax_claims - [0, tax_claims - tax_after_relief].max
  end
end
