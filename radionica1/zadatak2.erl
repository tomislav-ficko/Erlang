%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 18, 2020 12:53
%%%-------------------------------------------------------------------
-module(zadatak2).
-author("Tomi").

-export([run/0]).

% Zadatak: Napraviti funkciju koja dodaje element (broj) u listu tako da je lista sortirana po uzlaznom redu. 
%          Pretpostavka je da je predana lista sortirana po uzlaznom redu. 

run() -> add_number_to_sorted_list([2, 3, 6], 5).

add_number_to_sorted_list(List, Number) ->
  FirstPart = [X || X <- List, X =< Number],  % Stvara se nova lista u koju će biti dodani svi elementi iz "List" manji ili jednaki "Number" 
  Rest = [X || X <- List, X > Number],        % Stvara se nova lista u koju će biti dodani svi elementi iz "List" veći od "Number" 
  Result = FirstPart ++ [Number] ++ Rest,
  io:fwrite("~nThe initial list was ~w, and the final one is ~w.~n", [List, Result]).