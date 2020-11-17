%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Nov 17, 2020 11:11
%%%-------------------------------------------------------------------
-module(bucket_sort_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

%%API
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% Supervisor callbacks
init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 3,
    MaxSecondsBetweenRestarts = 10,
    
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    
    Child = #{
        id => bucket_sort_serv, 
        start => {bucket_sort_serv, start_link, []},
        restart => permanent, 
        shutdown => 2000, 
        type => worker, 
        modules => [bucket_sort_serv]
    },
        
    {ok, {SupFlags, [Child]}}.