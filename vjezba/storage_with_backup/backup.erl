%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Nov 6, 2020 10:45
%%%-------------------------------------------------------------------
-module(backup).
-behaviour(application).

% Task: Create a system for securely storing data on multiple nodes.
% The supervisor node decides based on the data type (number or non-number)
% which of the two nodes the data will be stored on. Each node is the master for
% its data type, and the slave for the other data type.
% The master node sends a backup of its data to the slave node. In case an 
% error happens on a node, the data backup will be pulled from the slave node
% and added to the newly started master node. It is possible to retrieve the 
% stored data via the supervisor node.

% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    case backup_sup:start_link() of
        {ok, Pid} ->
            {ok, Pid};
        Error ->
            Error
    end.

stop(_State) ->
    ok.
