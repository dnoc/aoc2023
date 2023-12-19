def hash(word)
  value = 0
  word.chars.each do |c|
    value = ((value + c.ord) * 17) % 256
  end
  value
end

def part1
  lines = File.readlines("./input/day15.txt").map(&:chomp)
  input = lines[0].split(",")

  sum = 0
  input.each do |word|
    value = hash(word)
    sum += value
    puts "#{word} #{value}"
  end

  puts "Part 1"
  puts sum
end
part1

def get_focusing_power(boxes)
  focusing_power = 0
  boxes.each_with_index do |b, b_i|
    b.each_with_index do |label, l_i|
      focusing_power += (b_i + 1) * (l_i + 1) * label.chars.last.to_i
    end
  end
  focusing_power
end

def part2
  lines = File.readlines("./input/day15.txt").map(&:chomp)
  input = lines[0].split(",")

  boxes = []
  256.times { |x| boxes << [] }

  focusing_power = 0
  input.each do |word|
    if /^(?<l>[a-z]+)(?<s>[-=])(?<le>\d?)$/ =~ word
      label = l
      symbol = s
      length = le
    end
    box_number = hash(label)
    if symbol == "-"
      boxes[box_number] = boxes[box_number].reject { |b| b.start_with?"#{label} " }
    else
      matching_lens_index = boxes[box_number].find_index { |b| b.start_with?("#{label} ") }
      if matching_lens_index.nil?
        boxes[box_number] << "#{label} #{length}"
      else
        boxes[box_number][matching_lens_index] = "#{label} #{length}"
      end
    end
  end

  puts "Part 2"
  puts get_focusing_power(boxes)
end
part2