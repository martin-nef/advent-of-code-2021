test = false
log = false

lines = []
if test then
    lines = File.readlines('./test-input').map(&:chomp)
else
    lines = File.readlines('./input').map(&:chomp)
end

inputWidth = lines.first().length()-1
bits = Array.new(inputWidth, nil);

for index in 0..lines.length()-1 do
    line = lines[index]
    for bit in 0..inputWidth do
        if (bits[bit] == nil) then
            bits[bit] = []
        end
        bits[bit].append(line[bit])
    end
end

for bit in 0..inputWidth do
    if (bits[bit].length() != lines.length()) then
        throw "#bit #{bit} bits[bit].length() != lines.length() #{bits[bit].length()} != #{lines.length()}"
    end
    bitsExpected = lines.map { |line| line[bit] }.join('')
    bitsHave = bits[bit].join('')
    if bitsHave != bitsExpected then
        throw "#bit #{bit} expected\n#{bitsExpected} got\n#{bitsHave}\n\n"
    end
end

gammaRateBits = []
epsilonRateBits = []

for bit in 0..inputWidth do
    nills = bits[bit].count('0')
    ones = bits[bit].count('1')
    bitsHave = bits[bit].join('')

    if log then puts "\n#bit #{bit} (#{nills} nills, #{ones} ones):\n\n#{bitsHave}\n\n" end

    if nills + ones != lines.length() then throw "nills + ones != lines.length() at bit ##{bit}" end
    if nills == 0 then throw "no nills at bit ##{bit}" end
    if ones == 0 then throw "no ones at bit ##{bit}" end
    if nills == ones then throw "same number of nulls and ones at bit ##{bit}" end

    if nills > ones then
        gammaRateBits.append(0)
        epsilonRateBits.append(1)
    else
        gammaRateBits.append(1)
        epsilonRateBits.append(0)
    end
end

gammaRateBinary = gammaRateBits.join('')
epsilonRateBinary = epsilonRateBits.join('')

if log then
    puts "gammaRateBinary\t\t#{gammaRateBinary}"
    puts "epsilonRateBinary\t#{epsilonRateBinary}"
end
if test && gammaRateBinary != '10110' then
    puts "gamma rate was #{gammaRateBinary} but should have been 10110"
end
if test && epsilonRateBinary != '01001' then
    puts "epsilon rate was #{epsilonRateBinary} but should have been 01001"
end

gammaRate = gammaRateBinary.to_i(2)
epsilonRate = epsilonRateBinary.to_i(2)

if log then
    puts "gammaRate\t#{gammaRate}"
    puts  "epsilonRate\t#{epsilonRate}"
end
if test && gammaRate != 22 then
    puts "gamma rate was #{gammaRate} but should have been 22"
end
if test && epsilonRate != 9 then
    puts "epsilon rate was #{epsilonRate} but should have been 9"
end

puts gammaRate * epsilonRate
