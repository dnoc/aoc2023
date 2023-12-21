TYPES = { period: ".", slash: "/", backslash: "\\", pipe: "|", dash: "-" }

def move(laser, node)
  if node[:type] == "/"
    if laser[:direction] == :up
      laser[:direction] = :right
    elsif laser[:direction] == :down
      laser[:direction] = :left
    elsif laser[:direction] == :left
      laser[:direction] = :down
    elsif laser[:direction] == :right
      laser[:direction] = :up
    end    
  elsif node[:type] == "\\"
    if laser[:direction] == :up
      laser[:direction] = :left
    elsif laser[:direction] == :down
      laser[:direction] = :right
    elsif laser[:direction] == :left
      laser[:direction] = :up
    elsif laser[:direction] == :right
      laser[:direction] = :down
    end
  end

  if laser[:direction] == :up
    laser[:y] -= 1
  elsif laser[:direction] == :down
    laser[:y] += 1
  elsif laser[:direction] == :left
    laser[:x] -= 1
  elsif laser[:direction] == :right
    laser[:x] += 1
  end  
end

def out_of_bounds?(laser, x_bound, y_bound)
  laser[:x] >= x_bound || laser[:y] >= y_bound || laser[:x] < 0 || laser[:y] < 0
end

def part1
  lines = File.readlines("./input/day16.txt").map(&:chomp)
  graph = []
  lines.each do |line|
    graph << line.chars.map do |c|
      { type: c, energized: false }
    end
  end

  x_bound = graph[0].length
  y_bound = graph.length

  lasers = [{ x: 0, y: 0, direction: :right}]
  while lasers.length > 0 do
    lasers_to_add = []
    lasers.each_with_index do |l, i|
      node = graph[l[:y]][l[:x]]
      node[:energized] = true
      if node[:type] == "|" && (l[:direction] == :right || l[:direction] == :left)
        lasers_to_add << { x: l[:x], y: l[:y], direction: :up }
        l[:direction] = :down
      elsif node[:type] == "-" && (l[:direction] == :up || l[:direction] == :down)
        lasers_to_add << { x: l[:x], y: l[:y], direction: :left }
        l[:direction] = :right
      end
      move(l,node)
    end
    lasers.concat(lasers_to_add)
    lasers = lasers.reject { |l| out_of_bounds?(l, x_bound, y_bound) }.uniq
    # Infinite cycle but eventually this log is static
    puts "energized #{graph.flatten.count { |n| n[:energized] == true }}"
  end

  energized_tiles = graph.flatten.count { |n| n[:energized] == true }

  puts "Part 1"
  puts energized_tiles
end

def run_through(graph, start_x, start_y, start_direction)
  reset(graph)
  puts "starts with #{graph.flatten.count { |n| n[:energized] == true }} energized tiles"
  x_bound = graph[0].length
  y_bound = graph.length
  lasers = [{ x: start_x, y: start_y, direction: start_direction}]
  count = 0
  while lasers.length > 0 do
    lasers_to_add = []
    lasers.each_with_index do |l, i|
      node = graph[l[:y]][l[:x]]
      if node[l[:direction]] > 2
        l[:has_cycle] = true
        next
      end

      node[:energized] = true
      node[l[:direction]] += 1
      if node[:type] == "|" && (l[:direction] == :right || l[:direction] == :left)
        lasers_to_add << { x: l[:x], y: l[:y], direction: :up, history: [] }
        l[:direction] = :down
      elsif node[:type] == "-" && (l[:direction] == :up || l[:direction] == :down)
        lasers_to_add << { x: l[:x], y: l[:y], direction: :left, history: [] }
        l[:direction] = :right
      end
      move(l,node)
    end
    lasers.concat(lasers_to_add)
    lasers = lasers.reject { |l| out_of_bounds?(l, x_bound, y_bound) || l[:has_cycle] }
  end

  energized_tiles = graph.flatten.count { |n| n[:energized] == true }

  { x: start_x, y: start_y, energized_tiles: energized_tiles }
end

def reset(graph)
  graph.each do |row|
    row.each do |node|
      node[:energized] = false
      node[:up] = 0
      node[:down] = 0
      node[:left] = 0
      node[:right] = 0
    end
  end
end

def part2
  lines = File.readlines("./input/day16.txt").map(&:chomp)
  graph = []
  lines.each do |line|
    graph << line.chars.map do |c|
      { type: c, energized: false, up: 0, down: 0, left: 0, right: 0 }
    end
  end

  solutions = []
  graph.each_with_index do |row, y|
    if y == 0
      # Assuming that corners don't go twice, i.e. x: 0, y: 0, direction: :right and not :down
      row.each_with_index do |r, x|
        if x > 0 && x < row.length - 1
          solutions << run_through(graph, x, y, :down)
        end
      end
      solutions << run_through(graph, 0, y, :right)
      solutions << run_through(graph, row.length - 1, y, :left)
    elsif y == graph.length - 1
      row.each_with_index do |r, x|
        if x > 0 && x < row.length - 1
          solutions << run_through(graph, x, y, :up)
        end
      end
      solutions << run_through(graph, 0, y, :right)
      solutions << run_through(graph, row.length - 1, y, :left)
    else
      solutions << run_through(graph, 0, y, :right)
      solutions << run_through(graph, row.length - 1, y, :left)
    end
  end

  puts "part 2"
  puts solutions.map { |a| a[:energized_tiles] }.sort.inspect
end
part2