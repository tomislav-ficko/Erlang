%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : 16. Oct 2020 11:40
%%%-------------------------------------------------------------------
-module(osnove).            % Deklaracija modula
-author("Tomi").

-export([run/0]).           % Deklaracija funkcija koje se mogu pozvati izvan modula
-import(io, [format/2]).    % Deklaracija funkcija koje se mogu pozvati u skraćenom obliku
-vsn(1.0).                  % Verzija modula

run() ->
  basics(),
  atom_example().
  
%                               Aritmetički izrazi
% _____________________________________________________________________________________
% | Operator | Vrsta podatka | Prioritet |                    Opis                     |
% |--------------------------|-----------|---------------------------------------------|
% |   + X    |      broj     |     1     |                 pozitivan X                 |
% |   - X    |      broj     |           |                 negativan X                 |
% |----------|---------------|-----------|---------------------------------------------|
% |  X * Y   |      broj     |           |                  množenje                   |
% |  X / Y   |      broj     |           |                 dijeljenje                  |
% | bnot X   |  cijeli broj  |     2     |           operacija NE nad bitovima         |
% | X div Y  |  cijeli broj  |           |             cjelobrojno dijeljenje          |
% | X rem Y  |  cijeli broj  |           |        ostatak cjelobrojnog dijeljenja      |
% | X band Y |  cijeli broj  |           |           operacija I između bitova         |
% |------------------------- |-----------|---------------------------------------------|
% |  X + Y   |      broj     |           |                  zbrajanje                  |
% |  X - Y   |      broj     |           |                 oduzimanje                  |
% | X bor Y  |  cijeli broj  |     3     |          operacija ILI između bitova        |
% | X bxor Y |  cijeli broj  |           |        operacija EX-ILI između bitova       |
% | X bsl N  |  cijeli broj  |           | aritm. pomicanje bitova za N mjesta ulijevo |
% | X bsr N  |  cijeli broj  |           |     pomicanje bitova za N mjesta udesno     |
% |__________________________|___________|_____________________________________________|

%                 Operatori uspoređivanja
%  ___________________________________________________
%  | Operator |                Opis                   |
%  |----------|---------------------------------------|
%  |    >     |                veći                   |
%  |    >=    |            veći ili jednak            |
%  |    <     |                manji                  |
%  |    =<    |            manji ili jednak           |
%  |    ==    |               jednak                  |
%  |    /=    |              različit                 |
%  |    =:=   |    identičan (1 =:= 1.0 daje false)   | -> Moraju biti jednaki i po vrijednosti i po tipu (cijeli/realni)
%  |    =/=   |  nije identičan (1 =/= 1.0 daje true) |
%  |__________|_______________________________________|

%%% ------ Osnove ---------
basics() ->
  format("~nHex broj ff u dec obliku je ~w~n", [16#ff]),
  format("Oktalni broj 20 u dec obliku je ~w~n", [8#20]),                    % Baza može biti u rasponu od 2 do 36
  format("Pretvaranjem broja 3.6 u cijeli dobivamo ~w~n", [trunc(3.6)]),
  format("Zaokruzivanjem broja 3.6 na cijeli dobivamo ~w~n", [round(3.6)]),
  format("Pretvaranjem broja 3 u realni dobivamo ~w~n", [float(3)]).


%%% ------ Rad s atomima ---------
% Atomi služe kao konstante koje ne mijenjamo.
% Moraju imali malo početno slovo, inače bi bili varijable.
% Ako trebamo imati veliko početno slovo u atomu, onda koristimo jednostruke navodnike.

atom_example() ->
  format("~nOvo je primjer obicnog atoma: ~w~n", [atom]),                    % Argumenti uvijek moraju biti navedeni unutar liste ([])
  format("Ovo je primjer atoma s velikim pocetnim slovom i bjelinama: ~w~n", ['Atom s bjelinama']),
  format("Ovo je primjer atoma s podvlakama: ~w~n~n", [atom_s_podvlakama]).  % Uobičajeno je koristiti podvlake