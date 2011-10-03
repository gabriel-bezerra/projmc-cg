#!/usr/bin/env ruby

require "./marshalrepository"

repository = MarshalRepository.new 'collected-data'
search_results_by_query = repository.retrieve

search_results_by_engine = {}
search_results_by_engine.default = []

search_results_by_query.each do |query, engine_results|
    engine_results.each do |engine, results|
        search_results_by_engine[engine] += results
    end
end


search_results_by_engine.each do |engine, results|
    puts "#{engine}: #{results.length}"

    results.each do |r|
        puts "\t#{r.rank} - #{r.title} - #{r.url}"
    end
end
