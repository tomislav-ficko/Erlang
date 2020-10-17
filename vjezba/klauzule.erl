%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : 16. Oct 2020 19:21
%%%-------------------------------------------------------------------
-module(klauzule).
-author("Tomi").

-export([run/0]).
-import(io, [format/1, format/2]).

%%% ------ Rad s klauzulama i rekurzijom ---------
% Erlang nema podršku za petlje, sva takva računanja se rade pomoću rekurzija
%
% Ali zato ima ugrađenu Tail recursion optimization, što znači da ako je zadnja naredba takva da poziva samu sebe (rekurzivno), 
% onda ona na stog ne mora stavljati nikakve vrijednosti, zbog čega se stog ne popunjava. To svojstvo koristimo da bi napravili dobru rekurziju

run() -> 
    better_sum("text"),
    Number = 1000,
    Sum = better_sum(Number),
    format("The sum of numbers until ~w is ~w.~n", [Number, Sum]).

% Loša rekurzija
sum(0) -> 
    0;                          % Ako imamo više funkcija s jednakim brojem atributa (tzv. klauzule), one se međusobno odvajaju s ";", 
                                % jer će u suprotnom Erlang bacati error da je funkcija već definirana.
                                % Pažnja: Redosljed navođenja klauzula je bitan!
sum(X) -> 
    sum(X - 1) + X.             % Loša rekurzija jer se X mora u svakom koraku pamtiti vrijednosti i stavljati ih na stog. Ovo rješenje 
                                % zauzima puno radne memorije kod velikih argumenata.

% Ako želimo promijeniti redosljed klauzula, tada možemo dodati uvjet (guard) nakon naziva klauzule:
% sum(X) when X > 0 -> ...;
% sum(0) -> ...

% Optimizirana rekurzija
better_sum(X) when is_integer(X) ->     % Uvjeti se mogu i kombinirati, a odvajaju se pomoću:
                                        % ";" - operator ILI
                                        % "," - operator I
    better_sum(X, 0);
better_sum(_) ->
    format("An integer must be entered!~n").

better_sum(0, Rez) ->
    Rez;
better_sum(X, Rez) ->
    better_sum(X - 1, Rez + X). % Na ovaj način Erlang može napraviti optimizaciju i stog se ne zapunjuje bespotrebno

