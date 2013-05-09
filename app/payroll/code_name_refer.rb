class CodeNameRefer
  attr_reader :code, :name

  def initialize(code, name)
    @code = code
    @name = name
  end

  def ==(other)
    @code == other.code
  end

  def <=>(other)
    @code <=> other.code
  end

  def eql?(other)
    @code == other.code
  end

  def hash
    code_int = @code.hash
  end
end