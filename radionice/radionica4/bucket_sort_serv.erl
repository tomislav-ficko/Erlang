%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Nov 17, 2020 11:11
%%%-------------------------------------------------------------------
-module(bucket_sort_serv).
-behaviour(gen_server).

-export([start_link/0, stop_all/0, stopA/0, stopB/0, add/1, find/1, delete/1, print_all/0, sort/0]).
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

%%API
start_link() ->
    gen_server:start_link({local, serverA}, ?MODULE, [], []),
    gen_server:start_link({local, serverB}, ?MODULE, [], []).

stop_all() ->
    gen_server:call(serverA, stop),
    gen_server:call(serverB, stop).
stopA() ->
    gen_server:call(serverA, stop).
stopB() ->
    gen_server:call(serverB, stop).
add(Item) ->
    if
        Item < 50 ->
            gen_server:cast(serverA, {add, Item});
        Item > 50 ->
            gen_server:cast(serverB, {add, Item})
    end.
find(Item) ->
    if
        Item < 50 ->
            gen_server:call(serverA, {find, Item});
        Item > 50 ->
            gen_server:call(serverB, {find, Item})
    end.
delete(Item) ->
    if
        Item < 50 ->
            gen_server:cast(serverA, {delete, Item});
        Item > 50 ->
            gen_server:cast(serverB, {delete, Item})
    end.
print_all() ->
    gen_server:cast(serverA, print_all),
    gen_server:cast(serverB, print_all).
sort() ->
    gen_server:cast(serverA, sort),
    gen_server:cast(serverB, sort).

%% gen_server callbacks
init([]) ->
    {ok, bucket_sort_log:create()}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State};
handle_call({find, Item}, _From, State) ->
    Reply = bucket_sort_log:find(State, Item),
    {reply, Reply, State}.

handle_cast({add, Item}, State) ->
    NewState = bucket_sort_log:add(State, Item),
    {noreply, NewState};
handle_cast({delete, Item}, State) ->
    NewState = bucket_sort_log:delete(State, Item),
    {noreply, NewState};
handle_cast(print_all, State) ->
    bucket_sort_log:print_all(State),
    {noreply, State};
handle_cast(sort, State) ->
    NewState = bucket_sort_log:bubble_sort(State),
    {noreply, NewState}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
