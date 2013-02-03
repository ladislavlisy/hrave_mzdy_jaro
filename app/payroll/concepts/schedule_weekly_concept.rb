class ScheduleWeeklyConcept < PayrollConcept
  attr_reader :hours_weekly

  def initialize(values)
    super(:CONCEPT_SCHEDULE_WEEKLY, :CONCEPT_SCHEDULE_WEEKLY.id2name)

    @hours_weekly = values[:hours_weekly]
  end

  def pending_codes
    []
  end
end