class ScheduleTermTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_SCHEDULE_TERM, PayConceptGateway::REFCON_SCHEDULE_TERM)
  end
end