%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 18, 2020 15:43
%%%-------------------------------------------------------------------
-module(zadatak5).
-author("Tomi").

-export([run/0]).
-import(io, [format/1, format/2, get_line/1]).

% Zadatak: Napraviti funkciju pretraživanja liste po ključu. Argumenti su lista i ključ, a vraća vrijednost.

run() -> 
    List = [{1, one}, {5, five}, {11, eleven}],

    Input = get_line("Please enter the key (a number) which you want to search for: "),
    KeyString = string:strip(Input, right, $\n),    % The '\n' char has to be ignored before searching for the entered key
    {Key, _} = string:to_integer(KeyString),        % Casting the Key string into an integer
    if
        Key == error ->
            % If the Key was not sucessfully cast to a number, its value will be 'error', and we must end the program
            format("~nA number must be entered!~n");
        true -> 
            % If the Key was sucessfully cast, we can continue searching for its value
            Value = search_list_by_key(List, Key),

            % ------ Another way to achieve the same functionality is using the default Erlang function for searching a list of tuples ------
            % SearchByKey = 1,
            % {_, Value} = lists:keyfind(Key, SearchByKey, List), % Pattern matching must be used to extract the value, since a tuple is returned

            if
                Value == false ->
                    format("~nThere is no key '~p' present in the list.~n", [Key]);
                true ->
                    format("~nThe value assigned to key '~w' is '~w'.~n", [Key, Value])
            end
    end.

search_list_by_key(List, Key) ->
    StartingPosition = 1,
    iterate(List, Key, StartingPosition).

iterate(List, Key, Position) ->
    ListLength = length(List),
    if
        Position =< ListLength -> % If we haven't yet passed the final element of the list, continue searching
            Tuple = lists:nth(Position, List),
            {K, V} = Tuple, % Using pattern matching to extract the key and value of the tuple 
            if
                K == Key -> % If the key inside the tuple is equal to the one we are looking for, return the tuple value
                    V;
                true ->     % If the key is not the one we are looking for, go to the next item in the list
                    iterate(List, Key, Position + 1)
            end;
        true -> % If we went over all the elements and haven't found the key we're looking for, return false
            false
    end.
