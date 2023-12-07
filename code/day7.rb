class Hand
  attr_reader :cards, :bid, :type

  TYPES = [:five_of_a_kind, :four_of_a_kind, :full_house, :three_of_a_kind, :two_pair, :one_pair, :high_card]

  def initialize(cards, bid)
    @cards = cards
    @bid = bid.to_i
    @type = get_type(cards)
  end

  def get_type(cards)
    char_counts = cards.chars.each_with_object(Hash.new(0)) do |c, h|
      h[c] += 1
    end
    
    if char_counts[cards[0]] == 5
      :five_of_a_kind
    elsif char_counts[cards[0]] == 4 || char_counts[cards[1]] == 4
      :four_of_a_kind
    elsif char_counts.any? { |k, v| v == 3 }
      if char_counts.any? { |k, v| v == 2 }
        :full_house
      else
        :three_of_a_kind
      end
    else 
      twos = char_counts.select { |k, v| v == 2 }
      if twos.size == 2
        :two_pair
      elsif char_counts.select { |k, v| v == 2 }.size == 1  
        :one_pair
      else
        :high_card
      end
    end
  end
end

def build_hands(lines)
  hands = {
    five_of_a_kind: [],
    four_of_a_kind: [],
    full_house: [],
    three_of_a_kind: [],
    two_pair: [],
    one_pair: [],
    high_card: [],
  }
  lines.map do |l|
    if /^(?<cards>[A-Z2-9]{5}) (?<bid>\d+)$/ =~ l
      hand = Hand.new(cards, bid)
    end
    hands[hand.type] << hand
  end
  hands
end

def get_sum(hands)
  all_hands = []
  hands.values.each { |v| all_hands.concat(v) }

  sum = 0
  all_hands.reverse.each_with_index do |h, i|
    sum += h.bid * i
  end
  sum
end

def part1
  lines = File.readlines("./input/day7.txt").map(&:chomp)
  hands = build_hands(lines)

  # hands = hands.sort { |a, b|  }

  puts "Part 1"
  puts get_sum(hands)
end
part1