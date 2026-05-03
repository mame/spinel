# `sp_PolyArray *` (poly_array) values passed to a poly-typed
# slot used to fall through `box_value_to_poly`'s generic pointer
# path and stamp `cls_id` 0. The matching `[]` / `length`
# dispatch arms only covered INT/FLT/STR/SYM/PTR_ARRAY, so the
# read silently returned nil.
#
# Reserve `SP_BUILTIN_POLY_ARRAY` (-10) and add the dispatch arm,
# plus box value via `box_value_to_poly` when filling a
# poly_array with `arr.fill(val)`.

class Bag
  def initialize
    @items = [nil] * 4
    @items[0] = "x"
    @items[1] = 1
    @items[2] = 2.5
    @items[3] = :sym
  end

  attr_reader :items

  # Pass items as a poly value through a method that takes a
  # poly arg.
  def first_of(arr)
    arr[0]
  end

  def echo
    first_of(@items)
  end
end

b = Bag.new

# Pass poly_array through a poly-typed parameter and read back.
puts b.echo                # x

# Direct length on the poly_array.
puts b.items.length        # 4

# Heterogeneous []= against an int_array reseeded as [nil] * N
# should widen the slot beyond int_array (same setup as Bag) and
# round-trip arbitrary types.
puts b.items[0]            # x
puts b.items[1]            # 1
puts b.items[2]            # 2.5
puts b.items[3]            # sym

# Fill on a poly_array with an int value: the value needs to be
# boxed via box_value_to_poly before sp_PolyArray_set, not
# stored as a raw mrb_int.
class Filler
  def initialize
    @cells = [nil] * 3
    @cells[0] = "tag"      # widens @cells to poly_array
    @cells.fill(42)        # poly_array fill — needs box
  end
  attr_reader :cells
end

f = Filler.new
puts f.cells[0]            # 42
puts f.cells[1]            # 42
puts f.cells[2]            # 42
