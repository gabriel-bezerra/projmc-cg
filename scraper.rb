require './searcher'
require './engines/googleengine'
require './engines/yahooengine'
require './engines/bingengine'
require './engines/proxiedengine'

class Scraper

    class Result
        attr_reader :title, :url, :rank, :page

        def initialize title, url, rank, page
            @title = title
            @url = url
            @rank = rank
            @page = page
        end
    end

    SEARCHERS = {:google => Searcher.new(GoogleEngine.new),
                 :yahoo => Searcher.new(YahooEngine.new),
                 :bing => Searcher.new(ProxiedEngine.new(BingEngine.new))}

    def initialize queries
        @queries = queries
    end

    def showtime
        all_results = {}

        @queries.each do |query|
            all_results[query] = search_everywhere_for query
        end

        all_results
    end

    private

    def search_everywhere_for query
        query_results = {}

        SEARCHERS.each do |symbol, searcher|
            query_results[symbol] = results_from searcher.search_for query
        end

        query_results
    end

    def results_from ordered_links
        ordered_links.map do |link|
            Result.new link.text,
                       link.href,
                       ordered_links.index(link),
                       fetch_page_from(link)
        end
    end

    def fetch_page_from link
        agent = Mechanize.new
        agent.user_agent_alias = 'Linux Firefox'

        agent.get(link.href).body
    end

end
