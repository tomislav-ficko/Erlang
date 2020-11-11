%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Nov 9, 2020 18:45
%%%-------------------------------------------------------------------
-module(backup_serv_numbers).
-behaviour(gen_server).

-export([start_link/0, 
    stop/0, 
    add/1, 
    find/1, 
    delete/1,
    get_all/0,
    restore_data/1,
    save_backup/1, 
    get_backup/0]).

-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

%%API
start_link() ->
    gen_server:start_link({local, number_server}, ?MODULE, [], []).

stop() ->
    gen_server:call(number_server, stop).
add(Value) ->
    gen_server:cast(number_server, {add, Value}).
find(Value) ->
    gen_server:call(number_server, {find, Value}).
delete(Value) ->
    gen_server:cast(number_server, {delete, Value}).
get_all() ->
    gen_server:call(number_server, get_all).
restore_data(Data) ->
    gen_server:cast(number_server, {restore_data, Data}).
save_backup(List) ->
    gen_server:cast(number_server, {save_backup, List}).
get_backup() ->
    gen_server:call(number_server, get_backup).

%% gen_server callbacks
init([]) ->
    {ok, backup_log:create()}. % Storage from this server, Backup from other server

handle_call(stop, _From, State) -> % Returns a response
    {stop, normal, stopped, State};
handle_call({find, Value}, _From, State) ->
    Reply = backup_log:find(State, Value),
    {reply, Reply, State};
handle_call(get_backup, _From, State) ->
    {Data, Backup} = State,
    {reply, {Backup, Data}, State}; % We return the backup as the data for the other node, and the data of the current server as the backup
handle_call(get_all, _From, State) ->
    {Data, _} = State,
    {reply, Data, State}.

handle_cast({add, Value}, State) -> % Doesn't return a response
    NewState = backup_log:add(State, Value),
    {noreply, NewState};
handle_cast({delete, Value}, State) ->
    NewState = backup_log:delete(State, Value),
    {noreply, NewState};
handle_cast({save_backup, NewBackup}, State) ->
    {Data, _} = State,
    NewState = {Data, NewBackup},
    {noreply, NewState};
handle_cast({restore_data, Data}, _State) ->
    % The state is empty, both Data and Backup
    {noreply, Data}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
