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

engines = :google, :yahoo, :bing


# box plot with {Host, Full} URL length per Rank for {all engines}

require "uri"

def host_part_of url
    URI.split(url)[2]
end

engines.each do |engine|
    url_parts = :host, :full
    url_parts.each do |url_part|

        rank_lenght_array = []

        results_by_engine[engine].each do |result|
            string = case url_part
                     when :host then host_part_of result.url
                     when :full then result.url
                     end
            rank_lenght_array << [result.rank, string.length]
        end

        ranks = []
        lengths = []

        rank_lenght_array.each do |rank, length|
            ranks << rank
            lengths << length
        end

        require "rinruby"

        R.ranks = ranks
        R.lengths = lengths

        R.eval <<EOF
 png("#{url_part}_url_length_per_rank_for_#{engine}.png")
 boxplot(
   lengths ~ ranks,
   main = "#{url_part.to_s.capitalize} URL length per rank for #{engine.to_s.capitalize}",
   xlab = "Rank",
   ylab = "#{url_part.to_s.capitalize} URL length"
 )
EOF
    end
end


# Box plot with {Host, Full} URL length per Engine

1.times do
    url_parts = :host, :full
    url_parts.each do |url_part|

        engine_lenght_array = []

        engines.each do |engine|
            results_by_engine[engine].each do |result|
                string = case url_part
                         when :host then host_part_of result.url
                         when :full then result.url
                         end
                engine_lenght_array << [engine.to_s.capitalize, string.length]
            end
        end

        result_engines = []
        lengths = []

        engine_lenght_array.each do |engine, length|
            result_engines << engine
            lengths << length
        end

        require "rinruby"

        R.engines = result_engines
        R.lengths = lengths

        R.eval <<EOF
            png("#{url_part}_url_length_per_engine.png")
            boxplot(
                lengths ~ engines,
                main = "#{url_part.to_s.capitalize} URL length per engine",
                xlab = "Engine",
                ylab = "#{url_part.to_s.capitalize} URL length"
            )
EOF
    end
end


# Bar chart with total amount of results per engine

R.assign "engines", results_by_engine.keys.map { |engine| engine.to_s.capitalize }
R.result_counts = results_by_engine.values.map { |results| results.length }

R.eval <<EOF
    png("total_results_per_engine.png")
    names(result_counts) <- engines
    barplot(result_counts, main="Total number of results per engine")
EOF



# stdout text with total amount of results per engine

#results_by_engine.each do |engine, results|
#    puts "#{engine}: #{results.length}"
#
#    results.each do |r|
#        puts "\t#{r.rank} - #{r.title} - #{r.url}"
#    end
#end

# Cleber's partition -----------------------------------------------------------

# Bar charts with the number of times each domain was ranked at each rank.
# One for each engine.

require "uri"

def domain url
    domain = URI.parse(url).host.split("\.").last
    puts domain
    return domain
end

def search_ranks_by_domain_from results_by_engine, for_engine
    ranks_by_domain = {}
    ranks_by_domain.default = []

    results_by_engine[for_engine].each do |results|
        results.each do |r|
            ranks_by_domain[domain(r.url)] += r.rank
        end       
    end

    ranks_by_domain
end

results_by_engine = search_results_by_engine_from search_results_by_query
for_engine = GoogleEngine.new
ranks_by_domain = search_ranks_by_domain_from results_by_engine, for_engine
R.assign "domains", ranks_by_domain.keys.map {|domain| domain.to_s}
R.assign "ranks", ranks_by_domain.values.map {|ranks| ranks.each do |r| ranks.count(r) end}
R.eval <<EOF
    png("times_of_domain_at_rank.png")
    names(ranks) <- domains
    barplot(ranks, main="Google")
EOF

