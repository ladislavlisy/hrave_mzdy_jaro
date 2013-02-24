class HoursWorkingTag < PayrollTag
  def initialize
    super(HoursWorkingTagRefer.new,
          CodeNameRefer.new(:CONCEPT_HOURS_WORKING, :CONCEPT_HOURS_WORKING.id2name))
  end
end