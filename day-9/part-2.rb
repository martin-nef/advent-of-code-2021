require 'matrix'

@is_test = false




class Basin
    @@basins = []

    def initialize(low_point)
        @low_point = low_point
        @points = [low_point] + low_point.slopes
        if @@basins.all? { |basin| basin.ref != self.ref }
            @@basins.append(self)
        end
    end

    def self.set_height_map(height_map)
        @@height_map = height_map
    end

    def ref
        @points.map { |point| point.ref }.sort.join
    end

    def points
        @points
    end

    def low_point
        @low_point
    end

    def self.all
        @@basins
    end
end


class Point
    def initialize(x, y)
        @point = Vector[x,y]
    end

    def height
        @@height_map[@point[0]][@point[1]]
    end

    def is_lower_than?(other_point)
        height < other_point.height
    end

    def exist?
        x <= @@max_point.x &&
        y <= @@max_point.y &&
        x >= 0 &&
        y >= 0
    end

    def x
        @point[0]
    end

    def y
        @point[1]
    end

    def ref
        "#{x}#{y}"
    end

    def slopes
        adjacent_slopes = adjacent.select { |point| point.height < 9 && is_lower_than?(point) }
        all_slopes = adjacent_slopes + adjacent_slopes.map { |point| point.slopes }.flatten
        all_slopes.uniq { |point| point.ref }
    end

    def self.set_height_map(height_map)
        @@height_map = height_map
    end

    def self.set_max_point(max_point)
        @@max_point = max_point
    end

    private

    def adjacent
        [
            Point.new(x-1,y),
            Point.new(x,y-1),
            Point.new(x+1,y),
            Point.new(x,y+1)
        ].select { |point| point.exist? }
    end
end


def read_file()
    if @is_test then
        return File.readlines('./test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end


def get_basin(current_loc)
    if current_loc.height == 9
        return nil
    end

    Basin.new(current_loc)
end


height_map = read_file.map{|line|line.split("").map(&:to_i)}
max_point = Point.new(height_map.length-1, height_map.first.length-1)

Basin.set_height_map(height_map)
Point.set_height_map(height_map)
Point.set_max_point(max_point)

for x in 0..height_map.length-1 do
    row = height_map[x]
    for y in 0..row.length-1 do
        get_basin(Point.new(x,y))
    end
end

if @is_test
    puts Basin
        .all
        .sort { |basin| basin.points.length } 
        .map { |basin| basin.points.length }
        .join "\n"
end

puts Basin
    .all
    .map { |basin| basin.points.length }
    .max(3)
    .reduce(:*)
