#require "payroll_period.rb"
#require "pay_tag_gateway.rb"

class PayrollProcess
  attr_reader :period

  def initialize(period)
    @period = period
    @terms = Hash.new
  end

  def ins_term_salary(code, code_order, amount)
    find_tag = TermTag.new(0, code, code_order)
    @terms[find_tag] = amount
  end

  def add_term_salary(code, amount)
    sort_keys = @terms.keys.sort
    code_keys = sort_keys.select {|x| x.code==code }
    order_key = code_keys.map {|x| x.code_order}
    order_tag = order_key.inject(0) {|agr,x| x-agr > 1 ? agr : x }

    ins_term_salary(code, order_tag + 1, amount)
  end

  def add_term_schedule(code, hours)

  end
end