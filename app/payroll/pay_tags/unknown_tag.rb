class UnknownTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_UNKNOWN, PayConceptGateway::REFCON_UNKNOWN)
  end
end