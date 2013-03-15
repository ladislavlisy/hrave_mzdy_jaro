class TermHoursResult < PayrollResult
  attr_reader :hours

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @hours = values[:hours]
  end
end