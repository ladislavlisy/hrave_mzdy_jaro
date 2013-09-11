#require 'bigdecimal'

class PayrollConcept < CodeNameRefer
  attr_reader :tag_code, :tag_pending_codes

  TERM_BEG_FINISHED = 32
  TERM_END_FINISHED =  0

  CALC_CATEGORY_START  = 0
  CALC_CATEGORY_TIMES  = 0
  CALC_CATEGORY_AMOUNT = 0
  CALC_CATEGORY_GROSS  = 1
  CALC_CATEGORY_NETTO  = 2
  CALC_CATEGORY_FINAL  = 9

  def initialize(code_refer, tag_code)
    super(code_refer.code, code_refer.name)
    @tag_code = tag_code
    @tag_pending_codes = nil
  end

  def init_code(code)
    @tag_code = code
  end

  def description
    name
  end

  def export_xml(xml_builder)
  end

  def export_value_result
  end

  def set_pending_codes(pending_codes)
    @tag_pending_codes = pending_codes.dup
  end

  def pending_codes
    []
  end

  def summary_codes
    []
  end

  def calc_category
    CALC_CATEGORY_START
  end

  def timesheet_hours_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      0
    else
      result_for_tag.hours
    end
  end

  def term_hours_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      0
    else
      result_for_tag.hours
    end
  end

  def employee_income_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      big_decimal_cast(0)
    else
      result_for_tag.employee_base
    end
  end

  def employer_income_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      big_decimal_cast(0)
    else
      result_for_tag.employer_base
    end
  end

  def income_base_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      big_decimal_cast(0)
    else
      result_for_tag.income_base
    end
  end

  def payment_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      big_decimal_cast(0)
    else
      result_for_tag.payment
    end
  end

  def tax_payment_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      big_decimal_cast(0)
    else
      result_for_tag.payment
    end
  end

  def tax_claim_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      big_decimal_cast(0)
    else
      result_for_tag.tax_relief
    end
  end

  def tax_relief_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      big_decimal_cast(0)
    else
      result_for_tag.tax_relief
    end
  end

  def interest_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      false
    else
      result_for_tag.interest?
    end
  end

  def declared_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      false
    else
      result_for_tag.declared?
    end
  end

  def week_schedule_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
       Array.new(7) {0}
    else
      result_for_tag.week_schedule
    end
  end

  def month_schedule_result(results, tag_code)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      Array.new(31) {0}
    else
      result_for_tag.month_schedule
    end
  end

  def day_from_result(results, tag_code, default_value)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      default_value
    else
      result_for_tag.day_ord_from
    end
  end

  def day_end_result(results, tag_code, default_value)
    result_for_tag = get_result_by(results, tag_code)
    if result_for_tag.nil?
      default_value
    else
      result_for_tag.day_ord_end
    end
  end

  def <=>(concept_other)
    if count_pending_codes(tag_pending_codes, concept_other.tag_code)!=0
      return 1
    elsif count_pending_codes(concept_other.tag_pending_codes, tag_code)!=0
      return -1
    elsif count_summary_codes(summary_codes, concept_other.tag_code)!=0
      return -1
    elsif count_summary_codes(concept_other.summary_codes, tag_code)!=0
      return 1
    elsif calc_category == concept_other.calc_category
      tag_code <=> concept_other.tag_code
    else
      calc_category <=> concept_other.calc_category
    end
  end

  def count_pending_codes(concept_pending, code)
    _codes = concept_pending.select { |x| x.code==code }
    _codes.count
  end

  def count_summary_codes(concept_summary, code)
    _codes = concept_summary.select { |x| x.code==code }
    _codes.count
  end

  #get term from Results by key of tag
  def get_result_by(results, pay_tag)
    result_hash = results.select { |key,_| key.code==pay_tag }
    if result_hash.empty?
      nil
    else
      result_hash.values[0]
    end
  end

  def big_multi(op1, op2)
    big_op1 = BigDecimal.new(op1, 15)
    big_op2 = BigDecimal.new(op2, 15)
    return big_op1*big_op2
  end

  def big_div(op1, op2)
    big_op1 = BigDecimal.new(op1, 15)
    big_op2 = BigDecimal.new(op2, 15)
    if (big_op2 == 0)
      return BigDecimal(0, 15)
    end
    return big_op1/big_op2
  end

  def big_multi_and_div(op1, op2, div)
    big_op1 = BigDecimal.new(op1, 15)
    big_op2 = BigDecimal.new(op2, 15)
    big_div = BigDecimal.new(div, 15)
    if (big_div == 0)
      return BigDecimal(0, 15)
    end
    return big_op1*big_op2/big_div
  end

  def big_insurance_round_up(value_dec)
    round_up_to_big(value_dec)
  end

  def fix_insurance_round_up(value_dec)
    round_up_to_fix(value_dec)
  end

  def big_tax_round_up(value_dec)
    round_up_to_big(value_dec)
  end

  def fix_tax_round_up(value_dec)
    round_up_to_fix(value_dec)
  end

  def big_tax_round_down(value_dec)
    round_down_to_big(value_dec)
  end

  def fix_tax_round_down(value_dec)
    round_down_to_fix(value_dec)
  end

  def round_up_to_big(value_dec)
    BigDecimal.new(value_dec < 0 ? -value_dec.abs.ceil : value_dec.abs.ceil)
  end

  def round_up_to_fix(value_dec)
    (value_dec < 0 ? -value_dec.abs.ceil : value_dec.abs.ceil)
  end

  def round_down_to_big(value_dec)
    BigDecimal.new(value_dec < 0 ? -value_dec.abs.floor : value_dec.abs.floor)
  end

  def round_down_to_fix(value_dec)
    (value_dec < 0 ? -value_dec.abs.floor : value_dec.abs.floor)
  end

  def big_near_round_up(value_dec, nearest=100)
    big_multi(round_up_to_big(big_div(value_dec, nearest)), nearest)
  end

  def big_near_round_down(value_dec, nearest=100)
    big_multi(round_down_to_big(big_div(value_dec, nearest)), nearest)
  end

  def big_decimal_cast(number)
    BigDecimal.new(number, 15)
  end
end