require 'set'

class Graph
  attr_reader :columns_left_of_mirror, :rows_above_mirror

  def initialize(rows)
    @as_rows = rows.filter { |c| c != "" }.map(&:chars)
    @as_columns = @as_rows.transpose
    @rows_above_mirror = calc_mirror(@as_rows)
    @columns_left_of_mirror = calc_mirror(@as_columns)
  end

  def calc_mirror(graph)
    split = graph.slice_when do |a, b|
      a == b
    end.to_a

    length = split.size
    if length == 1
      return 0
    end    
    
    while split.size > 2
      a = split[0].to_set
      b = split[1].to_set

      if a < b || b < a
        split[1] = split[1].concat(split[2])
        split.delete_at(2)
      else
        split[0] = split[0].concat(split[1])
        split.delete_at(1)
      end
    end

    if split.size != 2 
      return 0
    end
      
    a = split[0].to_set
    b = split[1].to_set
    if a < b || b < a
      split[0].size
    else
      0
    end
  end
end

def part1
  lines = File.readlines("./input/day13.txt").map(&:chomp)
  input = lines.slice_before("").to_a

  graphs = input.map do |x|
    Graph.new(x)
  end

  columns_left_of_mirror = 0
  rows_above_mirror = 0
  graphs.each_with_index do |g, i|
    columns_left_of_mirror += g.columns_left_of_mirror
    rows_above_mirror += g.rows_above_mirror
  end

  puts "Part 1"
  puts columns_left_of_mirror + (100 * rows_above_mirror)
end
part1

# I'm not doing part 2