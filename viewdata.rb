#!/usr/bin/env ruby

require "./marshalrepository"

repository = MarshalRepository.new 'collected-data'
search_results_by_query = repository.retrieve

# parameter:
#   search_results_by_query {query => {:engine => [res1, res2, ...]}}
#
# return:
#   {:engine => [res1, res2, ...]} with all the results for all the queries in the
#   engine's array of results
#
def search_results_by_engine_from search_results_by_query
    results_by_engine = {}
    results_by_engine.default = []

    search_results_by_query.each do |query, engine_results|

        engine_results.each do |engine, results|
            results_by_engine[engine] += results
        end
    end

    results_by_engine
end


search_results_by_engine_from(search_results_by_query).each do |engine, results|
    puts "#{engine}: #{results.length}"

    results.each do |r|
        puts "\t#{r.rank} - #{r.title} - #{r.url}"
    end
end


