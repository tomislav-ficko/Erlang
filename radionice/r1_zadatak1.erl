%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : 18. Oct 2020 12:48
%%%-------------------------------------------------------------------
-module(r1_zadatak1).
-author("Tomi").

-export([run/0]).

% Zadatak: Napraviti funkciju koja dodaje element (broj) u listu (svejedno na koje mjesto). Argumenti su lista i broj.

run() -> add_number_to_list([3, 6], 5).

add_number_to_list(List, Number) ->
  NewElement = [Number],
  NewList = List ++ NewElement,
  io:fwrite("~nThe initial list was ~w, and the final one is ~w.~n", [List, NewList]).