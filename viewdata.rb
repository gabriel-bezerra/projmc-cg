#!/usr/bin/env ruby

require "./marshalrepository"

# load collected data

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

results_by_engine = search_results_by_engine_from search_results_by_query


# Bar chart with total amount of results per engine

require "rinruby"

R.assign "engines", results_by_engine.keys.map { |engine| engine.to_s }
R.result_counts = results_by_engine.values.map { |results| results.length }

R.eval <<EOF
    png("total_results_per_engine.png")
    names(result_counts) <- engines
    barplot(result_counts, main="Total number of results per engine")
EOF


# stdout text with total amount of results per engine

search_results_by_engine_from(search_results_by_query).each do |engine, results|
    puts "#{engine}: #{results.length}"

#    results.each do |r|
#        puts "\t#{r.rank} - #{r.title} - #{r.url}"
#    end
end

