%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 19, 2020 13:47
%%%-------------------------------------------------------------------
-module(procesi_registracija).
-author("Tomi").

-export([run/0, server_loop/0]).
%% API
-export([start_server/0, plus/2, minus/2]).

%%% ------ Rad s registracijom procesa ---------
%%% Procesima se poruke mogu slati samo ako znamo njihov PID
%%% Svaki virtualni stroj u Erlangu (čvor) ima popis registriranih procesa 
%%% 
%%% Registracija se vrši funkcijom "register(naziv_atom, Pid)" (ako je neki proces već registriran pod istim nazivom, javlja se greška)
%%% 
%%% Odregistracija se vrši funkcijom "unregister(naziv_atom)" (ako nema registriranog procesa pod tim nazivom, javlja se greška)
%%% .. ako registrirani proces završi, on se automatski odjavljuje
%%% 
%%% Provjeravanje registracije vrši se funkcijom "whereis(naziv_atom)" (vraća Pid ili undefined)
%%% 
%%% Dohvaćanje liste registriranih procesa vrši se funkcijom "registered()"

run() ->
    io:format("~n"),
    start_server(),
    io:format("-> Inside main function! 4 + 7 = ~w~n", [plus(4, 7)]),
    io:format("-> Inside main function! 7 - 4 = ~w~n", [minus(7, 4)]).

start_server() -> 
    Pid = spawn(procesi_registracija, server_loop, []),     % Stvaranje procesa
    register(calc_server, Pid).                             % Registracija procesa

server_loop() ->
    receive
        {From, {plus, X, Y}} ->
            Result = X + Y,
            io:format("Inside server_loop()! Sum calculation in progress~n"),
            From!Result,
            server_loop();
        {From, {minus, X, Y}} ->
            Result = X - Y,
            io:format("Inside server_loop()! Subtraction calculation in progress~n"),
            From!Result,
            server_loop();
        stop ->
            io:format("Inside server_loop()! Stopping process ~w~n", [self()]),
            true
    end.

start_client(X) ->
    calc_server!{self(), X},
    receive
        Y ->
            io:format("Inside start_client()! Calculation finished~n"),
            Y % Vraćanje vrijednosti pozivajućoj funkciji
    end.

plus(X, Y) -> start_client({plus, X, Y}).

minus(X, Y) -> start_client({minus, X, Y}).
