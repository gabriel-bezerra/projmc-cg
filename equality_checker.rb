#!/usr/bin/env ruby

require "./marshalrepository"

# load collected data

repository = MarshalRepository.new 'collected-data'
search_results_by_query = repository.retrieve

def collect_url_from resultset
    resultset.collect{|result| result.url}
end

def largest_result_list_of lists_of_results
    largest = lists_of_results.first

    lists_of_results.each do |list|
        if list.length > largest.length
            largest = list
        end
    end

    largest
end

# Tests
0.times do
    puts largest_result_list_of([[],[],[]]) == []
    puts largest_result_list_of([['a'],[],[]]) == ['a']
    puts largest_result_list_of([['a'],['a', 'b'],[]]) == ['a', 'b']
end


def smallest_result_list_of lists_of_results
    smallest = lists_of_results.first

    lists_of_results.each do |list|
        if list.length < smallest.length
            smallest = list
        end
    end

    smallest
end

# Tests
0.times do
    puts smallest_result_list_of([[],[],[]]) == []
    puts smallest_result_list_of([['a'],[],[]]) == []
    puts smallest_result_list_of([['a'],['a', 'b'],[]]) == []
end


1.times do
    compared_engines = [:bing, :yahoo]

    search_results_by_query.each do |query, engines|
        # Stub
        engine1s_results = collect_url_from engines[compared_engines.first]
        engine2s_results = collect_url_from engines[compared_engines.last]

        largest_result_list = largest_result_list_of [engine1s_results, engine2s_results]
        smallest_result_list = smallest_result_list_of [engine1s_results, engine2s_results]

        number_of_equal_results = 0
        smallest_result_list.each_with_index do |result, index|
            if result == largest_result_list[index]
                number_of_equal_results += 1
            end
        end

        equality_ratio = (1.0 * number_of_equal_results) / smallest_result_list.length

        puts equality_ratio.to_s + ' ' + query
    end
end

#Equality ratio without ranking (base)------------------------------------------

def number_of_equal_results_without_ranking_of resultset1, resultset2
    urls1 = collect_url_from resultset1
    urls2 = collect_url_from resultset2
    equality = urls1 & urls2
    number_of_equal_results = equality.length
    number_of_equal_results
end

def equality_ratio_without_ranking_of resultset1, resultset2
    number_of_equal_results = number_of_equal_results_without_ranking_of resultset1, resultset2
    smallest_resultset = smallest_result_list_of [resultset1, resultset2]
    equality_ratio = (1.0 * number_of_equal_results) / smallest_resultset.length
    equality_ratio
end

#Equality ratio without ranking (test)------------------------------------------

1.times do
    puts 'Comparing without ranking--------------------------------------------'

    compared_engines = [:bing, :yahoo]

    search_results_by_query.each do |query, engines|
        engine1s_results = engines[compared_engines.first]
        engine2s_results = engines[compared_engines.last]
        number_of_equal_results = number_of_equal_results_without_ranking_of engine1s_results, engine2s_results
        equality_ratio = equality_ratio_without_ranking_of engine1s_results, engine2s_results

        puts 'engine1s_results.length:' + engine1s_results.length.to_s
        puts 'engine2s_results.length:' + engine2s_results.length.to_s
        puts 'number_of_equal_results:' + number_of_equal_results.to_s
        puts query
        puts equality_ratio
        puts
    end
end

#Equality ratio without ranking (charts)----------------------------------------



