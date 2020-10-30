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
% Zadatak 2: Napraviti sekvencijski API za proces.

run() ->
    start().

start() ->
    EmptyMap = maps:new(),
    % Prilikom pokretanja procesa šaljemo praznu mapu koja će se puniti
    Pid = spawn(module_info(module), process_loop, [EmptyMap]),
    
    Key = {a, b},
    Value = [{b,c}, {c,d}],
    api_insert(Pid, Key, Value),

    NewValue = [{e,f}],
    api_update(Pid, Key, NewValue),

    api_get(Pid, Key),

    api_delete(Pid, Key),

    api_get(Pid, Key),
    
    Pid!{stop},
    ok.

process_loop(Map) ->
    receive
        {From, insert, Key, Value} ->
            NewMap = maps:put(Key, Value, Map),
            From!{self(), insert_done},
            process_loop(NewMap);

        {From, delete, Key} ->
            NewMap = maps:remove(Key, Map),
            From!{self(), delete_done},
            process_loop(NewMap);
            
        {From, update, Key, Value} ->
            NewMap = maps:put(Key, Value, Map),
            From!{self(), update_done},
            process_loop(NewMap);

        {From, get, Key} ->
            Value = maps:get(Key, Map, key_not_present), % The third argument will be returned if the key isn't found
            From!{self(), get_done, Value},
            process_loop(Map);

        stop ->
            true
    end.

api_get(Pid, Key) ->
    Pid!{self(), get, Key},
    receive
        {Pid, get_done, Value} ->
            if
                Value == key_not_present ->
                    format("-> API: The key ~p does not exist!~n", [Key]),
                    key_not_present;
                true ->
                    format("-> API: Retrieval done!~n"),
                    Value
            end
    end.

api_insert(Pid, Key, Value) ->
    Pid!{self(), insert, Key, Value},
    receive
        {Pid, insert_done} ->
            format("-> API: Insertion done!~n")
    end.

api_update(Pid, Key, Value) ->
    Pid!{self(), update, Key, Value},
    receive
        {Pid, update_done} ->
            format("-> API: Update done!~n")
    end.

api_delete(Pid, Key) ->
    Pid!{self(), delete, Key},
    receive
        {Pid, delete_done} ->
            format("-> API: Deletion done!~n")
    end.

% Zadatak 3: Raspodijeliti odgovornost na dva procesa koji svaki obrađuje dio ključeva i glavni proces koji zna preusmjeriti zahtjeve.


% Zadatak 4: Napraviti proces koji prima osobu kao ključ i vraća listu prijatelja s određenim brojem skokova 
% .. npr. za broj skokova 2 nađe i prijatelje od prijatelja. U listi se ne smije nalaziti više puta ista osoba.


% Zadatak 5: Baciti iznimku ako je neki proces ubijen.
