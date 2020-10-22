%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 22, 2020 20:55
%%%-------------------------------------------------------------------
-module(merge_sort).
-author("Tomi").

-export([run/0]).
-import(io, [format/1, format/2]).

% ---- Implementation of the merge sort algorithm -----

run() ->
    List = [14, 7, 3, 12, 9, 11, 6, 2, 3],
    SortedList = sort(List),
    format("By sorting ~p, we get ~p.~n", [List, SortedList]).

sort(List) ->
    ListSize = length(List),
    if
        ListSize == 1 ->
            % If there is only one element in the list, return it because it's already sorted
            List;
        true ->
            IndexOfMiddleElement = round(ListSize / 2),
            LeftSublist = lists:sublist(List, IndexOfMiddleElement),
            RightSublist = lists:sublist(List, IndexOfMiddleElement + 1, ListSize - IndexOfMiddleElement),
            
            SortedLeftSublist = sort(LeftSublist),
            SortedRightSublist = sort(RightSublist),

            merge(SortedLeftSublist, SortedRightSublist)
    end.

merge(LeftList, RightList) ->
    LeftLength = length(LeftList),
    RightLength = length(RightList),

    if
        LeftLength == 0 ->
            % If we removed all members of the left list in previous iterations, just return the other 
            % .. list (which we know is already sorted because of the third option inside this if statement)
            RightList;
        RightLength == 0 ->
            % The same applies as in the previous comment, just for the right list
            LeftList;
        (LeftLength == 1) and (RightLength == 1) ->
            First = lists:nth(1, LeftList),
            Second = lists:nth(1, RightList),
            sort_two_numbers(First, Second);
        true ->
            Left = lists:nth(1, LeftList),
            Right = lists:nth(1, RightList),
            Boolean = is_left_smaller(Left, Right), 
            if
                Boolean == true ->
                    % If the first item of the left list is smaller, recursively call merge() on 
                    % .. the rest of the lists, without the first number of the left list
                    RestOfLeftList = lists:delete(Left, LeftList),
                    [Left] ++ merge(RestOfLeftList, RightList);
                true ->
                    % If not, ie. the first item of the right list is smaller, then recursively call 
                    % .. merge() on the rest of the lists, without the first number from the right list
                    RestOfRightList = lists:delete(Right, RightList),
                    [Right] ++ merge(LeftList, RestOfRightList)
            end
    end.

sort_two_numbers(First, Second) ->
    if
        First =< Second ->
            [First, Second];
        true ->
            [Second, First]
    end.

is_left_smaller(Left, Right) ->
    Left =< Right.