TEST_INPUT = ["1abc2","pqr3stu8vwx","a1b2c3d4e5f","treb7uchet"]
TEST_INPUT2 = ["two1nine","eightwothree","abcone2threexyz","xtwone3four","4nineeightseven2","zoneight234","7pqrstsixteen"]

def unspell_digits(input)
  digits = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
  digits.each do |d|
    while input.include?(d)
      i = input.index(d)
      value = digits.index(d) + 1
      unless i.nil?
        input.insert(i + 2, value.to_s)
      end
    end
  end
  input
end

def harvest_numbers(input)
  input.chomp!
  if input.nil? || input.empty?
    console.log("empty string")
    return 0
  end

  number_string = input.delete "a-z"
  unless number_string.match?(/^\d*$/)
    puts "ya goofed!!"
    puts number_string
  end

  digits = if number_string.length == 0
    "0"
  else
    number_string[0] + number_string[-1]
  end

  digits.to_i
end

def run_test
  coords = TEST_INPUT.map { |s| harvest_numbers(s) }

  coords.sum
end

def run_test2
  coords = TEST_INPUT2.map do |s|
    unspelled = unspell_digits(s)
    puts unspelled
    harvest_numbers(unspelled)
  end

  coords.sum
end

def get_solution
  lines = File.readlines('input/day1.txt')
  coords = lines.map do |s|
    unspelled = unspell_digits(s)
    puts unspelled
    harvest_numbers(unspelled)
  end

  coords.sum
end