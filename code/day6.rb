def calc_solutions(time, goal)
  count = 0
  time.times do |t|
    speed = t + 1
    runtime = time - speed
    distance = speed * runtime 
    if distance > goal
      count += 1
      # puts "s #{speed} d #{distance} g #{goal}"
    end
  end

  count
end

def part1
  lines = File.readlines("./input/day6.txt").map(&:chomp)
  times = lines[0].scan(/ (\d+)/).map { |t| t.first.to_i }
  distances = lines[1].scan(/ (\d+)/).map { |d| d.first.to_i }
  num_solutions = []

  4.times do |i|
    num_solutions << calc_solutions(times[i], distances[i])
  end

  puts "Part 1"
  puts num_solutions.inspect
  puts num_solutions.reduce(:*)
end
part1

def part2
  lines = File.readlines("./input/day6.txt").map(&:chomp)
  time = lines[0].scan(/Time: (.+)/)[0][0].delete(" ").to_i
  distance = lines[1].scan(/Distance: (.+)/)[0][0].delete(" ").to_i

  num_solutions = calc_solutions(time, distance)

  puts "Part 2"
  puts num_solutions
end
part2