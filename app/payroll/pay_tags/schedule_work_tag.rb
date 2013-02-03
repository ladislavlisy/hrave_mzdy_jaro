class ScheduleWorkTag < PayrollTag
  def initialize
    super(:TAG_SCHEDULE_WORK, :TAG_SCHEDULE_WORK.id2name,
          CodeNameRefer.new(:CONCEPT_SCHEDULE_WEEKLY, :CONCEPT_SCHEDULE_WEEKLY.id2name))
  end
end