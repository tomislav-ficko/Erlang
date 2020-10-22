%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 22, 2020 23:00
%%%-------------------------------------------------------------------
-module(zadatak7).
-author("Tomi").

-export([run/0]).
-import(maps, [put/3]).
-import(io, [get_line/1, format/2]).

% Zadatak: Potražiti u Erlangovoj dokumentaciji gotove module koji predstavljaju mape
%           - odlučiti se za jedan i koristiti ga u funkciji iz zadatka 6

run() -> 
    InitialTree = maps:new(), % Same effect as InitialTree = #{}
    Tree = input_loop(InitialTree),

    Input = get_line("Please enter a key to search for: "),
    Key = string:strip(Input, right, $\n),
    Tuple = maps:find(Key, Tree),
    if
        Tuple == error ->
            format("-> There is no value associated with key ~p.~n", [Key]);
        true ->
            {ok, Value} = Tuple,
            format("-> The value for ~p is ~p.~n", [Key, Value])
    end.

input_loop(Tree) ->
    KeyInput = get_line("Please enter a key (to finish write exit): "),
    Key = string:strip(KeyInput, right, $\n),
    if
        Key == "exit" ->
            % Return to the main function with the populated tree
            Tree;
        true ->
            ValueInput = get_line("Please enter a value: "),
            Value = string:strip(ValueInput, right, $\n),

            NewTree = maps:put(Key, Value, Tree),
            input_loop(NewTree)
    end.
