require_relative '../results/payment_result'

class TaxBonusChildConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_TAX_INCOME_BASE.code
  TAG_ADVANCE = PayTagGateway::REF_TAX_ADVANCE.code
  TAG_RELIEF_PAYER = PayTagGateway::REF_TAX_RELIEF_PAYER.code
  TAG_RELIEF_CHILD = PayTagGateway::REF_TAX_RELIEF_CHILD.code
  TAG_CLAIMS_CHILD = PayTagGateway::REF_TAX_CLAIM_CHILD.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_BONUS_CHILD, tag_code)
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
      TaxReliefChildTag.new
    ]
  end

  def summary_codes
    [
      IncomeNettoTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_NETTO
  end

  def compute_result_value(year, is_tax_interest, advance_base_value, relief_payer_value, relief_child_value, relief_claim_value)
    if !is_tax_interest
      tax_advance_value = 0
    else
      relief_bonus_value = bonus_after_relief(advance_base_value,
                                              relief_payer_value,
                                              relief_child_value,
                                              relief_claim_value)
      tax_advance_value = max_min_bonus(year, relief_bonus_value)
    end
    tax_advance_value
  end

  def evaluate(period, tag_config, results)
    is_tax_interest = interest_result(results, TAG_AMOUNT_BASE)

    advance_base = payment_result(results, TAG_ADVANCE)
    relief_payer = tax_relief_result(results, TAG_RELIEF_PAYER)
    relief_child = tax_relief_result(results, TAG_RELIEF_CHILD)
    relief_claim = sum_relief_by(results, TAG_CLAIMS_CHILD)

    tax_advance_value = compute_result_value(period.year, is_tax_interest,
                                             advance_base, relief_payer,
                                             relief_child, relief_claim)

    result_values = {payment: tax_advance_value}

    PaymentResult.new(@tag_code, @code, self, result_values)
  end

  def sum_relief_by(results, pay_tag)
    result_hash = results.select { |key,_| key.code==pay_tag }
    result_suma = result_hash.inject (0)  do |agr, item|
      agr + item.last.tax_relief
    end
  end

  def bonus_after_relief(tax_advance, relief_payer, relief_child, claims_child)
    bonus_for_child = -[0, relief_child - claims_child].min
    if bonus_for_child >= 50
      return bonus_for_child
    else
      return 0
    end
  end

  def max_min_bonus(year, tax_child_bonus)
    if tax_child_bonus < min_bonus_monthly(year)
      0
    else
      max_bonus_value = max_bonus_monthly(year)
      if tax_child_bonus > max_bonus_value
          max_bonus_value
      else
        tax_child_bonus
      end
    end
  end

  def max_bonus_monthly(year)
    if year>=2012
      5025
    elsif year>=2009
      4350
    elsif year==2008
      4350
    elsif year>=2005
      2500
    else
      0
    end
  end

  def min_bonus_monthly(year)
    if year>=2005
      50
    else
      0
    end
  end
end

