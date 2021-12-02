lines = File.readlines('./input').map(&:chomp)

increases = 0

for index in 1..lines.length()-1 do
    prev = lines[index-1]
    curr = lines[index]
    if curr > prev
        increases = increases + 1
    end
end

puts increases