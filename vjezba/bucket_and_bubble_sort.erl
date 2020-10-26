%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 26, 2020 11:31
%%%-------------------------------------------------------------------
-module(bucket_and_bubble_sort).
-author("Tomi").

-export([run/0, bucket_sort/1]).
-import(io, [get_line/1, format/1, format/2]).

% Task: Create implementation of the bucket sort algorithm, using bubble sort.
%
% Implement function 'bucket_sort(List)' which sorts the list of input data.
%
% Requirements:
%           -> Values inside the list will be whole numbers.
%           -> The implementation needs to be done within a single process.
%
% Implementation note: Each bucket will be a list inside the main list of buckets (e.g. [[%First bucket], [%Second bucket], [%Third bucket]]


run() ->
    List = [5, 34, 21, 6, 12, 21, 66, 43, 9],
    SortedList = bucket_sort(List),
    format("Input list: ~p.~n", [List]),
    format("Sorted list: ~p.~n", [SortedList]).

bucket_sort(List) ->
    BucketList = create_buckets(),
    MaxValue = lists:max(List),
    FirstIndex = 1,

    FilledBuckets = insert_into_buckets(List, FirstIndex, MaxValue, BucketList),

    SortedBuckets = sort_individual_buckets(FilledBuckets, FirstIndex),

    lists:flatten(SortedBuckets). % Return the elements inside the sorted buckets as a single list

create_buckets() ->
    [[], [], [], [], []]. % This sets the number of buckets to five

insert_into_buckets(List, Index, MaxValue, BucketList) ->
    NoOfBuckets = length(BucketList),
    ListSize = length(List),

    if
        Index =< ListSize ->
            CurrentValue = lists:nth(Index, List),
            CurrentBucketIndex = get_bucket_index(NoOfBuckets, CurrentValue, MaxValue),
            
            CurrentBucket = lists:nth(CurrentBucketIndex, BucketList),
            NewCurrentBucket = CurrentBucket ++ [CurrentValue],

            NewBucketList = update_bucket_list(BucketList, NewCurrentBucket, CurrentBucketIndex),

            BucketsToReturn = insert_into_buckets(List, Index + 1, MaxValue, NewBucketList),
            if
                BucketsToReturn == end_reached ->
                    NewBucketList;
                BucketsToReturn /= end_reached ->
                    BucketsToReturn
            end;
        Index > ListSize ->
            % If we went over all values in the list, return an atom
            end_reached
    end.

get_bucket_index(NoOfBuckets, CurrentValue, MaxValue) ->
    trunc(math:floor((NoOfBuckets - 1) * CurrentValue / MaxValue)) + 1.

update_bucket_list(BucketList, UpdatedBucket, UpdatedBucketIndex) ->
    NoOfBuckets = length(BucketList),

    StartingBuckets = lists:sublist(BucketList, 1, UpdatedBucketIndex - 1),
    EndingBuckets = lists:sublist(BucketList, UpdatedBucketIndex + 1, NoOfBuckets - UpdatedBucketIndex),

    % Return the new concatenated list
    StartingBuckets ++ [UpdatedBucket] ++ EndingBuckets.

sort_individual_buckets(BucketList, CurrentBucketIndex) ->
    NoOfBuckets = length(BucketList),
    if
        CurrentBucketIndex =< NoOfBuckets ->
            CurrentBucket = lists:nth(CurrentBucketIndex, BucketList),
            NewCurrentBucket = bubble_sort(CurrentBucket),

            NewBucketList = update_bucket_list(BucketList, NewCurrentBucket, CurrentBucketIndex),

            BucketsToReturn = sort_individual_buckets(NewBucketList, CurrentBucketIndex + 1),
            if
                BucketsToReturn == end_reached ->
                    NewBucketList;
                BucketsToReturn /= end_reached ->
                    BucketsToReturn
            end;
        CurrentBucketIndex > NoOfBuckets ->
            end_reached
    end.

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
