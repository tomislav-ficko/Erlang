%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : 16. Oct 2020 14:28
%%%-------------------------------------------------------------------
-module('n-torke').
-author("Tomi").

-export([run/0]).

%%% ------ Rad s n-torkama ---------
% Služe kao strukture podataka za fiksni broj elemenata
run() ->
  tuple_example().

tuple_example() ->
  Godina = {godina, 2015},            % N-torka koja se sastoji od atoma i broja
  io:format("~nN-torka Godina je ~w~n",[Godina]),
  Ime = {ime, pero},
  Prezime = {prezime, 'perić'},
  Osoba = {Ime, Prezime},
  io:format("~nN-torka Osoba je ~w~n",[Osoba]),

  {{ime, I}, {prezime, P}} = Osoba,   % Podudaranje uzoraka ili dekonstrukcija
  io:format("~nVarijabla I ima vrijednost ~w~n",[I]),
  io:format("Varijabla P ima vrijednost ~p~n",[P]).