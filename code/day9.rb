def extrapolate(history)
  if history.all? { |n| n == 0 }
    return 0  
  end

  derived = []
  history.each_with_index do |n, i|
    if i != 0
      derived << n - history[i - 1]
    end
  end
  next_value = history.last + extrapolate(derived)
end

def extrapolate_backwards(history)
  if history.all? { |n| n == 0 }
    return 0  
  end

  derived = []
  history.each_with_index do |n, i|
    if i != history.size - 1
      derived << n - history[i + 1]
    end
  end
  puts derived.inspect
  next_value = history.last - extrapolate_backwards(derived)
end

def part1
  lines = File.readlines("./input/day9.txt").map(&:chomp)
  histories = lines.map {|line| line.split(" ").map(&:to_i) }

  sum = 0
  histories.each do |h|
    h_sum = extrapolate(h)
    # if h.first == 12 || h.first == -6
    #   puts "#{h.inspect} = #{h_sum}"
    # end
    sum += h_sum
  end

  puts "part 1"
  puts sum
end
part1

def part2
  lines = File.readlines("./input/day9.txt").map(&:chomp)
  histories = lines.map {|line| line.split(" ").map(&:to_i) }

  sum = 0
  histories.each do |h|
    puts h.inspect
    h_sum = extrapolate_backwards(h.reverse)
    sum += h_sum
  end

  puts "part 2"
  puts sum
end
part2