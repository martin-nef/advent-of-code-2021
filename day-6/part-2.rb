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
fish = fish.group_by { |f| f }
fish.each_key do |key|
    fish[key] = fish[key].count 
end
puts fish
days = 256

def multiply(fish)
    new_fish = {}
    for age in 0..8
        new_fish[age] = 0
    end

    for age in 0..8
        if age == 0 then
            new_fish[8] += fish[0] || 0
            new_fish[6] += fish[0] || 0
        else
            new_fish[age-1] += fish[age] || 0
        end
    end

    return new_fish
end

def total_pop(fish)
    total = 0
    fish.each_key do |age|
        total += fish[age]
    end
    return total
end

for day in 1..days do
    fish = multiply(fish)
    if @is_test then
        fish_population = total_pop(fish)
        if day == 80 && fish_population != 5934 then
            throw "expected there to be 5934 fish, but have #{fish_population}"
        end
        if day == 256 && fish_population != 26984457539 then
            throw "expected there to be 5934 fish, but have #{fish_population}"
        end
        puts "day #{day} fish #{total_pop(fish)}"
        puts fish
    end
end

fish_population = total_pop(fish)
puts fish_population
puts

if @is_test && fish_population != 26984457539 then
    throw "expected there to be 26984457539 fish, but have #{fish_population}"
end
