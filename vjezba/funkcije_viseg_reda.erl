%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : 18. Oct 2020 01:18
%%%-------------------------------------------------------------------
-module(funkcije_viseg_reda).
-author("Tomi").

-export([run/0]).
-import(io, [format/2]).

%%% ------ Rad s funkcijama višeg reda ---------
% Funkcije više reda su one funkcije koje se mogu spremiti u varijable.

run() ->
    Double = fun(X) -> 2 * X end,       % Funkcija automatski vraća rezultat zadnje naredbe
    format("~nThe result of doubling the number 5 is ~w.~n", [Double(5)]),

    Cond = fun(X, Y) -> X > Y end,      % Funkcija vraća boolean, ovisno je li odnos između argumenata istinit ili nije
    L = [1, 2, 3, 4, 5],
    SortedList = lists:sort(Cond, L),   % Funkciji "sort()" potrebno je predati funkciju, u ovom slučaju "Cond" (tzv. ordering function), 
                                        % na temelju koje će ona poredati elemente u listi
    % Istu funkcionalnost moguće je postići i direktnom predajom sortirajuće funkcije u poziv funkcije "sort()":
    % SortedList = lists:sort(fun(X, Y) -> X > Y end, L),
    format("The initial order is ~w. The sorted list is ~w.~n", [L, SortedList]),
    
    % Obuhvaćanje liste (list comprehension)
    % Stvara se nova lista i ispunjuje elementima iz stare liste, nad kojima se provodi funkcija koja je navedena prije simbola ||
    NewList = [2 * X || X <- L],
    format("The new list, after list comprehension is done, is ~w.~n",[NewList]).