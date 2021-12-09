@is_test = false
@only_horizontal_or_vertical_lines = false

def read_file()
    if @is_test then
        return File.readlines('./test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end


class Point
    def initialize(x,y)
        @x = x
        @y = y
        @lines = 0
    end

    def x()
        @x
    end

    def y()
        @y
    end
    
    def lines()
        @lines
    end

    def add_line()
        @lines += 1
    end

    def str()
        return "#{@x},#{@y}"
    end
end


class Line
    def initialize(a,b)
        @a = a
        @b = b
    end

    def a()
        @a
    end

    def b()
        @b
    end

    def str()
        return "#{@a.x},#{@a.y} -> #{@b.x},#{@b.y}"
    end

    def points()
        points = []
        x = get_x(@a.y)
        y = get_y(@a.x)
        if x != @a.x then throw "expected x #{@a.x} but got #{x}" end
        if y != @a.y then throw "expected y #{@a.y} but got #{y}" end
        x_vals = [@a.x, @b.x].uniq.sort
        if x_vals.count > 1 then
            x_range = x_vals.first..x_vals.last
            for x in x_range do
                points.append(Point.new(x, get_y(x)))
            end
        else
            y_vals = [@a.y, @b.y].uniq.sort
            y_range = y_vals.first..y_vals.last
            for y in y_range do
                points.append(Point.new(get_x(y), y))
            end
        end

        points_str = "#{points.map { |p| p.str }.join "  "}"
        if points.find { |p| p.x == @a.x && p.y == @a.y } == nil then throw "Could not find #{@a.str} in line #{str} points were #{points_str}" end
        if points.find { |p| p.x == @b.x && p.y == @b.y } == nil then throw "Could not find #{@b.str} in line #{str} points were #{points_str}" end
        
        return points
    end

    private
    def slope()
        if (@a.x - @b.x) == 0 then
            return nil
        end
        return (@a.y - @b.y) / (@a.x - @b.x)
    end

    def get_x(y)
        m = slope()

        if m == 0 || m == nil then
            return @a.x
        end

        x = (y - @a.y) / m + @a.x
        return x
    end

    def get_y(x)
        m = slope()

        if m == 0 || m == nil then
            return @a.y
        end

        y = ((m * x) - (m * @a.x) + @a.y)
        return y
    end
end


def parse_lines(input_file)
    lines = []

    for line in input_file do
        a,b = line.split(" -> ")
            .map { |point| point.split "," }
            .map { |x,y| Point.new x.to_i, y.to_i }
        lines.append(Line.new a,b)
    end

    return lines
end


def make_map(lines)
    max_x = lines.map { |line| [line.a.x, line.b.x] }.flatten.max
    max_y = lines.map { |line| [line.a.y, line.b.y] }.flatten.max
    points = Array.new(max_x + 1)
    for x in 0..max_x do
        points[x] = Array.new(max_y + 1)
        for y in 0..max_y do
            points[x][y] = Point.new(x,y)
        end
    end
    points
end


def draw_lines(points, lines)
    line_points = lines.map { |line| line.points }.flatten
    for point in line_points do
        x,y = point.x, point.y
        points[x][y].add_line()
    end
    return points
end


def print(points)
    puts points.map {
        |row| row.map { |point| point.lines > 0 ? point.lines.to_s : '.' } .to_a.join('')
    }.join("\n")
    puts
end

input_file = read_file()
if @is_test then
    puts input_file.join "\n"
    puts
end

lines = parse_lines(input_file)
if @only_horizontal_or_vertical_lines then
    lines = lines.select { |line| line.a.x == line.b.x || line.a.y == line.b.y }
end
if @is_test then
    puts lines.map { |line| "#{line.a.x},#{line.a.y} -> #{line.b.x},#{line.b.y}" }.join "\n"
    puts
end

points = make_map(lines)
if @is_test then print(points) end

points = draw_lines(points, lines)
if @is_test then print(points) end

overlapping_points = points.map {
    |row| row.select { |point| point.lines >= 2 }.count
}.sum

puts overlapping_points

if @is_test && overlapping_points != 12 then
    throw "expected 12 overlapping points, but got #{overlapping_points}"
end
