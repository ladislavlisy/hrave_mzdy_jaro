class TimesheetWorkResult < PayrollResult
  attr_reader :month_schedule

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @month_schedule = values[:month_schedule]
  end

  def hours
    month_hours = 0
    if (!month_schedule.nil?)
      month_hours = month_schedule.inject(0) {|agr, dh| agr = agr + dh}
    end
    return month_hours
  end
end