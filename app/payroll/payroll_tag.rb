class PayrollTag < CodeNameRefer
  attr_reader :concept

  def initialize(code, name, concept)
    super(code, name)
    @concept = concept
  end
end