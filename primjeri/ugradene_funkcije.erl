%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : 16. Oct 2020 11:43
%%%-------------------------------------------------------------------
-module(ugradene_funkcije).
-author("Tomi").

-export([run/0]).

%%% ------ Rad s ugrađenim funkcijama ---------

run() ->
  built_in_functions().

built_in_functions() ->

  % Liste
  L = "123",
  First = hd(L),                                              % Vraća prvi element
  io:format("~nPrvi element liste ~p je ~p~n", [L, First]),
  Last = tl(L),                                               % Vraća ostale elemente
  io:format("Ostali elementi liste ~p su ~p~n", [L, Last]),
  ListSize = length(L),                                       % Vraća veličinu
  io:format("Velicina liste je ~w~n", [ListSize]),
  Integer = list_to_integer(L),                               % Pretvara listu (string) u broj
  io:format("Lista ~p pretvorena u integer je broj ~p~n", [L, Integer]),

  % N-torke (tuple)
  T = {1, 2, 3},
  TupleSize = tuple_size(T),                                                        % Vraća veličinu
  io:format("~nVelicina n-torke ~p je ~w~n", [T, TupleSize]),
  SecondElement = element(2, T),                                                    % Vraća n-ti element
  io:format("Drugi element n-torke je ~w~n", [SecondElement]),
  ReplacedTuple = setelement(2, T, 4),                                              % Mijenja n-ti element, vraća novu n-torku
  io:format("N-torka nakon zamijene drugog elementa: ~w~n", [ReplacedTuple]),
  AppendedTuple = erlang:append_element(T, 6),                                      % Dodaje element na kraj
  io:format("N-torka nakon dodavanja elementa na kraj: ~w~n", [AppendedTuple]),

  % Vrijeme
  Time = date(),                    % Vraća datum {YYYY, mm, dd}
  io:format("~nTrenutno vrijeme je: ~w~n", [Time]),

  Now = now(),                      % Vraća Unix vrijeme {MegaSecs, Secs, Microsecs}
  io:format("Trenutno Unix vrijeme je ~w~n", [Now]),

  Timestamp = os:timestamp(),       % Isto kao i now/0, ali garantira jedinstvenu vrijednost,
                                    % što je bitno kada želimo da klijenti imaju različita vremena prilikom pristupanja istom resursu
  io:format("Trenutni jedinstveni timestamp je: ~w~n~n", [Timestamp]),

  % IO
  Tekst = io:get_line("Upisite tekst: "),                         % Čita redak sa stdin
  io:format("S get_line ucitano je: ~w~n", [Tekst]),

  Pet = io:get_chars("Upisite tekst s barem pet znakova: ", 5),   % Čita zadani broj znakova sa stdin
  io:format("S get_chars(_, 5) ucitano je: ~w~n", [Pet]).

  % io:read("Upisite tekst: ") - Kontinuirano čita (Erlangov izlaz, ne operacije) sa stdin

  % Math - matematicke funkcije nalaze se u modulu "math"