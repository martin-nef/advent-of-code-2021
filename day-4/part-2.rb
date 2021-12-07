@is_test = false


class BingoNumber
    @number = nil
    @is_marked = false

    def initialize(number)
        @number = number.to_s.chomp.to_i
    end

    def try_mark(number)
        if (number == @number) then
            @is_marked = true
        end
    end

    def get_number()
        return @number.to_i
    end

    def is_marked?()
        return @is_marked
    end
end


class Board
    @rows = nil
    @@count = 0
    @count = 0

    def initialize(board_text)
        @rows = parse_board(board_text)
        @cols = get_columns(@rows)
        @@count += 1
        @count = @@count
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

    def count()
        @count
    end
    
    def mark(number_to_mark)
        for row in @rows do
            for number in row do
                number.try_mark(number_to_mark)
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

    def score(last_number_drawn)
        score = 0

        for row in @rows do
            for number in row do
                if (!number.is_marked?) then
                    score += number.get_number
                end
            end
        end

        return last_number_drawn * score
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
    return input_file.first.chomp.split(',').map(&:chomp).map{ |num| num.to_i }
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
        number_of_boards = boards.length()
        winners = []

        for board in boards do
            board.mark(number)
            is_winner = board.is_winner?
            last_board = boards.length() == 1

            if is_winner && last_board then
                return board, number
            end

            if is_winner then
                winners.append(board)
            end
        end

        for winner in winners do
            boards.delete(winner)
        end
    end

    return nil, nil
end

input_file = read_file()
numbers = draw_numbers(input_file)
boards = build_boards(input_file)
winner, winning_number = play_bingo(boards, numbers)

puts "winner ##{winner.count}"
puts winning_number
puts winner
puts winner.score(winning_number)

if @is_test && winner.score(winning_number) != 1924 then
    throw "expected score of 1924, but got #{winner.score(winning_number)}"
end
