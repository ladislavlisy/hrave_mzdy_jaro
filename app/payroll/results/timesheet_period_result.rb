class TimesheetPeriodResult < PayrollResult
  attr_reader :month_schedule

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @month_schedule = values[:month_schedule]
  end
end