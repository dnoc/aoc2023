
class Map
  def initialize(destination, source, range)
    @min_source = source.to_i
    @max_source = source.to_i + range.to_i
    @min_destination = destination.to_i
  end

  def valid?(source)
    source > @min_source && source < @max_source
  end

  def calc_location(source)
    offset = source - @min_source
    result = @min_destination + offset
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

def build_part2_seeds(line)
  seeds = []
  line.scan(/(\d+) r(\d+)/).each do |range|
    a = range.first.to_i
    b = range.first.to_i + range.last.to_i
    seeds << (a..b).to_a
  end
  seeds
end

def part1
  lines = File.readlines("./input/day5.txt").map(&:chomp)
  seeds = build_part1_seeds(line[0])

  maps_by_category = build_maps(lines[1..])
  # puts maps_by_category.inspect

  locations = seeds
  results = []
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
  
  puts locations.min
end

def part2
  lines = File.readlines("./input/day5.txt").map(&:chomp)
  
  maps_by_category = build_maps(lines[1..])
  reversed_maps = maps_by_category.to_a.reverse.to_h
  

  reversed_maps.each_pair do |k,v|
    # fuck this man
  end
  
end
part2