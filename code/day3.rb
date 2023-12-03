SYMBOLS = "*-&$@#=+%/"

class Node
  attr_reader :start, :ending, :y, :digits, :adjacents

  def initialize(start, y, digits)
    @start = start
    @ending = start + digits.length - 1
    @y = y
    @digits = digits
    @adjacents = []
  end

  def id
    "#{start}:#{y}"
  end

  def add_adj(str)
    @adjacents.concat(str.chars)
  end

  def has_gear?
    @adjacents.any? { |a| a == "*" }
  end

  def is_part_number?
    @adjacents.any? { |a| SYMBOLS.include?(a) }
  end

  def value
    if is_part_number?
      @digits.to_i
    else
      0
    end
  end
end

class Gear
  attr_reader :x, :y, :ratio

  def initialize(x, y)
    @x = x
    @y = y
    @ratio = 0
  end

  def id
    "#{x}:#{y}"
  end

  def calc_ratio(gear_nodes)
    adjacent_nodes = get_adjacent_nodes(gear_nodes)
    if adjacent_nodes.size != 2
      @ratio = 0
    else
      @ratio = adjacent_nodes.first.value * adjacent_nodes.last.value
    end
  end

  def get_adjacent_nodes(gear_nodes)
    adjacent_nodes = gear_nodes.filter do |n|
      if n.y > y + 1 || n.y < y - 1
        next
      end

      if (n.start > x - 2) && (n.start < x + 2)
        n
      elsif (n.ending > x - 2) && (n.ending < x + 2)
        n
      else
        next
      end
    end
  end
end

class Graph
  attr_reader :nodes, :gears

  def initialize(lines)
    @lines = lines
    @nodes = []
    @gears = []
  end

  def build_nodes
    nodes = []
    @lines.each_with_index do |l, i|
      x_offset = 0
      numbers = l.scan(/\d{1,3}/)
      numbers.each do |n|
        node = Node.new(l.index(n, x_offset), i, n)
        
        if node.start > 0
          node.add_adj(l[node.start - 1])
        end
        if node.ending < l.length - 1
          node.add_adj(l[node.ending + 1])
        end

        vertical_start = node.start == 0 ? node.start : node.start - 1
        vertical_end = node.ending == l.length - 1 ? node.ending : node.ending + 1
        if (node.y > 0)
          node.add_adj(@lines[node.y - 1][vertical_start..vertical_end])
        end
        if (node.y < @lines.size - 1)
          node.add_adj(@lines[node.y + 1][vertical_start..vertical_end])
        end
        
        x_offset = node.ending
        nodes << node
      end
    end

    @nodes = nodes
  end

  def build_gears
    gears = []
    gear_nodes = nodes.filter { |n| n.has_gear? }
    # puts "gear nodes"
    # puts gear_nodes.map { |n| n.id }
    @lines.each_with_index do |l, i|
      x_offset = 0
      g_arr = l.scan("*")
      g_arr.each do |g|
        gear = Gear.new(l.index(g, x_offset), i)
        
        gear.calc_ratio(gear_nodes)
        # puts "gear #{gear.id}"
        # puts gear.get_adjacent_nodes(gear_nodes).map { |n| n.id }
      
        x_offset = gear.x + 1
        gears << gear
      end
    end

    # puts "gear size #{gears.size}"
    @gears = gears
  end
end

def log1(node)
  puts "start #{node.start}"
  puts "end #{node.ending}"
  puts "y #{node.y}"
  puts "digits #{node.digits}"
  puts "value #{node.value}"
  puts "is_part #{node.is_part_number?}"
  puts "adjacents #{node.adjacents.inspect}"
end


def run
  lines = File.readlines("./input/day3.txt").map(&:chomp)
  graph = Graph.new(lines)
  graph.build_nodes
  graph.build_gears

  # graph.nodes.each { |z| log1(z) }

  puts "Part 1"
  puts graph.nodes.sum { |n| n.value }  

  puts "Part 2"
  puts graph.gears.sum { |g| g.ratio }
end
run