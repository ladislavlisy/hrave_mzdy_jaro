class TagRefer
  include Comparable

  attr_reader :period_base, :code, :code_order

  def initialize(period_base, code, code_order)
    @period_base = period_base
    @code = code
    @code_order = code_order
  end

  def ==(other)
    @period_base == other.period_base && @code == other.code && @code_order == other.code_order
  end

  def <=>(other)
    if @period_base == other.period_base
      if @code == other.code
        @code_order <=> other.code_order
      else
        @code <=> other.code
      end
    else
      @period_base <=> other.period_base
    end
  end

  def eql?(other)
    @period_base == other.period_base && @code == other.code && @code_order == other.code_order
  end

  def hash
    code_int = @code.hash
    @period_base.hash ^ code_int ^ @code_order.hash
  end
end