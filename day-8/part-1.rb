@is_test = false

def read_file()
    if @is_test then
        return File.readlines('./test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end

input_file = read_file()
inputs = input_file
    .map{ |line| line.split("|") }
    .map{ |line| { :signal_patterns=>line.first.split(" "), :outputs=>line.last.split(" ") } }

outputs = inputs.map { |x| x[:outputs] }.flatten
num_easy = outputs.select { |output| [2,4,3,7].include?(output.length) }.count

puts num_easy

if @is_test && num_easy != 26 then
    puts "ERROR: expected number of easy digits to be 26, but got #{num_easy}"
end

# digit - #segments
# 0 - 6
# 1 - 2
# 2 - 5
# 3 - 5
# 4 - 4
# 5 - 5
# 6 - 6
# 7 - 3
# 8 - 7
# 9 - 6
# UNIQUE
# 1 - 2
# 4 - 4
# 7 - 3
# 8 - 7
