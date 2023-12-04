

class Card
  def initialize(line)
    if /^Card \d{1,3}: (?<winners>[0-9 ]+) \| (?<numbers>[0-9 ]+)$/ =~ line
      @winners = winners.split " "
      @numbers = numbers.split " "
    end
  end

  def score
    matches = 0
    @numbers.each do |n|
      if @winners.include?(n)
        matches += 1
      end
    end

    if matches == 0
      return 0
    end
    2**(matches - 1)
  end
end

def run
  lines = File.readlines("./input/day4.txt").map(&:chomp)
  cards = lines.map { |l| Card.new(l) }

  puts "Part 1"
  puts cards.sum { |c| c.score }

  puts "Part 2"
end
run