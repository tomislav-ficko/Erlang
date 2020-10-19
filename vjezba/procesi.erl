%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 19, 2020 10:25
%%%-------------------------------------------------------------------
-module(procesi).
-author("Tomi").

-export([run/0, loop/0]).

%%% ------ Rad s procesima i porukama ---------

run() -> 
    start().

start() ->  % Funkcija start() se pokreće unutar nekog već postojećeg procesa, uzimamo da se on zove Pid1
    Pid2 = spawn(procesi, loop, []),    % Pokretanje procesa (argumenti su modul, funkcija koju će taj proces pokrenuti te argumenti funkcije)
                                        % .. modul se šalje kao argument jer će se u sklopu njega pokrenuti taj novi proces 
    Pid2!{self(), poruka},              % Slanje poruke procesu Pid2 (od strane procesa Pid1)
    receive                             % Očekujemo odgovor procesa Pid2
        {Pid2, Msg} ->
            io:format("Inside start()! From: ~w Message: ~w~n", [Pid2, Msg])
    end,
    Result = Pid2!stop,
    io:format("Inside start()! Command ~w issued to process ~w, ending program~n", [Result, Pid2]).

loop() ->
    receive                             % Čekanje poruke
        {From, Msg} ->                  % Kada stigne poruka onda se provodi pattern matching s navedenim izrazima 
                                        % (varijable From i Msg obje nisu boundane, pa će se ući u ovaj blok za bilo koju poruku)
            io:format("~nInside loop()! From: ~w Message: ~w~n", [From, Msg]),
            From!{self(), Msg},
            loop();
        stop ->                         % Ako pattern matching ne pronađe odgovarajući izraz, onda poruka ostaje u sandučiću tog procesa, 
                                        % .. i proces se ponovno vraća na čekanje novih poruka
            io:format("Stopping process ~w~n", [self()]),
            true                        % Kada se uđe u blok "stop", naići će se na zadnju naredbu koja vraća atom "true", 
                                        % .. i pošto je to zadnja naredba u funkciji, funkcija loop() će završiti s izvođenjem i proces Pid2 će se zaustaviti
    end.