%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Nov 2, 2020 11:07
%%%-------------------------------------------------------------------
-module(phonebook_serv).
-author("Tomi").

-behaviour(gen_server). % gen_server je općeniti poslužitelj u OTP-u (a ujedno i oblikovni obrazac za izradu poslužitelja)

-define(SERVER, ?MODULE). % definira macro SERVER koji će imati vrijednost 'phonebook_serv'

-export([start_link/0, stop/0, add/2, find/1, delete/1]). % funkcija start_link() će pokretati novi proces, i povezati ga s postojećim

-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

%%API
start_link() ->
    % Pokrenuti će se lokalno registrirani proces pod nazivom ?SERVER (čija je vrijednost phonebook_serv), a biti će u sklopu module ?MODULE
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    gen_server:call(?SERVER, stop). % Koristimo call jer očekujemo odgovor
add(Name, Number) ->
    gen_server:cast(?SERVER, {add, Name, Number}). % Koristimo cast jer NE očekujemo odgovor
find(Name) ->
    gen_server:call(?SERVER, {find, Name}).
delete(Name) ->
    gen_server:cast(?SERVER, {delete, Name}).


%% gen_server callbacks
init([]) ->
    {ok, phonebook_log:create()}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State};
handle_call({find, Name}, _From, State) ->
    Reply = phonebook_log:find(State, Name),
    {reply, Reply, State}.

handle_cast({add, Name, Number}, State) ->
    NewState = phonebook_log:add(State, {Name, Number}),
    {noreply, NewState};
handle_cast({delete, Name}, State) ->
    NewState = phonebook_log:delete(State, Name),
    {noreply, NewState}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Internal functions

