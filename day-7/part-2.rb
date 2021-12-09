@is_test = false

def read_file()
    if @is_test then
        return File.readlines('./test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end

input_file = read_file()
positions = input_file.first.chomp.split(",").map(&:chomp).map(&:to_i)

def get_cost(pos1, pos2)
    distance = (pos1 - pos2).abs
    cost = distance * (distance + 1) / 2
    if (cost%1 != 0) then
        puts "moving from #{pos1} to #{pos2} distance #{distance}"
        puts "cost was not an integer: #{cost}"
    end
    return cost
end

def get_total_cost(target_pos, positions)
    cost = 0
    for pos in positions do
        cost += get_cost(target_pos, pos)
    end
    if @is_test then
        puts "pos #{target_pos} cost #{cost}"
    end
    return cost.to_i
end

all_positions = (positions.min..positions.max).to_a
pos_cost_map = all_positions.map { |pos| { :pos=>pos, :cost=>get_total_cost(pos, positions) } }
min_cost_pos = pos_cost_map.min_by { |x| x[:cost] }
min_cost = min_cost_pos[:cost]
min_pos = min_cost_pos[:pos]

puts
puts "result:"
puts "pos #{min_pos} cost #{min_cost}"

if @is_test then
    if min_cost != 168 then
        puts "ERROR: expected cost to be 168, but got #{min_cost}"
    end
    if min_pos != 5 then
        puts "ERROR: expected position to be 5, but got #{min_pos}"
    end
end

