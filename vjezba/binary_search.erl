%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 22, 2020 19:01
%%%-------------------------------------------------------------------
-module(binary_search).
-author("Tomi").

-export([run/0]).
-import(io, [format/1, format/2]).

% ---- Implementation of the binary search algorithm -----
% The list is by default sorted in ascending order

run() ->
    List = [1,3,6,8,9,10],
    Value = 9,
    Index = search(List, Value),

    if
        Index == value_not_found ->
            format("Value ~p is not present in the list!~n", [Value]);
        true ->
            format("Value ~p is on position ~p in the list!~n", [Value, Index])
    end.

search(List, Value) ->
    ListSize = length(List),
    IndexOfMiddleElement = round(ListSize / 2),
    MiddleElement = lists:nth(IndexOfMiddleElement, List),
    if
        Value == MiddleElement ->
            format("-> Found it!~n"),
            IndexOfMiddleElement;
        (Value /= MiddleElement) and (ListSize == 1) ->
            format("-> Not found, going back.~n"),
            value_not_found;
        Value < MiddleElement ->
            format("-> ~p < ~p: Going into the left sublist!~n", [Value, MiddleElement]),
            Sublist = lists:sublist(List, IndexOfMiddleElement - 1),
            ValueOfIndex = search(Sublist, Value),
            if
                ValueOfIndex /= value_not_found ->
                    % If the real value of the index was found, we don't need to append anything since we were searching the left side of the list
                    ValueOfIndex;
                true ->
                    % If the value wasn't found, we just propagate the error message (atom)
                    value_not_found        
            end;
        
        true ->
            format("-> ~p > ~p: Going into the right sublist!~n", [Value, MiddleElement]),
            Sublist = lists:sublist(List, IndexOfMiddleElement + 1, ListSize - IndexOfMiddleElement),
            ValueOfIndex = search(Sublist, Value),
            if
                ValueOfIndex /= value_not_found ->
                    % If the real value of the index was found, we need to add the value of the current middle index to it, 
                    % .. so that in the end the final index will be correct when looking at the whole list
                    ValueOfIndex + IndexOfMiddleElement;
                true ->
                    % If the value wasn't found, we just propagate the error message (atom)
                    value_not_found
            end
    end.