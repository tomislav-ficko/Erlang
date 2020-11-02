%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Nov 2, 2020 10:40
%%%-------------------------------------------------------------------
-module(open_telecom_platform).
-author("Tomi").

% OTP je Programski okvir za visoko dostupne aplikacije (highly available applications)
% Koncepti:
%       Sučelje (behaviour)             - definira koje funkcije modul treba objaviti (nalik interface-u u Javi) 
%       Konkretni modul                 - deklarira i implementira sučelje
%       Radna komponenta (container)    - izvršava module koji implementiraju specifikaciju unutar OTP konteksta


% -------------- Izgled sučelja i konkretnog modula -----------------
% -module(my_behaviour).
% -export([behaviour_info/1]).
% 
% behaviour_info(callbacks) ->
%   [{init, 1}, {print, 2}];
% behaviour_info(_Other) ->
% undefined.

% ---------------- Izgled konkretnog modula -----------------------
% -module(my_module).
% -behaviour(my_behaviour).
% -export([init/1, print/2, bla/0]).
%
% init(Arg) -> ...


% Koncept supervisor/worker u OTP-u:
%           - Supervisor je vršni proces koji upravlja radnicima i implementira strategiju pokretanja radnika
%           - Supervisor prati radnike i kada se neki ugasi, primjenjuje strategiju pokretanja

% Aplikacije:
%       - Osnovni element za pakiranje koda za distribuciju
%       - Dijele se na Library (ne pokreće se) i Active (mogu se pokrenuti)
%       - Sastoje se od direktorija src, ebin, priv, include, doc i test