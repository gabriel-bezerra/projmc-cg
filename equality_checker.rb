#!/usr/bin/env ruby

require "./marshalrepository"

# load collected data

repository = MarshalRepository.new 'collected-data'
search_results_by_query = repository.retrieve

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
        engine1s_results = engines[compared_engines.first]
        engine2s_results = engines[compared_engines.last]

        largest_result_list = largest_result_list_of [engine1s_results, engine2s_results]
        smallest_result_list = smallest_result_list_of [engine1s_results, engine2s_results]

        number_of_equal_results = 0
        smallest_result_list.each_with_index do |result, index|
            if result.url == largest_result_list[index].url
                number_of_equal_results += 1
            end
        end

        equality_ratio = (1.0 * number_of_equal_results) / largest_result_list.length

        puts query,equality_ratio
        puts
    end
end


# Bar chart with equal results proportion by query for Google and Bing
# Bar chart with equal results proportion by query for Google and Yahoo!
# Bar chart with equal results proportion by query for Bing and Yahoo!

# Bar chart with equal ranked results proportion by query for Google and Bing
# Bar chart with equal ranked results proportion by query for Google and Yahoo!
# Bar chart with equal ranked results proportion by query for Bing and Yahoo!


