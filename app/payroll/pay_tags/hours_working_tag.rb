class HoursWorkingTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_HOURS_WORKING, PayConceptGateway::REFCON_HOURS_WORKING)
  end
end