require 'set'

class Graph
  attr_reader :columns_left_of_mirror, :rows_above_mirror

  def initialize(rows)
    # @points = get_points(rows.filter { |c| c != "" })
    @as_rows = rows.filter { |c| c != "" }.map(&:chars)
    @as_columns = @as_rows.transpose
    @rows_above_mirror = calc_mirror(@as_rows)
    @columns_left_of_mirror = calc_mirror(@as_columns)
  end

  # def get_points(rows)
  #   points = {}

  #   rows.each_with_index do |r, y|
  #     r.chars.each_with_index do |c, x|
  #       points["#{x}:#{y}"] = c
  #     end
  #   end

  #   points
  # end

  def calc_mirror(graph)
    # if graph.size == 15
    #   puts "graph"
    #   puts graph.inspect
    # end
    split = graph.slice_when do |a, b|
      a == b
    end.to_a

    # if graph.size == 15
    #   puts "split"
    #   puts split.inspect
    # end

    if split.size == 2 
      a = split[0].to_set
      b = split[1].to_set
      if a < b || b < a
        # one is a subset
        return a.size
      end
    end

    if split.size > 3
      # a = split[0].to_set
      # b = split[1].to_set
      # if a < b || b < a
      #   # one is a subset
      #   return a.size
      # end
      puts "split size"
      puts split.size
      puts split.inspect
    end

    0
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
    # puts "Graph #{i+1}"
    # puts "columns_left_of_mirror #{g.columns_left_of_mirror}"
    # puts "rows_above_mirror #{g.rows_above_mirror}"
    columns_left_of_mirror += g.columns_left_of_mirror
    rows_above_mirror += g.rows_above_mirror
  end

  puts "Part 1"
  puts columns_left_of_mirror + (100 * rows_above_mirror)
end
part1