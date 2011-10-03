require "./searchbot"

class MarshalRepository
    def initialize file_name
        @file_name = file_name
    end

    def save obj
        dump = Marshal::dump obj

        File.open(@file_name, "w") do |file|
            file.puts dump
        end
    end

    def retrieve
        File.open(@file_name) do |file|
            Marshal::load file.read
        end
    end

end

