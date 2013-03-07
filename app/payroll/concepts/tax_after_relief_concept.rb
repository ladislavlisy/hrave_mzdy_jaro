class TaxAfterReliefConcept < PayrollConcept
  TAG_ADVANCE = PayTagGateway::REF_TAX_ADVANCE.code
  TAG_RELIEF_PAYER = PayTagGateway::REF_TAX_RELIEF_PAYER.code
  TAG_RELIEF_CHILD = PayTagGateway::REF_TAX_RELIEF_CHILD.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_AFTER_RELIEF, tag_code)
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

  def evaluate(period, tag_config, results)
    advance_base_value = get_result_by(results, TAG_ADVANCE)
    relief_payer_value = get_result_by(results, TAG_RELIEF_PAYER)
    relief_child_value = get_result_by(results, TAG_RELIEF_CHILD)

    tax_advance_value = advance_after_relief(advance_base_value.payment,
                                relief_payer_value.tax_relief,
                                relief_child_value.tax_relief)

    TaxAfterReliefResult.new(@tag_code, @code, self, {payment: tax_advance_value})
  end

  def advance_after_relief(tax_advance, relief_payer, relief_child)
    [0, tax_advance - relief_payer - relief_child].max
  end
end
