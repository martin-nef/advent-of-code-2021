require 'json'
require 'set'

@is_test = false
@is_mini_test = false

def read_file()
    if @is_test then
        return File.readlines(@is_mini_test ? './mini-test.txt' : './test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end


def read_answers()
    return File.readlines('./test-answer-1.txt').map(&:chomp)
end


def format_code(code)
    code.chars.sort.uniq.join""
end


def print(input)
    signals = input[:signal_patterns].map{|code|code.chars.sort.join""}.join"\n"
    codes = input[:outputs].map{|code|code.chars.sort.join""}.join"\n"
    digits = h_concat(input[:outputs].map{|code|print_digit(code)})
    "#{h_concat([signals, codes])}\n\n#{digits}\n\n\n\n"
end

def print_h_row(letter)
    " #{letter*4} \n"
end

def print_v_row(left, right)
    "#{left}    #{right}\n"*2
end



def print_digit(code, map=nil)
    if map == nil then
        map = {
            :a => 'a',
            :b => 'b',
            :c => 'c',
            :d => 'd',
            :e => 'e',
            :f => 'f',
            :g => 'g'
        }
    end
    a = code.include?(map[:a]) ? map[:a] : ' '
    b = code.include?(map[:b]) ? map[:b] : ' '
    c = code.include?(map[:c]) ? map[:c] : ' '
    d = code.include?(map[:d]) ? map[:d] : ' '
    e = code.include?(map[:e]) ? map[:e] : ' '
    f = code.include?(map[:f]) ? map[:f] : ' '
    g = code.include?(map[:g]) ? map[:g] : ' '

    print_h_row(a) +
    print_v_row(b, c) +
    print_h_row(d) +
    print_v_row(e, f) +
    print_h_row(g)
end

def h_concat(strs, sep="\t")
    a = strs.first
    lines_a = a.split"\n"
    for i in 1..strs.length-1 do 
        b = strs[i]
        lines_b = b.split"\n"
        for l in 0..lines_a.length-1 do
            if lines_b[l] != nil then
                lines_a[l] += sep + lines_b[l]
            end
        end
    end
    return lines_a.join"\n"
end


def get_possible_digits(code)
    case code.length
    when 2
        [1]
    when 4
        [4]
    when 3
        [7]
    when 7
        [8]
    when 6
        [0,6,9]
    when 5
        [2,3,5]
    end
end


def populate_map(code, num_to_wire_map)
    digits = get_possible_digits(code)
    digits.each do |d|
        num_to_wire_map[d] ||= []
        num_to_wire_map[d].append(format_code(code))
    end
    num_to_wire_map
end


def set(str)
    if str.is_a?(String) then
        Set.new(str.chars)
    end
    if str.respond_to?(:first) then
        Set.new(str.first.chars)
    end
end


def update_map(code, num_to_wire_map)
    code = format_code(code)
    char_set = Set.new(code.chars)
    # easy: 1 4 7 8
    top_segment = set(num_to_wire_map[7]) - set(num_to_wire_map[1])
    right_segments = set(num_to_wire_map[7]) - top_segment
    bd_segments = set(num_to_wire_map[4]) - right_segments
    eg_segments = set(num_to_wire_map[8]) - set(num_to_wire_map[4]) - top_segment

    case code.length
    when 6 # [0,6,9]
        if char_set >= bd_segments then
            num_to_wire_map[0].delete(code)
        end
        if char_set >= eg_segments then 
            num_to_wire_map[9].delete(code)
        end
        if char_set >= right_segments then 
            num_to_wire_map[6].delete(code)
        end
    when 5 # [2,3,5]
        if char_set >= bd_segments then 
            num_to_wire_map[2].delete(code)
            num_to_wire_map[3].delete(code)
        end
        if char_set >= eg_segments then 
            num_to_wire_map[3].delete(code)
            num_to_wire_map[5].delete(code)
        end
        if char_set >= right_segments then 
            num_to_wire_map[2].delete(code)
            num_to_wire_map[5].delete(code)
        end
    end

    num_to_wire_map
end


def decode(input)

    num_to_wire_map = {}
    for code in input[:signal_patterns] do
        populate_map(code, num_to_wire_map)
    end

    for code in input[:signal_patterns] do
        update_map(code, num_to_wire_map)
    end

    non_decrypted = num_to_wire_map.select{ |k,v| v.length != 1 }
    if non_decrypted.any? then
        throw "undecrypted: " + JSON.pretty_generate(non_decrypted)
    end

    # puts JSON.pretty_generate(num_to_wire_map)

    wires_to_num_map = num_to_wire_map
        .map{|k,v|[v.first,k]}
        .to_h

    outputs = input[:outputs].map do |code|
        wires_to_num_map[format_code(code)]
    end

    outputs.join("").to_i
end



input_file = read_file()
inputs = input_file
    .map{ |line| line.split("|") }
    .map{ |line| { :signal_patterns=>line.first.split(" ").map(&:chomp), :outputs=>line.last.split(" ").map(&:chomp) } }

    
decoded = inputs.map do |input|
    input[:output] = decode(input)
    input
end



output_sum = decoded.map{|input|input[:output]}.sum

outputs = decoded.map do |input|
    "#{input[:signal_patterns].join" "}: #{input[:output]}"
end

puts "output_sum #{output_sum}"

if @is_test && @is_mini_test && output_sum != 5+3+5+3 then
    puts "ERROR: expected output to be 5+3+5+3, but got #{output_sum}"
end
if @is_test && !@is_mini_test then
    answers = Set.new(read_answers)
    outputs = Set.new(outputs)
    missing = outputs - answers
    if missing.any? then
        puts "ERROR: missing #{missing.size} answers:"
        puts "\t#{missing.to_a.join("\n\t")}"
        puts "ERROR: have outputs:"
        puts "\t#{outputs.to_a.join("\n\t")}"
    end
end
if @is_test && !@is_mini_test && output_sum != 61229 then
    puts "ERROR: expected output sum to be 61229, but got #{output_sum}"
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
