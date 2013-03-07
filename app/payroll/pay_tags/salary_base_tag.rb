class SalaryBaseTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_SALARY_BASE, PayConceptGateway::REFCON_SALARY_MONTHLY)
  end

  def insurance_health?
    true
  end

  def insurance_social?
    true
  end

  def tax_advance?
    true
  end

  def income_gross?
    true
  end

  def income_netto?
    true
  end
end