%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Nov 17, 2020 12:13
%%%-------------------------------------------------------------------
-module(calculator).
-import(io, [format/1, format/2]).
-export([
    digit_loop/0, 
    operator_loop/0, 
    result_loop/1, 
    start/0, 
    test1/0, 
    test2/0]).

% Create a simple distributed calculator which is made up of four processes started on different nodes (e.g. nodes x, y, z and w).
% The processes are called "first_digit", "operator", "second_digit" and "result".
% "first_digit" and "second_digit" are sending their received digits to the "result" process. 
% .. The digit must be received as a message with a value between [0, 9]. 
% .. If the digit is incorrect, the process prints out an error message and waits for a new message.
% "operator" is sending its received operator to the "result" process.
% .. The operator has to be a plus or minus symbol, otherwise it prints out an error messages and waits for a new message.
% "result" is built as a finite-state machine, having to first receive the first digit, then the operator, and then the second digit, before returning a result.
% .. If it doesn't receive data in this order, it doesn't return a valid result.

digit_loop() ->
    receive
        stop ->
            format("Process ~w stopping.~n", [self()]),
            true;
        Msg ->
            if
                is_integer(Msg) ->
                    send_value_if_within_range(Msg);
                true ->
                    format("Digit: Bad argument (~p)~n", [Msg])
            end,
            digit_loop()
    end.

send_value_if_within_range(Value) ->
    if
        (Value >= 0) and (Value =< 9) ->
            result!{self(), Value},
            ok;
        true ->
            format("Number not in range [0, 9]~n")
    end.

operator_loop() ->
    receive
        stop ->
            format("Process 'operator' stopping.~n"),
            true;
       '+' ->
            result!{operator, '+'},
            ok;
        '-' ->
            result!{operator, '-'},
            ok;
        _ ->
            format("Wrong operator symbol~n")
    end,
    operator_loop().

result_loop({}) ->
    receive
       {From, Msg} ->
           FirstPid = whereis(first_digit),
           if
                From == FirstPid ->
                    result_loop({Msg});
                true ->
                    format("Ignoring ~p~n", [Msg]),
                    result_loop({})
            end;
        stop ->
            format("Process ~w stopping.~n", [self()]),
            true
    end;
result_loop({FirstDigit}) ->
    receive
       {operator, Msg} ->
           result_loop({FirstDigit, Msg});
        stop ->
            format("Process ~w stopping.~n", [self()]),
            true;
        {_, Other} ->
            format("Ignoring ~p~n", [Other])
    end;
result_loop({FirstDigit, Operator}) ->
    receive
       {From, Msg} ->
           SecondPid = whereis(second_digit),
           if
                From == SecondPid ->
                    result_loop({FirstDigit, Operator, Msg});
                true ->
                    format("Ignoring ~p~n", [Msg]),
                    result_loop({FirstDigit, Operator})
            end;
        stop ->
            format("Process ~w stopping.~n", [self()]),
            true
    end;
result_loop({FirstDigit, Operator, SecondDigit}) ->
    if
        Operator == '+' ->
            Result = FirstDigit + SecondDigit;
        true ->
            Result = FirstDigit - SecondDigit
    end,

    format("~p ~p ~p = ~p~n", [FirstDigit, Operator, SecondDigit, Result]),
    result_loop({}).

start() ->
    % Each node is created in a separate terminal using "erl -pa ./ -sname X -setcookie cookie" (X is x/y/z/w)

    P1 = spawn(calculator, result_loop, [{}]),
    register(result, P1),
    P2 = spawn(calculator, operator_loop, []),
    register(operator, P2),
    P3 = spawn(calculator, digit_loop, []),
    register(first_digit, P3),
    P4 = spawn(calculator, digit_loop, []),
    register(second_digit, P4),

    format("~nProcesses:~n"),
    format("~p: ~p~n", [P1, result]),
    format("~p: ~p~n", [P2, operator]),
    format("~p: ~p~n", [P3, first_digit]),
    format("~p: ~p~n", [P4, second_digit]).

test1() ->
    first_digit!6,
    operator!'+',
    second_digit!9.

test2() ->
    first_digit!6,
    second_digit!9,
    operator!'+'.
