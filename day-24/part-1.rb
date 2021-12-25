

# frozen_string_literal: true


class ALU
    def initialize
        @inputs = []
        @memory = {
            "w" => 0,
            "x" => 0,
            "y" => 0,
            "z" => 0
        }
    end

    def run_program(inputs:, program:)
        if inputs.any? { |i| i.nil? }
            raise "Found nil in input"
        end
        @inputs = inputs
        # puts "running program"
        command_no = 0
        for line in program do
            # puts "#{command_no}: #{line}"
            run_command(line)
            command_no += 1
        end
        @memory
    end

    def run_command(line)
        words = line.split" "
        command = words.first
        begin
            send(command, words.drop(1).to_a)
            validate_memory()
        rescue
            puts "ERROR in command: #{line}"
            puts "state", {
                first_arg: @memory[words.drop(1).first],
                last_arg: val(words.last),
                memory: @memory
            }
            raise
        end
    end

    private

    def val(second_input)
        second_input.match?(/[[:digit:]]/) ? second_input.to_i : @memory[second_input]
    end

    def validate_memory
        @memory.each do |k,v|
            if v.nil?
                raise "ERROR: memory invalid"
            end
        end
    end


    def inp(args)
        @memory[args.first] = @inputs.shift
    end

    def add(args)
        a, b = args
        @memory[a] += val(b)
    end

    def mul(args)
        a, b = args
        @memory[a] *= val(b)
    end

    def div(args)
        a, b = args
        @memory[a] = (@memory[a] / val(b)).to_i
    end

    def mod(args)
        a, b = args
        @memory[a] %= val(b)
    end

    def eql(args)
        a, b = args
        @memory[a] = @memory[a] == val(b) ? 1 : 0
    end

end


class MONAD
    def self.valid?(model_number)
        @@program ||= File.readlines("./monad.txt").map(&:chomp)
        alu = ALU.new
        memory = alu.run_program(inputs: model_number.to_s.chars.map{|c|c.to_i}, program: @@program)
        memory[:z] == 0
    end
end


def decrement(model_number)
    loop do
        model_number = (model_number.to_i - 1).to_s
        if !model_number.include?"0"
            break
        end
    end
    model_number
end


model_number = '99999999999999'
i = 0

loop do
    if MONAD.valid?(model_number)
        break
    end
    if i%10000 == 0
        puts "#invalid #{model_number}"
    end
    model_number = decrement(model_number)
    i += 1
end


puts "", "valid", model_number
