TERM_BEG_FINISHED = 32
TERM_END_FINISHED =  0

class PayrollConcept < CodeNameRefer
  attr_reader :tag_code, :tag_pending_codes

  def initialize(code_refer, tag_code)
    super(code_refer.code, code_refer.name)
    @tag_code = tag_code
    @tag_pending_codes = []
  end

  def rec_pending_codes(pending_codes)
    ret_codes = pending_codes.inject(pending_codes.dup)  do |agr, t|
      agr.concat(rec_pending_codes(pending_codes_for_tag_code(t)))
    end
    ret_codes.uniq
  end

  def pending_codes_for_tag_code(tag_refer)
    empty_values = {}
    concept_class = classname_for(tag_refer.concept_name)
    concept_class = self.class.const_get(concept_class)
    concepts_item = concept_class.new(tag_refer, empty_values)
    concepts_item.tag_pending_codes
  end

  def classname_for(code)
    concept_name = code.match(/CONCEPT_(.*)/)[1]
    class_name = concept_name.underscore.camelize + 'Concept'
    class_name
  end

  def pending_codes
    []
  end

  def summary_codes
    []
  end

  def <=>(concept_other)
    other_pending_select = concept_other.tag_pending_codes.select {|x| x.code==tag_code}
    if count_pending_codes(tag_pending_codes, concept_other.tag_code)!=0
      return 1
    elsif count_pending_codes(concept_other.tag_pending_codes, tag_code)!=0
      return -1
    elsif count_summary_codes(summary_codes, concept_other.tag_code)!=0
      return -1
    elsif count_summary_codes(concept_other.summary_codes, tag_code)!=0
      return 1
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
end