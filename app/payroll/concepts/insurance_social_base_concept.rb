class InsuranceSocialBaseConcept < PayrollConcept
  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_INSURANCE_SOCIAL_BASE, tag_code)
    init_values(values)
  end

  def init_values(values)
    @interest_code = values[:interest_code] || 0
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def calc_category
    CALC_CATEGORY_GROSS
  end

  def evaluate(period, tag_config, results)
    result_income = 0
    if !interest?
      result_income = 0
    else
      result_income = results.inject(0) do |agr, term_item|
        term_key    = term_item.first
        term_result = term_item.last
        agr + sum_term_for(tag_config, tag_code, term_key, term_result)
      end
    end

    employee_base = min_max_assessment_base(period, result_income)
    employer_base = max_assessment_base(period, result_income)

    result_value = {income_base: result_income,
                    employee_base: employee_base,
                    employer_base: employer_base,
                    interest_code: @interest_code}

    IncomeBaseResult.new(@tag_code, @code, self, result_value)
  end

  def sum_term_for(tag_config, tag_code, result_key, result_item)
    tag_config_item = tag_config.tag_from_models(result_key)
    if result_item.summary_for?(tag_code)
      if tag_config_item.insurance_social?
        return result_item.payment
      end
    end
    return 0
  end

  def interest?
    @interest_code!=0
  end

  def min_max_assessment_base(period, ins_base)
    min_base = min_assessment_base(period, ins_base)

    max_base = max_assessment_base(period, min_base)
  end

  def max_assessment_base(period, income_base)
    maximum_base = social_max_assessment(period.year)
    if maximum_base==0
      income_base
    else
      [income_base, maximum_base].min
    end
  end

  def min_assessment_base(period, income_base)
    income_base
  end

  def social_max_assessment(year)
    if year>=2013
      1242432
    elsif year==2012
      1206576
    elsif year==2011
      1781280
    elsif year==2010
      1707048
    elsif year==2009
      1130640
    elsif year==2008
      1034880
    else
      0
    end
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:interest_code] = @interest_code
    xml_builder.spec_value(attributes)
  end
end