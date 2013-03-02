TERM_BEG_FINISHED = 32
TERM_END_FINISHED =  0

class PayrollConcept < CodeNameRefer
  attr_reader :tag_code

  def initialize(code_refer, tag_code)
    super(code_refer.code, code_refer.name)
    @tag_code = tag_code
  end

  def pending_codes
    []
  end

  def summary_codes
    []
  end

  def <=>(concept_other)
    if concept_other.pending_codes.include?(tag_code)
      return -1
    elsif pending_codes.include?(concept_other.tag_code)
      return 1
    elsif summary_codes.include?(concept_other.tag_code)
      return -1
    elsif concept_other.summary_codes.include?(tag_code)
      return 1
    else
      tag_code <=> concept_other.tag_code
    end
  end

  #get term from Results by key of tag
  def get_result_by(results, pay_tag)
    result_hash = results.select { |key,_| key.code==pay_tag }
    result_hash.values[0]
  end
end