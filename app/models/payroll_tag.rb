class PayrollTag
  attr_reader :code, :name, :concept

  def initialize(code, name, concept)
    @code = code
    @name = name
    @concept = concept
  end
end