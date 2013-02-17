class ScheduleTermTag < PayrollTag
  def initialize
    super(:TAG_SCHEDULE_TERM, :TAG_SCHEDULE_TERM.id2name,
          CodeNameRefer.new(:CONCEPT_SCHEDULE_TERM, :CONCEPT_SCHEDULE_TERM.id2name))
  end
end