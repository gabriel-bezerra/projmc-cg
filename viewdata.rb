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


# box plot with {Host, Full} URL length per Rank for {all engines}

engines.each do |engine|
    rank_domain_array = []

    results_by_engine[engine].each do |result|
        string = host_part_of(result.url).sub /.*\.(.+)/, '\1'
        rank_domain_array << [result.rank, string]
    end

    ranks = []
    domains = []

    rank_domain_array.each do |rank, domain|
        ranks |= [rank]
        domains |= [domain]
    end

    domain_set = {}
    rank_domain_array.each do |rank, domain|
        domain_set[domain] ||= {}
        domain_set[domain][rank] ||= 0

        domain_set[domain][rank] += 1
    end

    rank_domain_matrix = []


    ranks.each do |rank|
        rank_domain_matrix[rank] = []

        domains.each do |domain|
            rank_domain_matrix[rank] << (domain_set[domain][rank] || 0)
        end
    end

    require "rinruby"

    R.ranks = ranks
    R.domains = domains
    R.rank_domains_c_to_table = rank_domain_matrix.flatten

    R.eval <<EOF
    rank_domains <- matrix(rank_domains_c_to_table, ncol=length(domains), byrow=TRUE)
    colnames(rank_domains) <- domains
    rownames(rank_domains) <- ranks
    rank_domains <- as.table(rank_domains)
    rank_domains

    png("host_top_level_domain_per_rank_for_#{engine}.png")

    par(xpd=T, mar=par()$mar+c(0,0,0,4))

    barplot(
        t(rank_domains),
        col=rainbow(length(domains)),
        main = "Host Top-Level Domain per rank for #{engine.to_s.capitalize}",
        xlab = "Rank",
        ylab = "Number of results",
    )

    legend(x=12.5, y=20, colnames(rank_domains),  fill=rainbow(length(domains)));

    # Restore default clipping rect
    par(mar=c(5, 4, 4, 2) + 0.1)
EOF
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

