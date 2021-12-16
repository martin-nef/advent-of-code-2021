require 'matrix'

@is_test = false


def read_file()
    if @is_test then
        return File.readlines('./test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end


def exist?(vector, max)
    vector[0] <= max[0] &&
    vector[1] <= max[1] &&
    vector[0] >= 0 &&
    vector[1] >= 0
end


height_map = read_file.map{|line|line.split("").map(&:to_i)}
max_point = Vector[height_map.length-1, height_map.first.length-1]
total_risk = 0

for x in 0..height_map.length-1 do
    row = height_map[x]
    for y in 0..row.length-1 do
        adjacent = [
            Vector[x-1,y],
            Vector[x,y-1],
            Vector[x+1,y],
            Vector[x,y+1]
        ].select { |point| exist?(point, max_point) }

        is_low_point = adjacent.all? { |point| height_map[x][y] < height_map[point[0]][point[1]] }
        if is_low_point then
            if @is_test then puts "found low point at #{x},#{y} with height #{height_map[x][y]} surrounded with #{adjacent.join(" ")}" end
            total_risk += 1 + height_map[x][y]
        end
    end
end


puts "total_risk #{total_risk}"

if @is_test && total_risk != 15 then
    puts "Error, expected total risk to be 15"
end