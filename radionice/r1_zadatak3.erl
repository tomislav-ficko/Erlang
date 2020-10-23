%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 18, 2020 13:01
%%%-------------------------------------------------------------------
-module(r1_zadatak3).
-author("Tomi").

-export([run/0]).

% Zadatak: Napraviti funkciju koja dodaje element (broj) u listu tako da je lista sortirana po kriteriju koji je zadan funkcijom višeg reda.

run() -> 
  Descending = fun(X, Y) -> X > Y end,
  Ascending = fun(X, Y) -> X < Y end,
  add_number_to_list_and_sort([3, 6, 7], 5, Descending).

add_number_to_list_and_sort(List, Number, Cond) ->
  Result = lists:sort(Cond, List ++ [Number]),
  io:fwrite("~nThe initial list was ~w, and the final one is ~w.~n", [List, Result]).