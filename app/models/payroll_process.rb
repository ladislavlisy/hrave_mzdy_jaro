#require "payroll_period.rb"
#require "pay_tag_gateway.rb"

class PayrollProcess
  attr_reader :period

  def initialize(period)
    @period = period
    @terms = Hash.new
  end

  def ins_term_salary(period, code, code_order, amount)
    find_tag = TagRefer.new(period, code, code_order)
    @terms[find_tag] = amount
  end

  def add_term_salary(code, amount)
    period = PayrollPeriod::NOW

    new_code_order = get_new_tag_order(period, code)

    ins_term_salary(period, code, new_code_order, amount)
  end

  def get_new_tag_order(period, code)
    sort_keys = @terms.keys.sort
    keys_for_code = sort_keys.select { |x| x.period_base==period && x.code==code }
    orders_for_code = keys_for_code.map { |x| x.code_order }
    last_code_order = orders_for_code.inject(0) { |agr, x| x-agr > 1 ? agr : x }
    (last_code_order + 1)
  end
end