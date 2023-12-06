
class Map
  attr_reader :min_destination

  def initialize(destination, source, range)
    @min_source = source.to_i
    @max_source = source.to_i + range.to_i
    @min_destination = destination.to_i
    @max_destination = destination.to_i + range.to_i
  end

  def valid?(source)
    source > @min_source && source < @max_source
  end

  def calc_location(source)
    offset = source - @min_source
    result = @min_destination + offset
  end

  def valid_reverse?(destination)
    destination > @min_destination && destination < @max_destination
  end

  def calc_location_reverse(destination)
    offset = destination - @min_destination
    result = @min_source + offset
  end
end

def build_maps(lines)
  result = {}

  target = ""
  lines.each do |l|
    if /(?<map>[a-z-]+) map:/ =~ l
      target = map
      result[target] = []
    end
    if /(?<destination>\d+) (?<source>\d+) (?<range>\d+)/ =~ l
      result[target] << Map.new(destination, source, range)
    end
  end

  result
end

def build_part1_seeds(line)
  line.scan(/ ([0-9]+)/).map { |n| n.first.to_i }  
end

def build_part2_ranges(line)
  ranges = []
  line.scan(/(\d+) r(\d+)/).each do |range|
    ranges << [range.first.to_i, range.last.to_i]
  end
  ranges
end

def part1
  lines = File.readlines("./input/day5.txt").map(&:chomp)
  puts "building seeds"
  # seeds = [271677840, 501735419, 683024018, 766856036, 1143559373, 1536929528, 1596797178, 1675236572, 1826692198, 2208447285, 2210947771, 2247774363, 2612325377, 2623755062, 3045792286, 3096853607, 3115360643]
  seeds = build_part1_seeds(lines[0])

  puts "building maps"
  maps_by_category = build_maps(lines[1..])
  # puts maps_by_category.inspect

  locations = seeds
  results = []
  puts "calculating solution"
  maps_by_category.each_pair do |k,v|
    # puts "#{k} results"

    # For each seed, if it doesn't match any map, add it to the results
    locations.each do |location|
      valid_maps = v.filter { |m| m.valid?(location) }
      if valid_maps.size == 0
        results << location
      else 
        # Otherwise add map result to results
        valid_maps.each do |map|
          results << map.calc_location(location)
        end
      end
    end
    
    # replace the input with the output so we can move to the next step
    locations = results.uniq
    results = []
    # puts locations.inspect
  end  
  
  puts "Part 1"
  puts locations.min
end
part1

def within_seed_ranges?(ranges, number)
  ranges.each do |r|
    if number >= r[0] && number <= r[0] + r[1]
      return true
    end
  end
  false
end

def part2
  lines = File.readlines("./input/day5.txt").map(&:chomp)
  ranges = build_part2_ranges(lines[0])

  maps_by_category = build_maps(lines[1..])
  reversed_maps = maps_by_category.to_a.reverse.to_h
  
  destinations = maps_by_category["humidity-to-location"].map { |m| m.min_destination }

  results = []
  reversed_maps.each_pair do |k,v|
    destinations.each do |destination|
      valid_maps = v.filter { |m| m.valid_reverse?(destination) }
      if valid_maps.size == 0
        results << destination
      else 
        # Otherwise add map result to results
        valid_maps.each do |map|
          results << map.calc_location_reverse(destination)
        end
      end
    end
    
    # replace the input with the output so we can move to the next step
    destinations = results.uniq
    results = []
  end

  seeds = destinations.filter { |d| within_seed_ranges?(ranges, d) }
  
  puts "Part 2"
  puts seeds.sort.inspect
end
part2
