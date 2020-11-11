%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Nov 9, 2020 18:45
%%%-------------------------------------------------------------------
-module(backup_sup).
-behaviour(supervisor).
-define(SERVER, ?MODULE).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({global, ?SERVER}, ?MODULE, []).

init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 3,
    MaxSecondsBetweenRestarts = 10,
    
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Balancer = #{
        id => balancer,
        start => {backup_serv_balancer, start_link, []},
        restart => permanent, 
        shutdown => 2000,
        type => worker, 
        modules => [backup_serv_balancer]
    },
    NumberWorker = #{
        id => number_server,
        start => {backup_serv_numbers, start_link, []},
        restart => permanent, 
        shutdown => 2000,
        type => worker, 
        modules => [backup_serv_numbers]
    },
    OtherWorker = #{
        id => other_server,
        start => {backup_serv_other, start_link, []},
        restart => permanent, 
        shutdown => 2000,
        type => worker, 
        modules => [backup_serv_other]
    },

    Children = [Balancer, NumberWorker, OtherWorker],
        
    {ok, {SupFlags, Children}}.
