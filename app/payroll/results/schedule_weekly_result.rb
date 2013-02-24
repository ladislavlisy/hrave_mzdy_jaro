class ScheduleWeeklyResult < PayrollResult
  attr_reader :week_schedule

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @week_schedule = values[:week_schedule]
  end
end