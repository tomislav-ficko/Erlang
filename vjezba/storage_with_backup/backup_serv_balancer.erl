%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Nov 9, 2020 18:45
%%%-------------------------------------------------------------------
-module(backup_serv_balancer).
-behaviour(gen_server).

-export([start_link/0, 
    stop/0,
    stop/1, 
    add/1, 
    find/1, 
    delete/1]).

-export([init/1,
    handle_call/3,
    handle_info/2,
    terminate/2,
    code_change/3]).

%%API
start_link() ->
    gen_server:start_link({local, balancer}, ?MODULE, [], []).

stop() ->
    gen_server:call(balancer, stop).

stop(numbers) ->
    backup_serv_numbers:stop();
stop(other) ->
    backup_serv_other:stop().

add(Value) ->
    if
        erlang:is_integer(Value) == true ->
            reset_numberServer_values_if_necessary(),

            backup_serv_numbers:add(Value),
            DataToBackup = backup_serv_numbers:get_all(),
            backup_serv_other:save_backup(DataToBackup);
        true ->
            reset_otherServer_values_if_necessary(),

            backup_serv_other:add(Value),
            DataToBackup = backup_serv_other:get_all(),
            backup_serv_numbers:save_backup(DataToBackup)
    end.
find(Value) ->
    if
        erlang:is_integer(Value) == true ->
            reset_numberServer_values_if_necessary(),

            backup_serv_numbers:find(Value);
        true ->
            reset_otherServer_values_if_necessary(),

            backup_serv_other:find(Value)
    end.
delete(Value) ->
    if
        erlang:is_integer(Value) == true ->
            reset_numberServer_values_if_necessary(),

            backup_serv_numbers:delete(Value);
        true ->
            reset_otherServer_values_if_necessary(),

            backup_serv_other:delete(Value)
    end.

%% gen_server callbacks
init([]) ->
    {ok, []}.

handle_call(stop, _From, State) -> % Returns a response
    {stop, normal, stopped, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


reset_numberServer_values_if_necessary() ->
    Data = backup_serv_numbers:get_all(),
    if
        Data == [] ->
            % There is a possibility the server has been restarted
            Backup = backup_serv_other:get_backup(),
            backup_serv_numbers:restore_data(Backup);
        true ->
            true
    end.

reset_otherServer_values_if_necessary() ->
    Data = backup_serv_other:get_all(),
    if
        Data == [] ->
            % There is a possibility the server has been restarted
            Backup = backup_serv_numbers:get_backup(),
            backup_serv_other:restore_data(Backup);
        true ->
            true
    end.
