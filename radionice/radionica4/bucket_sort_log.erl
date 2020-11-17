%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Nov 17, 2020 11:11
%%%-------------------------------------------------------------------
-module(bucket_sort_log).

-export([create/0, add/2, delete/2, find/2, print_all/1, bubble_sort/1]).

% This module contains the logic for manipulating the list and sorting

create() ->
    [].

add(List, Item) ->
    List ++ [Item].

delete(List, Item) ->
    lists:delete(Item, List).

find(List, Item) ->
    lists:member(Item, List).

print_all(List) ->
    io:format("~w~n", [List]).

bubble_sort(List) when length(List) =< 1 ->
    % If the list has just one element or is empty, it doesn't need sorting
    List;
bubble_sort(List) ->
    PartlySortedList = bubble_sort_iteration(List), % After the operation, the last element in PartlySortedList is the largest element from the original List
    RemainingListForSorting = lists:sublist(PartlySortedList, 1, length(PartlySortedList) - 1), % Extracting the remaining list (without the last element)

    bubble_sort(RemainingListForSorting) ++ [lists:last(PartlySortedList)]. % Recursively sort the first part of the remaining list and append last element

bubble_sort_iteration([]) ->
    % We went over the whole list
    [];
bubble_sort_iteration([X, Y | Rest]) when X > Y ->
    % If the first value is bigger than the second, change their places and sort next position recursively
    [Y | bubble_sort_iteration([X | Rest])];
bubble_sort_iteration([X, Y | Rest]) ->
    % If the first value is smaller than the second, skip to next position and sort recursively
    [X | bubble_sort_iteration([Y | Rest])];
bubble_sort_iteration([List]) ->
    % If we only have a single value in the list, return it
    [List].
