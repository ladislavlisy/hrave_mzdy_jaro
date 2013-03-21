class UnknownConcept < PayrollConcept
  def initialize
    super(PayConceptGateway::REFCON_UNKNOWN, PayTagGateway::REF_UNKNOWN)
  end
end