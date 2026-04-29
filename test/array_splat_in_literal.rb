arr = [*0..10]
puts arr.length
puts arr[0]
puts arr[10]

inner = [1, 2, 3]
combined = [0, *inner, 4]
puts combined.length
puts combined[1]
puts combined[3]
