%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%% 
%%% Created : 16. Oct 2020 11:37
%%%-------------------------------------------------------------------
-module(liste).
-author("Tomi").

-export([run/0]).

%%% ------ Rad s listama ---------

% - Namijenjene za promjenjive strukture podataka, jer se u njih mogu dodavati podaci (prilikom dodavanja se kreira nova lista).
% - Imaju oblik "L = [1, 2, 3]."
% - Također se koriste i za tekst, svaki string je ujedno i lista. Oblik je: "L = "Erlang"."
%   Ako lista sadrži znak s dijakritičkim znakom, onda će se prilikom ispisa vrijednosti te liste, u ljusci, ispisati ASCII vrijednosti pojedinih znakova (jer ti znakovi nisu unutar ASCII, nego UTF-8).

run() ->
  list_example().

list_example() ->
  Lista = [1, 2, 3, 4],
  io:format("~nLista ima elemente: ~p~n", [Lista]),

  Tekst = "Erlang",
  io:format("Tekst je ~p, a ASCII vrijednosti znakova su ~w~n~n", [Tekst, Tekst]), % ~p daje stvarnu vrijednost teksta, a ~w ispisuje ASCII vrijednosti

  Inicijali = "FER",
  [X, Y, Z] = Inicijali, % Podudaranje uzoraka ili dekonstrukcija
  io:format("Varijabla X ima vrijednost ~w, a ASCII vrijednost znaka F je ~w~n", [X, $F]), % U ovom slucaju je svejedno stavimo li ~w ili ~p
  io:format("Varijabla Y ima vrijednost ~p, a ASCII vrijednost znaka E je ~p~n", [Y, $E]),
  io:format("Varijabla Z ima vrijednost ~p, a ASCII vrijednost znaka R je ~p~n~n", [Z, $R]),

  [First | Rest] = Inicijali, % Operator | (pipe) odvaja glavu od ostatka
  RestLength = length(Rest),
  io:format("Prvo slovo je: ~p~n", [First]),
  io:format("Ostala slova su: ~p, a duzina je: ~p~n", [Rest, RestLength]),
  io:format("Zadnje slovo je: ~p ~n~n", [lists:last(Inicijali)]),

  [_, F | O] = Inicijali, % Operator _ znači da se slovo odbacuje (ne zanima nas)
  io:format("Drugo slovo je: ~w~n", [F]),
  io:format("Ostatak je: ~w~n~n", [O]),

  io:format("Lista spojena s ++ ima vrijednost: ~w~n", [[x, y] ++ [1, 2]]), % Operator ++ služi za spajanje lista
  io:format("Lista spojena s lists:merge ima vrijednost: ~w~n~n", [lists:merge([x, y], [1, 2])]),

  Tuple_to_list = tuple_to_list({1, 2, 3}),
  io:format("N-torka {1,2,3} pretvorena u listu izgleda ovako: ~w~n", [Tuple_to_list]),
  List_to_tuple = list_to_tuple(Inicijali),
  io:format("Lista ~p pretvorena u n-torku izgleda ovako: ~p~n~n", [Inicijali, List_to_tuple]),

  Atom = atom,
  io:format("Atom ~p pretvoren u listu izgleda ovako: ~p~n", [Atom, atom_to_list(Atom)]),
  io:format("Lista ~p pretvorena u atom izgleda ovako: ~p~n~n", [Tekst, list_to_atom(Tekst)]).

  % Za rad sa stringovima imamo modul strings, a neke od korisnih funkcija su:
  % string:len(S).            - ispisuje dužinu stringa
  % string:concat(S, "!!!").  - konkatenira stringove
  % string:tokens(S, " ").    - razdvaja string na temelju znaka (tokena) koji je stavljen kao drugi argument
  % strings:to_upper(S).      - pretvara sve znakove u velika slova