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
    sort_key = @terms.keys.sort
    prev_tag = TermTag.new(nil, nil, nil)
    next_tag = sort_key.find {|tag| !find_tag.is_greater(prev_tag, tag)}
    if prev_tag.code.nil?
      find_tag.set_order(next_tag)
    else
      find_tag.set_order(prev_tag)
    end

    @terms[find_tag] = amount
  end

  def add_term_salary(code, amount)
    ins_term_salary(code, nil, amount)
  end

  def add_term_schedule(code, hours)

  end
end