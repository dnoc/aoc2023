def build_nodes(lines)
  lines.each_with_object({}) do |l, h|
    if /^(?<n>[A-Z]{3}) = \((?<left>[A-Z]{3}), (?<right>[A-Z]{3})\)$/ =~ l
      h[n] = [left, right]
    end
  end
end

def part1(instructions, nodes)
  puts "Part 1"
  count = 0
  current = "AAA"
  goal = "ZZZ"
  while current != goal do
    if count % 1000 == 0
      puts "node #{count}"
    end
    instruction = instructions[count % instructions.size] == "L" ? 0 : 1
    current = nodes[current][instruction]
    count += 1
  end
  count
end

def part2(instructions, nodes)
  puts "Part 2"
  count = 0
  state = ["FQA", "JSA", "GJA", "PBA", "AAA", "NNA"]
  done = false
  while !done do
    done = true
    instruction = instructions[count % instructions.size] == "L" ? 0 : 1
    if count % 1000000 == 0
      puts "node #{count}"
    end
    state.each_with_index do |s, i|
      current = nodes[s][instruction]
      if current[2] != "Z"
        done = false
      end
      state[i] = current
    end
    count += 1
  end
  count
end

def get_solutions(instructions, nodes, start, number)
  current = start
  solutions = []
  count = 0
  while solutions.size < number do
    instruction = instructions[count % instructions.size] == "L" ? 0 : 1
    # if count % 10000 == 0
    #   puts "node #{count}"
    # end
    current = nodes[current][instruction]
    # if count == 716204597
    #   puts "716204597 start #{start} #{current}"
    # end
    if current[2] == "Z"
      if solutions.size == 0
        solutions << count
      else
        solutions << count - solutions.last
      end
    end
    count += 1
  end
  puts "done for #{start}"
  solutions
end

def build_solutions(start, steps, number)
  x = [start]
  number.times do |i|
    x << x[i] + steps[i % 2]
  end
  puts "done for #{start}"
  x
end

# I think the first 3 get in sync or something
def run
  lines = File.readlines("./input/day8.txt").map(&:chomp)
  instructions = lines[0].chars

  nodes = build_nodes(lines[2..])
  
  # 0: ["FQA", "JSA", "GJA", "PBA", "AAA", "NNA"]
  # 436432734: ["FNZ", "TVZ", "DPZ", "SNR", "QBJ", "GTG"]
  # 716204597: ["FNZ", "TVZ", "DPZ", "FBP", "XMM", "DTS"]
  puts "building solutions"
  # solutions = [
  #   get_solutions(instructions, nodes, "FNZ", 15),
  #   get_solutions(instructions, nodes, "TVZ", 15),
  #   get_solutions(instructions, nodes, "DPZ", 15),
  #   get_solutions(instructions, nodes, "SNR", 15),
  #   get_solutions(instructions, nodes, "QBJ", 15),
  #   get_solutions(instructions, nodes, "GTG", 15)
  # ]

  solutions = [
    build_solutions(18726, [1, 18726], 999999999),
    build_solutions(24252, [1, 24252], 999999999),
    build_solutions(18112, [1, 18112], 999999999),
    build_solutions(21489, [922, 21489], 999999999),
    build_solutions(8595, [13202, 8595], 999999999),
    build_solutions(4297, [11974, 4297], 999999999)
  ]

  # solutions.each { |p| puts p.inspect }
  
  matching_solutions = solutions[0] & solutions[1] & solutions[2] & solutions[3] & solutions[4] & solutions[5]
  puts matching_solutions.inspect
end
run

# GCF = 307
# I used a LCM calculator on 18727 + 24253 + 18113 + 22411 + 21797 + 16271