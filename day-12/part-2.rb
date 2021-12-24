require 'matrix'


def read_file(test: false, num: 1)
    File.readlines("./#{test ? "test" : "input"}-#{num}.txt").map(&:chomp)
end

def read_ans(num)
    File.read("./ans-2.#{num}.txt").chomp.to_i
end


class Node
    def initialize(symbol)
        @neighbours = {}
        @sym = symbol
    end

    def ref
        @sym
    end

    def add(node)
        @neighbours[node.ref] ||= node
    end

    def end?
        @sym == "end"
    end

    def start?
        @sym == "start"
    end

    def big?
        @sym.chars.all? { |c| /[[:upper:]]/.match(c) }
    end

    def small?
        !big?
    end

    def neighbours
        @neighbours.values
    end

    def to_s 
        ref + ": " + @neighbours.keys.join(" ")
    end

    def cannot_be_visited?(visited, visited_small_twice)
        start? ||
        visited_small_twice && visited[ref]
    end

    def get_paths(path=nil, visited={})
        path = path.nil? ? ref : path + "-" + ref
        if end?
            return [path]
        end
        if small?
            visited[ref] ||= 0
            visited[ref] += 1
        end
        paths = []
        visited_small_twice = visited.values.max != 1
        neighbours.each do |n|
            if n.cannot_be_visited?(visited, visited_small_twice)
                next
            end
            paths.append(n.get_paths(path, visited.clone))
        end
        paths.flatten
    end
end


class Graph
    def initialize
        @vertices = {}
    end

    def add_edge(edge_str)
        vertices = edge_str.chomp.split("-")
        @vertices[vertices.first] ||= Node.new(vertices.first)
        @vertices[vertices.last] ||= Node.new(vertices.last)
        @vertices[vertices.first].add(@vertices[vertices.last])
        @vertices[vertices.last].add(@vertices[vertices.first])
    end

    def get_all_paths
        @vertices["start"].get_paths()
    end

    def to_s
        @vertices.values.map{ |v| v.to_s }.join("\n")
    end
end


graph = Graph.new
file_num = 1
is_test = false

for line in read_file(test: is_test, num: file_num) do
    graph.add_edge(line)
end

paths = graph.get_all_paths

puts paths.length

if is_test && paths.length != read_ans(file_num)
    puts "ERROR: expected #{read_ans(file_num)}"
    # puts '', 'paths', paths
    # puts '', 'graph', graph.to_s
end
