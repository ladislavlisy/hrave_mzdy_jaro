class PayrollResult
  attr_reader :tag_code, :concept_code
  def initialize(code, concept_code, concept_item)
    @tag_code = code
    @concept_code = concept_code
    @concept = concept_item
  end
end