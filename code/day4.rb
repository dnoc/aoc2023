

class Card
  attr_reader :id, :matches

  def initialize(line)  
    if /^Card\s+(?<id>\d{1,3}): (?<winners>[0-9 ]+) \| (?<numbers>[0-9 ]+)$/ =~ line
      @id = id
      @winners = winners.split " "
      @numbers = numbers.split " "
    end
    @matches = calc_matches
  end

  def calc_matches
    matches = 0
    @numbers.each do |n|
      if @winners.include?(n)
        matches += 1
      end
    end
    matches
  end

  def score
    if @matches > 0
      2**(@matches - 1)
    else
      0
    end
  end
end

def count_cards(cards, subset)
  # puts subset.map(&:id).inspect
  total = subset.size
  cards.each_with_index do |card, index|
    next unless subset.include?(card)
    matches = card.matches
    if matches > 0
      total += count_cards(cards, cards[index+1..index+matches])
    end
  end
  total
end

def run
  lines = File.readlines("./input/day4.txt").map(&:chomp)
  cards = lines.map { |l| Card.new(l) }

  puts "Part 1"
  puts cards.sum { |c| c.score }

  puts "Part 2"
  puts count_cards(cards, cards)
end
run