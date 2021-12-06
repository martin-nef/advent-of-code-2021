@is_test = true


class BingoNumber
    @number = nil
    @is_marked = false

    def initialize(number)
        @number = number.to_s.chomp
    end

    def try_mark(number)
        number = number.to_s.chomp
        if (number == @number) then
            puts "number #{number} marked"
            @is_marked = true
        end
    end

    def get_number()
        return @number
    end

    def is_marked?()
        return @is_marked
    end
end


class Board
    @rows = nil

    def initialize(board_text)
        @rows = parse_board(board_text)
        @cols = get_columns(@rows)
    end

    def to_s()
        return @rows
            .map{ |row|
                row.map{ |num|
                    num.is_marked? ? "\e[1m#{num.get_number}\e[22m" : num.get_number
                }.join("\t")
            }
            .join("\n")
    end

    def mark(number)
        for row in @rows do
            for number in row do
                number.try_mark(number)
            end
        end
    end

    def is_winner?()
        bingo_row = @rows.find { |row| row.all? { |num| num.is_marked? } }

        if bingo_row != nil then
            return true
        end

        bingo_col = @cols.find { |col| col.all? { |num| num.is_marked? } }

        if bingo_col != nil then
            return true
        end

        return false
    end

    def score()
        return 
    end

    private
    def get_columns(rows)
        columns = []
        for row in rows do
            for col_index in 0..row.length()-1 do
                if columns.length() < col_index+1 then
                    columns.append([])
                end
                columns[col_index].append(row[col_index])
            end
        end
        return columns
    end

    def parse_board(board_text)
        rows = []
        for row in board_text.chomp().split("\n").map(&:chomp) do
            numbers = row
                .split(" ")
                .map(&:chomp)
                .map { |num| BingoNumber.new num }
            rows.append(numbers.to_a)
        end
        return rows
    end
end


def read_file()
    if @is_test then
        return File.readlines('./test-input-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end


def draw_numbers(input_file)
    return input_file.first.split(',')
end


def build_boards(input_file)
    boards = []
    boards_as_text = input_file.drop(2).join("\n").split("\n\n")
    for board_text in boards_as_text do
        boards.append(Board.new(board_text))
    end
    return boards
end


def play_bingo(boards, numbers)
    for number in numbers do
        for board in boards do
            board.mark(number)
            if board.is_winner? then
                return board
            end
        end
    end
end

input_file = read_file()
numbers = draw_numbers(input_file)
boards = build_boards(input_file)

for board in boards do
    puts board
    puts
end

winner = play_bingo(boards, numbers)

for board in boards do
    puts board
    puts
end

puts "winner"
puts winner.to_s
