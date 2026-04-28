# `method(:foo)` on an instance method becomes a heap-allocated
# BoundMethod that survives ivar storage and cross-method use.

class C
  def initialize
    @bm = method(:double)
  end
  def double(x)
    x * 2
  end
  def via_call(x)
    @bm.call(x)
  end
  def via_bracket(x)
    @bm[x]
  end
end

c = C.new
puts c.via_call(7)
puts c.via_bracket(20)
