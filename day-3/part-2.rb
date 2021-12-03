
@is_test = false

def get_bit_columns(values)
    inputWidth = values.first.length
    bits = Array.new(inputWidth, nil)

    for index in 0..values.length-1 do
        for bit in 0..inputWidth-1 do
            if (bits[bit] == nil) then
                bits[bit] = []
            end
            bits[bit].append values[index][bit]
        end
    end

    return bits
end

def find_most_common_bit(bits)
    nills = bits.count('0')
    ones = bits.count('1')

    if ones >= nills then
        return '1'
    else
        return '0'
    end
end

def find_least_common_bit(bits)
    nills = bits.count('0')
    ones = bits.count('1')

    if nills <= ones then
        return '0'
    else
        return '1'
    end
end

def find_common_bit(bits, most_common)
    if most_common then
        return find_most_common_bit(bits)
    else
        return find_least_common_bit(bits)
    end
end

def get_values_with_bit_at(values, bit, bit_at)
    remaining = values.select { |value| value[bit_at] == bit }

    if remaining.length == 0
        return [values.last]
    end

    return remaining
end

def find_rating(values, most_common)
    inputWidth = values.first.length

    for bit_index in 0..inputWidth-1 do
        bit_columns = get_bit_columns(values)
        common_bit = find_common_bit(bit_columns[bit_index], most_common)
        values = get_values_with_bit_at(values, common_bit, bit_index).to_a
        if values.length == 1
            return values.first
        end
    end

    throw "didn't find rating, values left #{values.join ','}"
end

def get_values()
    if @is_test then
        values = File.readlines('./test-input-2').map(&:chomp)
    else
        values = File.readlines('./input-2').map(&:chomp)
    end
end

oxygenGeneratorRating = find_rating(get_values(), true).to_i(2)
co2ScrubberRating = find_rating(get_values(), false).to_i(2)

puts oxygenGeneratorRating * co2ScrubberRating
