%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Nov 9, 2020 18:45
%%%-------------------------------------------------------------------
-module(backup_log).
-author("Tomi").

-export([create/0, add/2, find/2, delete/2]).

create() ->
    {[], []}. % Tuple: {Storage from this server, Backup from other server}

add({Data, Backup}, NewEntry) ->
    EntryPresent = lists:member(NewEntry, Data),
    if
        EntryPresent == false ->
            NewData = Data ++ [NewEntry];
        true ->
            NewData = Data
    end,
    {NewData, Backup}.

find({Data, _}, Entry) ->
    lists:member(Entry, Data).

delete({Data, Backup}, Entry) ->
    NewData = lists:delete(Entry, Data),
    {NewData, Backup}.
