class ScheduleWeeklyConcept < PayrollConcept
  attr_reader :hours_weekly

  def initialize(tag_code, values)
    super(:CONCEPT_SCHEDULE_WEEKLY, :CONCEPT_SCHEDULE_WEEKLY.id2name, tag_code)

    @hours_weekly = values[:hours_weekly]
  end

end