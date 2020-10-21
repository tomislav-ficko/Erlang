%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : Oct 18, 2020 15:55
%%%-------------------------------------------------------------------
-module(zadatak6).
-author("Tomi").

-export([run/0]).
-import(io, [get_line/1, format/2]).

% Zadatak: Napraviti stablo (funkcije dodavanja, pretraživanja elemenata u stablu) {Key, Value}
%           - razmisliti kako organizirati stablo

run() -> 
    InitialTree = {}, % Primjer strukture: { {"Vlado", "Kalember"}, {"Luka", "Nizetic"}, {{"Tose", "Proeski"}, {"Jurica", "Paden"}} }
    Tree = input_loop(InitialTree),

    Input = get_line("Please enter a key to search for: "),
    Key = string:strip(Input, right, $\n),
    Value = get_value(Key, Tree),
    if
        Value == no_value_found ->
            format("-> There is no value associated with key ~p.~n", [Key]);
        true ->
            format("-> The value for ~p is ~p.~n", [Key, Value])
    end,

    format("The depth of the tree is ~p.~n", [get_tree_depth(Tree)]).

input_loop(Tree) ->
    Input = get_line("Please enter values for a node (in {\"Key\",\"Value\"}. form), to finish write exit: "),
    TupleAsString = string:strip(Input, right, $\n),
    if
        TupleAsString == "exit" ->
            Tree;
        true ->
            Tuple = string_to_tuple(TupleAsString),
            NewTree = add_node(Tuple, Tree),
            input_loop(NewTree)
    end.

add_node(Tuple, Tree) ->
    if
        Tree == {} ->   % Istina samo prilikom prvog dodavanja n-torke, tada je stablo prazno
            {Tuple, {}, {}}; % Vraćamo novo stablo
        true ->
            {Root, LeftChild, RightChild} = Tree,
            {RootKey, _} = Root,
            {NewKey, _} = Tuple,

            Comparison = compare_strings(NewKey, RootKey),
            if 
                Comparison == true ->
                    % Postaviti novu n-torku u desno dijete
                    if
                        RightChild == {} ->
                            % Ako nema desnog djeteta, ubacujemo n-torku i vraćamo ostalo kako je bilo
                            {Root, LeftChild, {Tuple, {}, {}}};
                        true ->
                            {Root, LeftChild, add_node(Tuple, RightChild)}
                    end;
                Comparison == false -> 
                    % Postaviti novu n-torku u lijevo dijete
                    if
                        LeftChild == {} ->
                            % Ako nema lijevog djeteta, ubacujemo n-torku i vraćamo ostalo kako je bilo
                            {Root, {Tuple, {}, {}}, RightChild};
                        true ->
                            {Root, add_node(Tuple, LeftChild), RightChild}
                    end
            end
    end.

compare_strings(X, Y) -> % TODO popraviti, trenutno uvijek vraća da je rezultat true
    % Ako je rezultat true, X > Y
    % Ako je rezultat false, X =< Y
    format("-> String A: ~p~n", [X]),
    format("-> String B: ~p~n", [Y]),
    FirstString = string:uppercase(X),
    SecondString = string:uppercase(Y),
    FirstString > SecondString.

string_to_tuple(String) ->
    {ok, Ts, _} = erl_scan:string(String),
    {ok, Tuple} = erl_parse:parse_term(Ts),
    Tuple.

get_value(Key, Tree) ->
    if
        Tree == {} ->
            % Istina samo ako je stablo potpuno prazno
            no_value_found;
        true ->
            {Root, LeftChild, RightChild} = Tree,
            {RootKey, Value} = Root,
            if
                Key == RootKey ->
                % Tražena vrijednost je pronađena
                Value;
                true ->
                    Comparison = compare_strings(Key, RootKey),
                    if
                        Comparison == true ->
                        % Ključ bi se trebao nalaziti unutar desnog djeteta
                            if
                                RightChild == {} ->
                                    % Ključ ne postoji, vraćam atom
                                    no_value_found;
                                true ->
                                    % Ako desno dijete postoji, rekurzivno traži vrijednost njegovog ključa
                                    get_value(Key, RightChild)
                                    % Ako nas zanima na kojoj dubini stabla se ta vrijednost nalazila, tada tu logiku moramo ovdje dodati
                            end;
                        Comparison == false ->
                            % Ključ bi se trebao nalaziti unutar lijevog djeteta
                            if
                            LeftChild == {} ->
                                % Ključ ne postoji, vraćam atom
                                no_value_found;
                            true ->
                                % Ako lijevo dijete postoji, rekurzivno traži vrijednost njegovog ključa
                                get_value(Key, LeftChild)
                            end
                    end
            end
    end.

get_tree_depth(Tree) -> % TODO popraviti, trenutno uvijek vraća da je dubina nula
    if
        Tree == {} ->
            % Istina samo ako je stablo potpuno prazno
            0;
        true ->
            {_, LeftChild, RightChild} = Tree,
            if
                % Traženje dubine lijevog djeteta
                LeftChild == {} ->
                    LeftChildDepth = 0;
                true ->
                    LeftChildDepth = get_tree_depth(LeftChild)
            end,

            if
                % Traženje dubine desnog djeteta
                RightChild == {} ->
                    RightChildDepth = 0;
                true ->
                    RightChildDepth = get_tree_depth(RightChild)
            end,

            if
                % Usporedba dubina i vraćanje veće vrijednosti
                LeftChildDepth >= RightChildDepth ->
                    LeftChildDepth;
                true ->
                    RightChildDepth
            end
    end.
