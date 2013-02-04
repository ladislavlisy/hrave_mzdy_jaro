class PayrollConcept < CodeNameRefer
  attr_reader :tag_code

  def initialize(code, name, tag_code)
    super(code, name)
    @tag_code = tag_code
  end

  def pending_codes
    []
  end

  def summary_codes
    []
  end
end