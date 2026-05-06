# `<int>.step(end, step)` without a block returns an int_array.
# Spinel's pre-existing `step` codegen handled the with-block form
# only — call sites without a block fell through to the
# unresolved-method warning and emitted `0`. The result was
# typically passed to `.each` or stored, where the int 0 silently
# replaced the iterable.
#
# Repro: capture the result and use it as the receiver of `.each`,
# `.size`, and indexed reads. Both ascending and descending steps
# must work, and a zero-step yields an empty array (matches the
# CRuby `Numeric#step` semantics).

a = 0.step(20, 4).to_a
puts a.size
puts a[0]
puts a[5]

# Ascending: 100, 110, 120, 130
b = 100.step(130, 10).to_a
b.each { |x| puts x }

# Descending: 5, 3, 1
c = 5.step(1, -2).to_a
c.each { |x| puts x }

# As receiver of .each directly
0x10.step(0x20, 8).each { |x| puts x.to_s(16) }
