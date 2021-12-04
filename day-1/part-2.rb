@is_test = false

if @is_test then
    values = File.readlines('./test-input-2').map(&:chomp)
else
    values = File.readlines('./input-2').map(&:chomp)
end

increases = 0

for i in 3..values.length-1 do
    prev = values[i-1].to_i + values[i-2].to_i + values[i-3].to_i
    curr = values[i].to_i + values[i-1].to_i + values[i-2].to_i

    if curr > prev then
        increases = increases + 1
    end
end


if @is_test && increases != 5 then
    throw "expected increases 5 but got #{increases}"
end

puts increases
