require_relative '../results/income_base_result'

class InsuranceHealthBaseConcept < PayrollConcept
  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_INSURANCE_HEALTH_BASE, tag_code)
    init_values(values)
  end

  def init_values(values)
    @interest_code = values[:interest_code] || 0
    @minimum_asses = values[:minimum_asses] || 0
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_GROSS
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
                    interest_code: @interest_code,
                    mimimum_asses: @minimum_asses}

    IncomeBaseResult.new(@tag_code, @code, self, result_value)
  end

  def sum_term_for(tag_config, tag_code, result_key, result_item)
    tag_config_item = tag_config.tag_from_models(result_key)
    if result_item.summary_for?(tag_code)
      if tag_config_item.insurance_health?
        return result_item.payment
      end
    end
    return 0
  end

  def interest?
    @interest_code!=0
  end

  def minimum_assessment?
    @minimum_asses!=0
  end

  def min_max_assessment_base(period, ins_base)
    min_base = min_assessment_base(period, ins_base)

    max_base = max_assessment_base(period, min_base)
  end

  def max_assessment_base(period, income_base)
    maximum_base = health_max_assessment(period.year)
    if maximum_base==0
      income_base
    else
      [income_base, maximum_base].min
    end
  end

  def min_assessment_base(period, income_base)
    if !minimum_assessment?
      income_base
    else
      minimum_base = health_min_assessment(period.year, period.month)
      if minimum_base > income_base
        minimum_base
      else
        income_base
      end
    end
  end

  def health_max_assessment(year)
    if year>=2013
      0 #1863648L
    elsif year==2012
      1809864
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

  def health_min_assessment(year, month)
    if year>=2007
      8000
    elsif year==2006 && month>=7
      7955
    elsif year==2006
      7570
    elsif year==2005
      7185
    elsif year==2004
      6700
    elsif year==2003
      6200
    elsif year==2002
      5700
    elsif year==2001
      5000
    elsif year==2000 && month>=7
      4500
    elsif year==2000
      4000
    elsif year==1999 && month>=7
      3600
    else
      3250
    end
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:interest_code] = @interest_code
    attributes[:minimum_asses] = @minimum_asses
    xml_builder.spec_value(attributes)
  end
end