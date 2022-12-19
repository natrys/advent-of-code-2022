mutable struct Cell
  visible::Bool
  height::Int8
  distances::Vector{Int}
end

@enum Direction east=1 west=2 north=3 south=4

function process(elems, dir::Direction)
  elems = collect(elems)

  # for part 1
  max = -1
  for elem in elems
    if elem.height > max
      elem.visible = true
      max = elem.height
    end
  end

  # for part 2
  for i in 1:length(elems)
    distance = 0
    for j in i-1:-1:1
      distance += 1
      if elems[i].height <= elems[j].height
        break
      end
    end
    elems[i].distances[Int(dir)] = distance
  end
end

function main()
  input = [[Cell(false, parse(Int8, char), zeros(Int, 4)) for char in line] for line in readlines()]
  grid = reduce(hcat, input)

  for row in eachrow(grid)
    process(row, east)
    process(Iterators.Reverse(row), west)
  end
  for col in eachcol(grid)
    process(col, north)
    process(Iterators.Reverse(col), south)
  end

  # Part 1
  println("Part1: $(count(x -> x.visible, vec(grid)))")

  # Part 2
  println("Part2: $(maximum(x -> prod(x.distances), vec(grid)))")
end

@time main()
