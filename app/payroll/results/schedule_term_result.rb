class ScheduleTermResult < PayrollResult
  attr_reader :day_ord_from, :day_ord_end

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @day_ord_from = values[:day_ord_from]
    @day_ord_end = values[:day_ord_end]
  end
end