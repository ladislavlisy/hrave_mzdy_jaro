class HoursWorkingTag < PayrollTag
  def initialize
    super(:TAG_HOURS_WORKING, :TAG_HOURS_WORKING.id2name,
          CodeNameRefer.new(:CONCEPT_HOURS_WORKING, :CONCEPT_HOURS_WORKING.id2name))
  end
end