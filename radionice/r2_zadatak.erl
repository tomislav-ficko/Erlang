%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 23, 2020 00:35
%%%-------------------------------------------------------------------
-module(r2_zadatak).
-author("Tomi").

-export([run/0, process_loop/1, balancer/0, index_of/2]).
-import(io, [get_line/2, format/1, format/2]).
-import(r1_zadatak7, [find_element/1]).
-import(string, [uppercase/1]).

% Zadatak 1: Napraviti proces koji prima poruke za stavljanje, brisanje, zamjenu i pretraživanje 
% .. mape (ključ n-torka ime i prezime, vrijednost je lista prijatelja - n-torka ime i prezime).
% Zadatak 2: Napraviti sekvencijski API za proces.
% Zadatak 3: Raspodijeliti odgovornost na dva procesa koji svaki obrađuje dio ključeva i glavni proces koji zna preusmjeriti zahtjeve.

run() ->
    start_balancer(),
    
    Key = {"Michael", "Schumacher"},
    Value = [{"Dylan","Dog"}, {"Captain","America"}],
    
    map_insert(Key, Value),
    
    NewValue = [{"Miley","Citrus"}],
    map_update(Key, NewValue),

    Result = map_get(Key),
    format("Value for key ~p is ~p.~n", [Key, Result]),

    map_delete(Key),

    map_get(Key),
    
    stop_balancer(),
    ok.


map_insert(Key, Value) ->
    balancer!{self(), insert, Key, Value}.

map_update(Key, Value) ->
    balancer!{self(), update, Key, Value}.

map_get(Key) ->
    balancer!{self(), get, Key, no_value},
    receive
        Result ->
            Result
    end.

map_delete(Key) ->
    balancer!{self(), delete, Key, no_value}.


start_balancer() ->
    Pid = spawn(module_info(module), balancer, []),
    register(balancer, Pid),

    EmptyMap = maps:new(),
    Pid1 = spawn(module_info(module), process_loop, [EmptyMap]),
    register(worker1, Pid1),
    Pid2 = spawn(module_info(module), process_loop, [EmptyMap]),
    register(worker2, Pid2).

stop_balancer() ->
    balancer!stop,
    worker1!stop,
    worker2!stop.

balancer() ->
    receive
        {From, Action, Key, Value} ->

            {_, Surname} = Key,
            [FirstLetter | _] = Surname,
            % Funkcija služi za određivanje indexa (X u "workerX") procesa koji će obraditi zahtjev
            WorkerIndex = get_index_of_worker(uppercase([FirstLetter])),
 
            if
                WorkerIndex == 1 ->
                    Pid = whereis(worker1);
                WorkerIndex == 2 ->
                    Pid = whereis(worker2)
            end,
            
            if
                Action == insert ->
                    api_insert(Pid, Key, Value);
                Action == update ->
                    api_update(Pid, Key, Value);
                Action == get ->
                    Result = api_get(Pid, Key),
                    From!{Result};
                Action == delete ->
                    api_delete(Pid, Key)
            end,
            balancer();
        stop ->
            true
    end.

get_index_of_worker(UppercaseLetter) ->
    AlphabetLength = length(uppercase_alphabet()),
    NumberOfProcesses = 2,

    PositionInAlphabet = index_of(UppercaseLetter, uppercase_alphabet()),
    if
        PositionInAlphabet == not_found ->
            format("-> Error in get_index_of_worker(): Letter not part of alphabet.~n");
        true ->
            % Ako znamo poziciju slova u abecedi, onda možemo izračunati kojem rednom broju procesa 
            % .. bi ono trebalo pripasti (abecedu dijelimo na broj dijelova koliko ima procesa)
            Step = trunc(AlphabetLength / NumberOfProcesses),
            calculate_index(0, Step, 1, PositionInAlphabet)
    end.

calculate_index(Start, Step, Index, Position) ->
    if
        (Position > Start) and (Position =< Start + Step) ->
            % Vraćamo index ovog skupa
            Index;
        true ->
            % Ako nije odgovarajući skup, rekurzivno nastavljamo dalje tražiti index
            calculate_index(Start + Step, Step, Index + 1, Position)
    end.

index_of(Item, List) -> index_of(Item, List, 1).

index_of(_, [], _)  -> not_found;
index_of(Item, [Item|_], Index) -> Index;
index_of(Item, [_|Tl], Index) -> index_of(Item, Tl, Index+1).

uppercase_alphabet() ->
    ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"].

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

% Zadatak 4: Napraviti proces koji prima osobu kao ključ i vraća listu prijatelja s određenim brojem skokova 
% .. npr. za broj skokova 2 nađe i prijatelje od prijatelja. U listi se ne smije nalaziti više puta ista osoba.

% Zadatak 5: Baciti iznimku ako je neki proces ubijen.
