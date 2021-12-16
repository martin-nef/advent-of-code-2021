
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

def opening_to_closing(char)
    case char
    when "(" then ")"
    when "[" then "]"
    when "{" then "}"
    when "<" then ">"
    end
end

def get_score(char)
    case char
    when ")" then 1
    when "]" then 2
    when "}" then 3
    when ">" then 4
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


scores = @valid_lines.map do |line|

    opened_stack = []

    line.chars.each do |char|
        if OPENING.include? char
            opened_stack.push char
            next
        end
        if CLOSING.include? char
            opened_stack.pop
        end
    end

    score = 0
    opened_stack.reverse.each do |char|
        score *= 5
        score += get_score(opening_to_closing(char))
    end

    score
end

middle_score = scores.sort.to_a[(scores.length/2).ceil]
puts middle_score
