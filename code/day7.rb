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
    
    if char_counts.has_key? "J"
      joker_special_case(char_counts)
    elsif char_counts[cards[0]] == 5
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

  def joker_special_case(char_counts)
    max = char_counts.max_by { |k, v| k == "J" ? 0 : v }[1]
    total = char_counts["J"] + max
    if total >= 5
      :five_of_a_kind
    elsif total == 4
      :four_of_a_kind
    elsif total == 3
      if char_counts["J"] == 1 && char_counts.values.sort == [1, 2, 2]
        :full_house
      else
        :three_of_a_kind
      end
    else
      :one_pair
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
    # puts "#{h.cards} #{h.bid} rank #{i}"
    # if h.type == :three_of_a_kind && h.cards.include?("J")
    #   puts "#{h.cards} rank #{i+1}"
    # end
    sum += h.bid * (i + 1)
  end
  sum
end

def value_of(card)
  if card == "A"
    14
  elsif card == "K"
    13
  elsif card == "Q"
    12
  elsif card == "J"
    1
  elsif card == "T"
    10
  else
    card.to_i
  end
end

def compare_cards(cards1, cards2)
  5.times do |i|
    a = cards1[i]
    b = cards2[i]
    if value_of(a) > value_of(b)
      return -1
    elsif value_of(a) < value_of(b)
      return 1
    end
  end
  puts "Should not be equal #{cards1} #{cards2}"
  0
end

# Too low 253009986
# Too low 253295076
def run
  lines = File.readlines("./input/day7.txt").map(&:chomp)
  hands = build_hands(lines)

  hands.each_pair do |k, v|
    hands[k] = v.sort { |a, b| compare_cards(a.cards, b.cards) }
  end

  puts get_sum(hands)
end
run