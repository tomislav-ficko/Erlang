%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 19, 2020 15:34
%%%-------------------------------------------------------------------
-module(procesi_vremenska_kontrola).
-author("Tomi").

-export([run/0, set/3]).

%%% ------ Rad s procesima i vremenskom kontrolom ---------

run() -> 
    set_alarm(5000, "Riing!!").

set_alarm(T, Message) ->
    io:format("~nAlarm started!~n"),
    spawn(procesi_vremenska_kontrola, set, [self(), T, Message]),  % Pid nam nije bitan, pa ga ne spremamo
    receive
        Msg ->
            io:format("Finished: ~s~n", [Msg])
    end.

set(Pid, T, AlarmMessage) ->
    receive
    after
        T -> 
            Pid!AlarmMessage
    end.

sleep_example(T) ->
    receive
        after T ->              % Vrijeme u milisekundama
            true
    end.

suspend_example() ->
    receive
    after infinity ->           % Čeka beskonačno
        true
    end.