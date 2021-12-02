lines = File.readlines('./input').map(&:chomp)

aim = 0
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
        depth = depth + aim * distance
    when "down"
        aim = aim + distance
    when "up"
        aim = aim - distance
    else
        throw "unexpected action #{}"
    end
end

puts depth * position

