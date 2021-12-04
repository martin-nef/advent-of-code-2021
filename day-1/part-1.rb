lines = File.readlines('./input-1').map(&:chomp)

increases = 0

for index in 1..lines.length()-1 do
    prev = lines[index-1].to_i
    curr = lines[index].to_i
    if curr > prev
        increases = increases + 1
    end
end

puts increases