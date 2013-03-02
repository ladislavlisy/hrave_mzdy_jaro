class ScheduleTermResult < PayrollResult
  attr_reader :term_from, :term_end

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @term_from = values[:term_from]
    @term_end = values[:term_end]
  end
end