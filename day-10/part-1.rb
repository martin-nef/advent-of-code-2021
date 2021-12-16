
@is_test = false

OPENING = "([{<".chars.to_a.freeze
CLOSING = ")]}>".chars.to_a.freeze


def read_file()
    if @is_test then
        return File.readlines('./test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end

def closing_to_opening(char)
    case char
    when ")" then "("
    when "]" then "["
    when "}" then "{"
    when ">" then "<"
    end
end

def get_score(invalid_char)
    case invalid_char
    when ")" then 3
    when "]" then 57
    when "}" then 1197
    when ">" then 25137
    end
end

@invalid_chars = []
@valid_lines = []

read_file.each do |line|

    invalid_char = nil
    opened_stack = []

    line.chars.each do |char|
        if OPENING.include? char
            opened_stack.push char
            next
        end
        if CLOSING.include? char
            expected = opened_stack.pop
            if closing_to_opening(char) != expected
                invalid_char = char
                break
            end
        end
    end

    if invalid_char == nil
        @valid_lines.append(line)
    else
        @invalid_chars.append(invalid_char)
    end

end

puts @invalid_chars.map { |char| get_score(char) }.sum
