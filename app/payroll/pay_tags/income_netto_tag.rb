# Specification: Net Income

class IncomeNettoTag < PayrollTag
  def initialize
    super(IncomeNettoTagRefer.new,
          CodeNameRefer.new(:CONCEPT_INCOME_NETTO, :CONCEPT_INCOME_NETTO.id2name))

  end
end