%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Nov 2, 2020 10:50
%%%-------------------------------------------------------------------
-module(phonebook_log).
-author("Tomi").

-export([create/0, add/2, find/2, delete/2]).

create() ->
    dict:new().

add(Phonebook, {Name, Number}) ->
    dict:store(Name, Number, Phonebook).

find(Phonebook, Name) ->
    find_key(Phonebook, Name, dict:is_key(Name, Phonebook)).

delete(Phonebook, Name) ->
    dict:erase(Name, Phonebook).

find_key(_, _, false) ->
    nil;
find_key(Phonebook, Name, true) ->
    dict:fetch(Name, Phonebook).