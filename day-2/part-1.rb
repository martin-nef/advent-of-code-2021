lines = File.readlines('./input').map(&:chomp)

depth = 0
position = 0

for index in 0..lines.length()-1 do
    line = lines[index]
    words = line.split
    action = words[0]
    distance = words[1].to_i
    
    case action
    when "forward"
        position = position + distance
    when "down"
        depth = depth + distance
    when "up"
        depth = depth - distance
    else
        throw "unexpected action #{}"
    end
end

puts depth * position
