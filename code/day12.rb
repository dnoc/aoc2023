
def possible_arrangement_counts(values, groups)
  
end

def part1
  lines = File.readlines("./input/day12.txt").map(&:chomp)

  counts = lines.map do |l|
    parts = l.split(" ")
    values = parts[0].chars
    groups = parts[1].split(",").map(&:to_i)
    possible_arrangement_counts(values, groups)
  end  

  puts "Part 1"
  counts.sum
end
part1