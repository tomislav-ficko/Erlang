%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Nov 17, 2020 11:11
%%%-------------------------------------------------------------------
-module(r4_zadatak).
-author("Tomi").

% Zadatak 1: Mehanizam za sortiranje iz DZ i LV -> Odvojiti logiku u jedan modul, a proces u gen_server
% Zadatak 2: Napraviti supervisor sa dva gen_servera
% Zadatak 3: Napraviti aplikaciju

-behaviour(application).

% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    case bucket_sort_sup:start_link() of
        {ok, Pid} ->
            {ok, Pid};
        Error ->
            Error
    end.

stop(_State) ->
    ok.