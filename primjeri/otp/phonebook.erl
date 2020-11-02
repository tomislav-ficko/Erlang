%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Nov 2, 2020 14:16
%%%-------------------------------------------------------------------
-module(phonebook).
-author("Tomi").

-behaviour(application).

% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    case phonebook_sup:start_link() of
        {ok, Pid} ->
            {ok, Pid};
        Error ->
            Error
    end.

stop(_State) ->
    ok.