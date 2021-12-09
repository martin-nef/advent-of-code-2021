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

def get_cost(target_pos, positions)
    cost = 0
    for pos in positions do
        cost += (target_pos - pos).abs
    end
    if @is_test then
        puts "pos #{target_pos} cost #{cost}"
    end
    return cost.to_i
end

pos_cost_map = positions.map { |pos| { :pos=>pos, :cost=>get_cost(pos, positions) } }
min_cost_pos = pos_cost_map.min_by { |x| x[:cost] }
min_cost = min_cost_pos[:cost]
min_pos = min_cost_pos[:pos]

puts
puts "result:"
puts "pos #{min_pos} cost #{min_cost}"

if @is_test then
    if min_cost != 37 then
        puts "ERROR: expected cost to be 37, but got #{min_cost}"
    end
    if min_pos != 2 then
        puts "ERROR: expected position to be 2, but got #{min_pos}"
    end
end

