class HoursAbsenceTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_HOURS_ABSENCE, PayConceptGateway::REFCON_HOURS_ABSENCE)
  end
end