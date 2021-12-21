require 'matrix'
require_relative './test-result'
include TestResult

@is_test = false

def read_file()
    if @is_test
        return File.readlines('./test-1.txt').map(&:chomp)
    else
        return File.readlines('./input-1.txt').map(&:chomp)
    end
end

def bold(str)
    "\e[5m#{str}\e[25m"
end


def str(matrix)
    matrix.to_a.map { |row| row.to_a.join("").chomp }.to_a.join("\n").chomp
end

def print(matrix)
    matrix_string = matrix.is_a?(Matrix) ? str(matrix) : matrix
    matrix_string = matrix_string.gsub("0", bold("0"))
    puts matrix_string
end


def try_flash(row, col, energy_levels, flashes)

    if energy_levels[row,col] > 9 && flashes[row,col] == 0

        flashes[row,col] += 1
        res = receive_flash(row-1, col-1, energy_levels, flashes)
        energy_levels = res[:e]
        flashes = res[:f]
        res = receive_flash(row-1, col, energy_levels, flashes)
        energy_levels = res[:e]
        flashes = res[:f]
        res = receive_flash(row-1, col+1, energy_levels, flashes)
        energy_levels = res[:e]
        flashes = res[:f]
        res = receive_flash(row, col+1, energy_levels, flashes)
        energy_levels = res[:e]
        flashes = res[:f]
        res = receive_flash(row+1, col+1, energy_levels, flashes)
        energy_levels = res[:e]
        flashes = res[:f]
        res = receive_flash(row+1, col, energy_levels, flashes)
        energy_levels = res[:e]
        flashes = res[:f]
        res = receive_flash(row+1, col-1, energy_levels, flashes)
        energy_levels = res[:e]
        flashes = res[:f]
        res = receive_flash(row, col-1, energy_levels, flashes)
        energy_levels = res[:e]
        flashes = res[:f]
    end

    return { e: energy_levels, f: flashes }
end

def receive_flash(row, col, energy_levels, flashes)
    if row < 0 || col < 0 ||
        row >= energy_levels.row_count ||
        col >= energy_levels.column_count
        return { e: energy_levels, f: flashes }
    end

    energy_levels[row,col] += 1
    return try_flash(row, col, energy_levels, flashes)
end

def reset(row, col, energy_levels)
    if energy_levels[row,col] > 9
        energy_levels[row,col] = 0
    end

    energy_levels
end

def diff(a, b)
    diff = []
    lines_a = a.split("\n")
    lines_b = b.split("\n")
    (0..lines_a.length-1).each do |i|
        if lines_a[i] != lines_b[i]
            diff.append("#{i}: #{lines_a[i]} #{lines_b[i]}")
        end
    end

    diff.join"\n"
end

rows = read_file.map { |row| row.split("").map(&:to_i).to_a }.to_a
energy_levels = Matrix.rows(rows)
puts "step 0"
print energy_levels

ones = Matrix.build(energy_levels.row_count, energy_levels.column_count) { |_,_| 1 }
max_flashes = ones.to_a.flatten.sum
sync_step = 0
step = 0

loop do
    step += 1
    flashes = Matrix.build(energy_levels.row_count, energy_levels.column_count) { |_,_| 0 }
    energy_levels += ones

    total_flashes_before = 0
    total_flashes_after = -1

    while total_flashes_before != total_flashes_after do
        total_flashes_before = flashes.to_a.flatten.sum

        energy_levels.each_with_index do |_, row, col|
            res = try_flash(row, col, energy_levels, flashes)
            energy_levels = res[:e]
            flashes = res[:f]
        end

        total_flashes_after = flashes.to_a.flatten.sum
    end

    if total_flashes_after == max_flashes
        sync_step = step
        break
    end
    
    energy_levels.each_with_index do |_, row, col|
        energy_levels = reset(row, col, energy_levels)
    end

    if @is_test && !EXPECTED[step].nil? && EXPECTED[step] != str(energy_levels)
        actual = str(energy_levels)
        puts
        puts "ERROR at step #{step}"
        puts "diff (expected - actual)"
        print diff(EXPECTED[step], str(energy_levels))
        puts
        puts "flashes"
        print flashes
        break
    elsif @is_test
        puts
        puts "step #{step}"
        print energy_levels
        puts
    end
end


puts
puts sync_step

if @is_test && sync_step != 195
    puts "ERROR: expected to sync after 195 steps"
end
