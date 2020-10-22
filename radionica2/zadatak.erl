%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 23, 2020 00:35
%%%-------------------------------------------------------------------
-module(zadatak).
-author("Tomi").

-export([run/0]).
-import(io, [get_line/2, format/1, format/2]).

% Zadatak 1: Napraviti proces koji prima poruke za stavljanje, brisanje, zamjenu i pretraživanje 
% .. mape (ključ n-torka ime i prezime, vrijednost je lista prijatelja - n-torka ime i prezime).

run() ->
    start().

start() ->
    Pid = spawn(zadatak, loop, []),
    %Pid!{self(), {put, {'Eric', 'Clapton'}, [{'Bob','Marley'}, {'Dean', 'Martin'}]}
    bop.

loop() ->
    Map = #{},
    
    receive
        {From, {put, Key, Value}} ->
            format("-> Inside loop(), beginning insertion!"),
            Map = maps:put(Key, Value, Map), % TODO Figure out how to save the new instances of the map inside this function
            todo;

        {From, {delete, Key}} ->
            format("-> Inside loop(), beginning deletion!"),
            Map = maps:remove(Key, Map),
            todo;
            
        {From, {update, Key, Value}} ->
            format("-> Inside loop(), beginning update!"),
            Map = maps:put(Key, Value, Map),
            todo;

        {From, {get, Key}} ->
            format("-> Inside loop(), beginning search!"),
            Value = maps:get(Key, Map),
            From!{self(), Value}

    end.

% Zadatak 2: Napraviti sekvencijalni API za proces.


% Zadatak 3: Raspodijeliti odgovornost na dva procesa koji svaki obrađuje dio ključeva i glavni proces koji zna preusmjeriti zahtjeve.


% Zadatak 4: Napraviti proces koji prima osobu kao ključ i vraća listu prijatelja s određenim brojem skokova 
% .. npr. za broj skokova 2 nađe i prijatelje od prijatelja. U listi se ne smije nalaziti više puta ista osoba.


% Zadatak 5: Baciti iznimku ako je neki proces ubijen.


