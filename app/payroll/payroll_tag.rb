class PayrollTag < CodeNameRefer
  attr_reader :concept

  def initialize(code_refer, concept)
    super(code_refer.code, code_refer.name)
    @concept = concept
  end

end