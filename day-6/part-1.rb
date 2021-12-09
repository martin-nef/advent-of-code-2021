@is_test = false

def read_file()
    if @is_test then
        return File.readlines('./test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end

input_file = read_file()
if @is_test then
    puts input_file.join "\n"
    puts
end

fish = input_file.first.split(",").map(&:to_i)
days = 80

def multiply(fish)
    new_fish = fish.map.to_a
    for i in 0..fish.length - 1 do
        if fish[i] == 0 then
            new_fish[i] = 6
            new_fish.append(8)
        else
            new_fish[i] -= 1 
        end
    end
    return new_fish
end

for day in 1..days do
    fish = multiply(fish)
end

puts fish.count

if @is_test && fish.count != 5934 then
    throw "expected there to be 5934 fish, but have #{fish.count}"
end
