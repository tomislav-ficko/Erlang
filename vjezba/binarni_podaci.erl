%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : 16. Oct 2020 11:40
%%%-------------------------------------------------------------------
-module(binarni_podaci).  % Deklaracija modula
-author("Tomi").

-export([run/0]).         % Deklaracija funkcija koje se mogu pozvati izvan modula

%%% ------ Rad s binarnim podacima ---------

run() ->
  binary_example().

binary_example() ->
  B = <<16#ff00:16, 16#ffa0:16, 8>>,
  io:fwrite("Initial bytes are: ~w~n", [B]),

  StartingPosition = byte_size(B),

  FirstPositionTuple = create_size_tuple(0, 2),
  FirstBytes = get_bytes_from_position(B, FirstPositionTuple),
  io:fwrite("First two bytes are: ~w~n", [FirstBytes]),

  SecondPositionTuple = create_size_tuple(StartingPosition, -3),
  LastBytes = get_bytes_from_position(B, SecondPositionTuple),
  io:fwrite("Last three bytes are: ~w~n", [LastBytes]).

get_bytes_from_position(Bitstring, Tuple) -> binary:part(Bitstring, Tuple).

create_size_tuple(StartPosition, NoOfSpacesToMove) -> {StartPosition, NoOfSpacesToMove}.