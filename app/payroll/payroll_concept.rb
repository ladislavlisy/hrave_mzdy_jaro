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
end