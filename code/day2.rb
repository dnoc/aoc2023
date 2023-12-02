class Game
  attr_reader :id

  def initialize(input)
    @id = input[/^Game (\d*):/, 1].to_i
    @max_blue = input.scan(/(\d*) blue/).map { |b| b.first.to_i }.max
    @max_green = input.scan(/(\d*) green/).map { |g| g.first.to_i }.max
    @max_red = input.scan(/(\d*) red/).map { |r| r.first.to_i }.max
  end

  def valid?
    @max_red < 13 && @max_green < 14 && @max_blue < 15
  end

  def minimum_set_power
    @max_blue * @max_green * @max_red
  end
end

def part_1(games)
  games.sum { |g| g.valid? ? g.id : 0 }
end

def part_2(games)
  games.sum { |g| g.minimum_set_power }
end

def run
  lines = File.readlines("./input/day2.txt")
  games = lines.map {|l| Game.new(l) }

  puts "Part 1:"
  puts part_1(games)

  puts "Part 2:"
  puts part_2(games)
end
run