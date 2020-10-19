%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 19, 2020 12:21
%%%-------------------------------------------------------------------
-module(procesi_i_poruke).
-author("Tomi").

-export([run/0, loop/0]).

%%% ------ Rad s vrstama prijema poruka (selektivni i neselektivni) ---------
%%% Neselektivni prijem - prihvaća poruke bez obzira kojeg oblika i sadržaja one bile
%%% Selektivni prijem - prihvaća poruke samo određenog formata ili od određenog pošiljatelja
%%% 
%%% Ako se pristigla poruka ne podudara s dostupnim uzorcima, tada ona ostaje u inboxu procesa 
%%% .. (to može dovesti do problema s memorijom, jer se sve poruke u inboxu spremaju u memoriji)
%%% 
%%% Poruka ostaje u inboxu sve dok se stvori uzorak s kojim će se ona podudarati

run() -> 
    start().

start() -> 
    Pid2 = spawn(procesi, loop, []),
    Pid2!{self(), poruka},
    receive
        {Pid2, Msg} ->
            io:format("Inside start()! From: ~w Message: ~w~n", [Pid2, Msg])
    end,
    Pid2!abc, % TODO zašto ide u automatski u inbox?
    {_, QueueSize} = erlang:process_info(Pid2, message_queue_len),  % Funkcija za dohvaćanje količine poruka u inboxu (poruke koje nisu obrađene)
    io:format("-> Size of ~w inbox is ~w~n", [Pid2, QueueSize]),
    Result = Pid2!stop,
    io:format("Inside start()! Command ~w issued to process ~w, ending program~n", [Result, Pid2]).

loop() ->
    receive
        {From, Msg} ->
            io:format("~nInside loop()! From: ~w Message: ~w~n", [From, Msg]),
            From!{self(), Msg},
            loop();
        stop ->
            io:format("Stopping process ~w~n", [self()]),
            true;
        Input ->
            % Jedan način sprječavanja punjenja inboxa je da se presretnu sve neželjenje poruke i da se s njima ništa ne radi
            io:format("Inside loop()! Ignoring message: ~w~n", [Input]),
            loop()
    end.