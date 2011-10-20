#!/usr/bin/env ruby

require "./marshalrepository"

# load collected data

repository = MarshalRepository.new 'collected-data'
search_results_by_query = repository.retrieve

1.times do
    compared_engines = [:bing, :yahoo]

    search_results_by_query.each do |key, value|
        # Stub
        puts key
        puts value.keys
    end
end


