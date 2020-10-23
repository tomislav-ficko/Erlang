%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 22, 2020 23:00
%%%-------------------------------------------------------------------
-module(r1_zadatak7).
-author("Tomi").

-export([run/0, input_loop/1, find_element/1]).
-import(maps, [put/3]).
-import(io, [get_line/1, format/2]).

% Zadatak: Potražiti u Erlangovoj dokumentaciji gotove module koji predstavljaju mape
%           - odlučiti se za jedan i koristiti ga u funkciji iz zadatka 6

run() -> 
    InitialMap = maps:new(), % Ista funkcionalnost kao InitialTree = #{}
    Map = input_loop(InitialMap),
    find_element(Map).

input_loop(Map) ->
    KeyInput = get_line("Please enter a key (to finish write exit): "),
    Key = string:strip(KeyInput, right, $\n),
    if
        Key == "exit" ->
            % Vrati se u pozivajuću funkciju s popunjenom mapom
            Map;
        true ->
            ValueInput = get_line("Please enter a value: "),
            Value = string:strip(ValueInput, right, $\n),

            NewMap = maps:put(Key, Value, Map),
            input_loop(NewMap)
    end.

find_element(Map) ->
    Input = get_line("Please enter a key to search for: "),
    Key = string:strip(Input, right, $\n),
    Tuple = maps:find(Key, Map),
    if
        Tuple == error ->
            format("-> There is no value associated with key ~p.~n", [Key]);
        true ->
            {ok, Value} = Tuple,
            format("-> The value for ~p is ~p.~n", [Key, Value])
    end.
