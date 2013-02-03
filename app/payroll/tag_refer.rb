class TagRefer
  include Comparable

  attr_reader :period_base, :code, :code_order

  def initialize(period_base, code, code_order)
    @period_base = period_base
    @code = code
    @code_order = code_order
  end

  def <=>(tag_other)
    if @period_base == tag_other.period_base
      if @code == tag_other.code
        @code_order <=> tag_other.code_order
      else
        @code <=> tag_other.code
      end
    else
      @period_base <=> tag_other.period_base
    end
  end
end