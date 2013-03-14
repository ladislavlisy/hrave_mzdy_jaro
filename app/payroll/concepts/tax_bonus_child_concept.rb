class TaxBonusChildConcept < PayrollConcept
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
    CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    advance_base_value = get_result_by(results, TAG_ADVANCE)
    relief_payer_value = get_result_by(results, TAG_RELIEF_PAYER)
    relief_child_value = get_result_by(results, TAG_RELIEF_CHILD)
    claims_child_value = get_result_by(results, TAG_CLAIMS_CHILD)

    tax_advance_value = bonus_after_relief(advance_base_value.payment,
                                relief_payer_value.tax_relief,
                                relief_child_value.tax_relief,
                                claims_child_value.tax_relief)

    TaxBonusChildResult.new(@tag_code, @code, self, {payment: tax_advance_value})
  end

  def bonus_after_relief(tax_advance, relief_payer, relief_child, claims_child)
    bonus_for_child = -[0, relief_child - claims_child].min
    if bonus_for_child >= 50
      return bonus_for_child
    else
      return 0
    end
  end
end
