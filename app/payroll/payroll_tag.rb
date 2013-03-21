class PayrollTag < CodeNameRefer
  attr_reader :concept

  def initialize(code_refer, concept)
    super(code_refer.code, code_refer.name)
    @concept = concept
  end

  def title
    name
  end

  def description
    name
  end

  def concept_code
    concept.code
  end

  def concept_name
    concept.name
  end

  def insurance_health?
    false
  end

  def insurance_social?
    false
  end

  def tax_advance?
    false
  end

  def income_gross?
    false
  end

  def income_netto?
    false
  end

  def deduction_netto?
    false
  end
end