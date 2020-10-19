%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 19, 2020 14:44
%%%-------------------------------------------------------------------
-module(iznimke).
-author("Tomi").

-export([run/0]).

%%% ------ Rad s iznimkama ---------
%%% Bacaju se kao posljedice:
%%% - interne pogreške virtualnog stroja
%%% - pozivanja funkcije "throw(Exception)"
%%% - pozivanja funkcije "exit(Exception)"
%%% - pozivanja funkcije "erlang:error(Exception)"
%%% 
%%% Procesi ne bacaju iznimke, oni šalju poruke s opisom greške ili se gase
%%% 
%%% Hvatanje iznimki izgleda ovako:
%%% try Function of
%%%     Pattern1 [when Guard1] -> Expression1;
%%%     Pattern2 [when Guard2] -> Expression2;
%%%     ...
%%% catch
%%%     ExceptionType1: ExceptionPattern1 [when ExceptionGuard1] -> ExceptionExpression1; 
%%%     (ExceptionType = error || exit || throw)
%%%     ...
%%% after
%%%     AfterExpression
%%% end

run() ->
    [test_catch(N, x) || N <- [1,2,3,4,5,6,7]].

% ----- Bacanje iznimki -----
exception_test(1, X) ->
    {ok, X};                % Ispisuje n-torku
exception_test(2, X) ->
    throw({myerror, X});    % Baca iznimku "exception throw"
exception_test(3, X) ->
    tuple_to_list(X);       % Baca iznimku "exception error" jer pozivamo funkciju s krivim argumentom
exception_test(4, X) ->
    exit({myexit, X});      % Baca iznimku "exception exit"
exception_test(5, X) ->
    {'EXIT', X};            % Ispisuje n-torku
exception_test(6, X) ->
    erlang:error(X).        % Baca iznimku "exception error"

% ----- Hvatanje iznimki -----
test_catch(N, X) ->
    try exception_test(N, X) of
        Value -> {N, normal, Value}
    catch
        throw: Y -> {N, in_catch, was_throw, Y};
        exit: Y -> {N, in_catch, was_exit, Y};
        error: Y -> {N, in_catch, was_error, Y}
    end.