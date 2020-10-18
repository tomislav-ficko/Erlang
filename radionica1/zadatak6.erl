%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 18, 2020 15:55
%%%-------------------------------------------------------------------
-module(zadatak6).
-author("Tomi").

-export([run/0]).

% Zadatak: Napraviti stablo (funkcije dodavanja, pretraživanja elemenata u stablu) {Key, Value}
%           - razmisliti kako organizirati stablo

run() -> 
    % Create loop
    Input = io:get_line("Please enter values for a node in 'Key, Value' form: "),
    Tuple = Input, % Remove \n from input and create a tuple out of the input data
    add_node(Tuple).

add_node(Tuple) ->

get_value(Key) ->
