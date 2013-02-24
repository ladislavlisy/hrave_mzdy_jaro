class ScheduleTermTag < PayrollTag
  def initialize
    super(ScheduleTermTagRefer.new,
          CodeNameRefer.new(:CONCEPT_SCHEDULE_TERM, :CONCEPT_SCHEDULE_TERM.id2name))
  end
end