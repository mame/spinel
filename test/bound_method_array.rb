# A BoundMethod value flows through the regular obj path, so an array
# of `method(:foo)` references becomes an `obj_BoundMethod_ptr_array` —
# no bespoke `bound_method_array` slot needed.

class C
  def double(x); x * 2; end
  def triple(x); x * 3; end
  def quad(x);   x * 4; end

  def fns
    [method(:double), method(:triple), method(:quad)]
  end
end

c = C.new
fns = c.fns
puts fns.length
puts fns[0].call(5)
puts fns[1].call(5)
puts fns[2].call(5)
