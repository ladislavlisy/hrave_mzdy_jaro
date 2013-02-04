# Specification: Net Income

class IncomeNettoTag < PayrollTag
  def initialize
    super(:TAG_INCOME_NETTO, :TAG_INCOME_NETTO.id2name,
          CodeNameRefer.new(:CONCEPT_INCOME_NETTO, :CONCEPT_INCOME_NETTO.id2name))

  end
end