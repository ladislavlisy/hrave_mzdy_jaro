#require 'bigdecimal'

TERM_BEG_FINISHED = 32
TERM_END_FINISHED =  0

class PayrollConcept < CodeNameRefer
  attr_reader :tag_code, :tag_pending_codes

  def initialize(code_refer, tag_code)
    super(code_refer.code, code_refer.name)
    @tag_code = tag_code
    @tag_pending_codes = nil
  end

  def init_code(code)
    @tag_code = code
  end

  def init_pending_codes(pending_codes)
    @tag_pending_codes = pending_codes.dup
  end

  def pending_codes
    []
  end

  def summary_codes
    []
  end

  def summary?
    false
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
    elsif summary? && !concept_other.summary?
      return 1
    elsif !summary? && concept_other.summary?
      return -1
    else
      tag_code <=> concept_other.tag_code
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
    result_hash.values[0]
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

  def near_round_up(value_dec, nearest=100)
    big_value = BigDecimal.new(value_dec, 15)
    big_nearest = BigDecimal.new(nearest, 15)

    round_up_to_big(big_value/big_nearest)*big_nearest
  end

  def near_round_down(value_dec, nearest=100)
    big_value = BigDecimal.new(value_dec, 15)
    big_nearest = BigDecimal.new(nearest, 15)

    round_down_to_big(big_value/big_nearest)*big_nearest
  end
end