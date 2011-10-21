#!/usr/bin/env ruby
# encoding: utf-8

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

def reduced_copy_of array, to_size
    copy = array[0, to_size]
    copy
end


#Equality ratio with ranking (base)---------------------------------------------

def number_of_equal_results_between first_result_list, second_result_list
    largest_result_list = largest_result_list_of [first_result_list, second_result_list]
    smallest_result_list = smallest_result_list_of [first_result_list, second_result_list]

    number_of_equal_results = 0
    smallest_result_list.each_with_index do |result, index|
        if result == largest_result_list[index]
            number_of_equal_results += 1
        end
    end

    number_of_equal_results
end

def equality_ratio_for_same_ranking_between first_result_list, second_result_list
    number_of_equal_results = number_of_equal_results_between first_result_list, second_result_list

    smallest_result_list = smallest_result_list_of [first_result_list, second_result_list]

    (1.0 * number_of_equal_results) / smallest_result_list.length
end

#Equality ratio with ranking (test)---------------------------------------------

1.times do
    compared_engines = [:bing, :yahoo]

    search_results_by_query.each do |query, engines|
        engine1s_results = collect_url_from engines[compared_engines.first]
        engine2s_results = collect_url_from engines[compared_engines.last]

        equality_ratio = equality_ratio_for_same_ranking_between engine1s_results, engine2s_results

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
    smallest_resultset = smallest_result_list_of [resultset1, resultset2]
    largest_resultset = largest_result_list_of [resultset1, resultset2]

    adjusted_resultset = (smallest_resultset == resultset1) ? resultset2 : resultset1
    adjusted_resultset = reduced_copy_of adjusted_resultset, smallest_resultset.size

    number_of_equal_results = number_of_equal_results_without_ranking_of smallest_resultset, adjusted_resultset

    equality_ratio = (1.0 * number_of_equal_results) / smallest_resultset.size
    equality_ratio
end

#Equality ratio without ranking (test)------------------------------------------

0.times do
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

require "rinruby"

queries = search_results_by_query.keys
result_counts = search_results_by_query.values

R.queries = queries.collect {|query| queries.index(query) + 1}
R.result_counts1 = result_counts.collect {|results| equality_ratio_without_ranking_of results[:google], results[:bing]}
R.result_counts2 = result_counts.collect {|results| equality_ratio_without_ranking_of results[:google], results[:yahoo]}
R.result_counts3 = result_counts.collect {|results| equality_ratio_without_ranking_of results[:yahoo], results[:bing]}

R.eval <<EOF
    png("erwr_google_bing.png", width=900)
    names(result_counts1) <- queries
    barplot(result_counts1,
            las=1,
            col="lightgreen",
            xlab="Consultas",
            ylab="Proporção de resultados iguais",
            main="Proporção de resultados iguais por consulta entre Google e Bing")
EOF

R.eval <<EOF
    png("erwr_google_yahoo.png", width=900)
    names(result_counts2) <- queries
    barplot(result_counts2,
            las=1,
            col="lightgreen",
            xlab="Consultas",
            ylab="Proporção de resultados iguais",
            main="Proporção de resultados iguais por consulta entre Google e Yahoo")
EOF

R.eval <<EOF
    png("erwr_yahoo_bing.png", width=900)
    names(result_counts3) <- queries
    barplot(result_counts3,
            las=1,
            col="lightgreen",
            xlab="Consultas",
            ylab="Proporção de resultados iguais",
            main="Proporção de resultados iguais por consulta entre Yahoo e Bing")
EOF


