%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : 18. Oct 2020 00:54
%%%-------------------------------------------------------------------
-module(grananje).
-author("Tomi").

-export([run/0]).
-import(io, [format/2]).

%%% ------ Rad s grananjem ---------
% Erlang podržava grananje pomoću "if" i "case" naredbi. 
% Uz pomoć grananja i rekurzije, u Erlangu se može puno toga napraviti.

run() -> 
    IfResult = grananje_if(9),
    format("The result of the if statement is ~w.~n", [IfResult]),
    CaseResult = grananje_case(nista),
    format("The result of the case statement is ~w.~n", [CaseResult]).

grananje_if(X) ->
    if
        X > 5 ->
            vece;           % Ako nije kraj grananja, odvajamo različite uvjete s ";"
                            % Erlang automatski vraća ono što je zadnja naredba, ako je broj X veći od 5, onda će se ispisati atom "vece" 
        X < 0 ->
            negativno;
        true -> izmedju     % Opcija (atom) "true" ima ulogu ključne riječi "else"
    end.                    % Kraj grananja označava se s "end."

grananje_case(X) ->
    case X of
        true -> Y = istina; % Ako je varijabla X istinita, postavljamo atom "istina" kao vrijednost varijable Y
        false -> Y = laz;
        _ -> Y = muljaza    % Default vrijednost se postavlja sa znakom "_"
    end,
    Y.                      % Vraćamo varijablu Y