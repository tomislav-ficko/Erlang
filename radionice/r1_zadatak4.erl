%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 18, 2020 13:28
%%%-------------------------------------------------------------------
-module(r1_zadatak4).
-author("Tomi").

-export([run/0]).

% Zadatak: Napraviti funkciju koja dodaje n-torke (tuple) u obliku {Key, Value} u listu, a lista je sortirana po ključevima.

run() -> 
    List = [{2, two}, {1, one}, {7, seven}],
    Tuple = {6, six},
    add_tuple_to_list_and_sort(List, Tuple).

add_tuple_to_list_and_sort(List, Tuple) ->
    SortTuplesByKey = 1,

    Result = lists:keysort(SortTuplesByKey, List ++ [Tuple]), 
    % Sorting is performed on the element of the tuple which is denoted by the first argument 
    % (in this case, sorting is based on the first element of the tuple, the key)
    
    io:fwrite("~nThe initial list was ~p.~n   The final list is ~p.~n", [List, Result]).
