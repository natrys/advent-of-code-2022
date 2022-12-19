mutable struct Point
  x::Int
  y::Int
end

# Doesn't work for some reason, so actually need to use Tuple later in a Set
# Base.hash(p::Point, h::UInt64) = hash((p.x, p.y), h)

@inline function move_tail(head::Point, tail::Point)
  tail.x += sign(head.x - tail.x)
  tail.y += sign(head.y - tail.y)
end

function main(input, N)
  directions = Dict(
    "R" => point -> point.x += 1,
    "L" => point -> point.x -= 1,
    "U" => point -> point.y += 1,
    "D" => point -> point.y -= 1,
  )

  tails = [Point(0, 0) for _ in 1:N+1]

  visited = Set{Tuple{Int, Int}}()
  push!(visited, (0, 0))

  pattern = r"(?P<dir>[RLUD]) (?P<step>\d+)"
  for line in input
    m = match(pattern, line)
    dir, step = m["dir"], parse(Int, m["step"])

    for _ in 1:step
      head = first(tails)
      directions[dir](head)

      for i in 1:N
        head, tail = tails[i], tails[i+1]
        if abs(head.x - tail.x) == 2 || abs(head.y - tail.y) == 2
          move_tail(head, tail)
        end
      end

      tail = last(tails)
      push!(visited, (tail.x, tail.y))
    end
  end

  return length(visited)
end

input = readlines()
println("Part1: $(main(input, 1))")
println("Part2: $(main(input, 9))")
