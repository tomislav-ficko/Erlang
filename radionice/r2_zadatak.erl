%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 23, 2020 00:35
%%%-------------------------------------------------------------------
-module(r2_zadatak).
-author("Tomi").

-export([run/0, process_loop/1]).
-import(io, [get_line/2, format/1, format/2]).
-import(r1_zadatak7, [find_element/1]).

% Zadatak 1: Napraviti proces koji prima poruke za stavljanje, brisanje, zamjenu i pretraživanje 
% .. mape (ključ n-torka ime i prezime, vrijednost je lista prijatelja - n-torka ime i prezime).

run() ->
    start().

start() ->
    EmptyMap = maps:new(),
    % Prilikom pokretanja procesa šaljemo praznu mapu koja će se puniti
    Pid = spawn(module_info(module), process_loop, [EmptyMap]),
    
    % --------- INSERT ---------
    K = {a, b},
    V = [{b,c}, {c,d}],
    Pid!{self(), insert, K, V},
    receive
        {Pid, insert_done} ->
            format("-> Inside start(), insertion done!~n")
    end,

    % --------- UPDATE ---------
    NewV = [{e,f}],
    Pid!{self(), update, K, NewV},
    receive
        {Pid, update_done} ->
            format("-> Inside start(), update done!~n")
    end,

    % --------- GET ---------
    Pid!{self(), get, K},
    receive
        {Pid, get_done, Value} ->
            format("The requested value for key ~p is ~p.~n", [K, Value]);
        {Pid, not_present} ->
            format("There is no value associated with key ~p.~n", [K])
    end,

    % --------- DELETE ---------
    Pid!{self(), delete, K},
    receive
        {Pid, delete_done} ->
            format("-> Inside start(), deletion done!~n")
    end,
    
    % --------- GET ---------
    Pid!{self(), get, K},
    receive
        {Pid, get_done, Val} ->
            if
                Val == not_present ->
                    format("The key ~p does not exist.~n!", [K]);
                true ->
                    format("The requested value for key ~p is ~p.~n!", [K, Val])
            end
    end,

    Pid!{stop}.

process_loop(Map) ->
    receive
        {From, insert, Key, Value} ->
            format("---> Inside process_loop(), beginning insertion!~n"),
            NewMap = maps:put(Key, Value, Map),
            From!{self(), insert_done},
            process_loop(NewMap);

        {From, delete, Key} ->
            format("---> Inside process_loop(), beginning deletion!~n"),
            NewMap = maps:remove(Key, Map),
            From!{self(), delete_done},
            process_loop(NewMap);
            
        {From, update, Key, Value} ->
            format("---> Inside process_loop(), beginning update!~n"),
            NewMap = maps:put(Key, Value, Map),
            From!{self(), update_done},
            process_loop(NewMap);

        {From, get, Key} ->
            format("---> Inside process_loop(), beginning search!~n"),
            Value = maps:get(Key, Map, not_present),
            From!{self(), get_done, Value},
            process_loop(Map);

        stop ->
            io:format("---> Inside process_loop(), stopping process ~p.~n", [self()]),
            true
    end.


% Zadatak 2: Napraviti sekvencijski API za proces.


% Zadatak 3: Raspodijeliti odgovornost na dva procesa koji svaki obrađuje dio ključeva i glavni proces koji zna preusmjeriti zahtjeve.


% Zadatak 4: Napraviti proces koji prima osobu kao ključ i vraća listu prijatelja s određenim brojem skokova 
% .. npr. za broj skokova 2 nađe i prijatelje od prijatelja. U listi se ne smije nalaziti više puta ista osoba.


% Zadatak 5: Baciti iznimku ako je neki proces ubijen.


