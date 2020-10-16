%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : 16. Oct 2020 11:42
%%%-------------------------------------------------------------------
-module(mape).
-author("Tomi").

-export([run/0]).

%%% ------ Rad s mapama ---------

run() ->
  map_example().

map_example() ->
  M = #{a => 2, 1 => 3},    % Stvaranje mape
  io:fwrite("M: ~w~n", [M]),

  #{a := X} = M,            % Podudaranje uzoraka ili dekonstrukcija
  io:fwrite("X: ~w~n", [X]),

  M1 = M#{a := 10},         % Zamjena para
  io:fwrite("M1: ~w~n", [M1]),

  M2 = M#{b => [1, 2]},     % Dodavanje para
  io:fwrite("M2: ~w~n", [M2]).