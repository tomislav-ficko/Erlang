%%%-------------------------------------------------------------------
%%% @author Tomi
%%% @copyright (C) 2020, Ficko
%%%
%%% Created : Oct 31, 2020 14:00
%%%-------------------------------------------------------------------
-module(distribuirano).
-author("Tomi").

-export([receive_loop/0]).
-import(io, [format/2]).

receive_loop() ->
    receive
        {From, Msg} ->
            From!{self(), Msg},
            format("FORMAT Received: ~p~n", [Msg]), % Ispisuje se na group leaderu, što je u ovom slučaju čvor X
            erlang:display(["DISPLAY Received", Msg]), % Ispisuje se tamo gdje se funkcija izvršava, na čvoru Y
            receive_loop();
        stop ->
            true
    end.

% Bitno: Korištenje funkcije "io:format()" u distribuiranom sustavu može biti korisno kada imamo velik broj konkurentnih 
% .. čvorova i procesa, i želimo primati obavijesti na jednom mjestu (na group leaderu, čvoru koji je pokrenuo sve ostale)

start_global() ->
    Pid = spawn(distribuirano, receive_loop, []),
    global:register_name(naziv, Pid).

call_global(Msg) ->
    Pid = global:whereis_name(naziv),
    Pid!{self(), Msg}.

% ----- Pokretanje distribuiranih čvorova putem terminala -----
% 1. Otvoriti dva terminala i pozicionirati se u ~/Erlang/primjeri
% 2. Prvi terminal  - Pokretanje čvora X: erl -pa ./ -sname X -setcookie cookie
% 3. Drugi terminal - Pokretanje čvora Y: erl -pa ./ -sname Y -setcookie cookie
% 4. Prvi terminal  - Sa čvora X pokrenuti proces na čvoru Y: P = spawn('Y@Acer-Swift-3', distribuirano, receive_loop, []).
%   -> Nakon izvršavanje te naredbe čvorovi X i Y su automatski povezani


% ----- Pokretanje distribuiranih čvorova putem Dockera -----
% 1. Pokretanje čvora Y: docker run -it --rm --name yd -h y.local -v C:/Users/<username>/Documents/Erlang/primjeri -w /usr/dir erlang erl -sname Y -setcookie cookie -pa /usr/dir 
%                        |                                         Docker naredba                                                     |               Erlang naredba            |
%
% Objašnjenje naredbi:
%                       -> -it = interaktivno/terminal
%                       -> -rm = briše kontejner nakon gašenja
%                       -> --name = ime docker kontejnera
%                       -> -h = hostname/naziv računala (DNS)
%                       -> -v = volume/preslikavanje direktorija (PWD) na domaćinu (host) na kontejner
%                       -> -w = working directory/trenutni radni direktorij kontejnera kad se pokrene
% 
% 2. Pokretanje čvora X: docker run -it --rm -h x.local -link yd:Y -v C:/Users/<username>/Documents/Erlang/primjeri -w /usr/dir erlang erl -sname X -setcookie cookie -pa /usr/dir
% 
% Objašnjenje naredbi:
%                       -> --link = povezivanje imena računala između kontejnera (ime kontejnera "yd" će biti čvor "y" u DNS-u čvora X)


% ----- Pokretanje distribuiranih čvorova putem Dockerfile-a -----
% 1. Sadržaj dockerfile-a (mora se nalaziti unutar C:/Users/<username>/Documents/Erlang/primjeri):
%   FROM erlang
%   ADD . /usr/dir
%   WORKDIR /usr/dir
%   ENTRYPOINT ["erl", "-setcookie", "cookie", "-pa", "/usr/dir"]
%
% 2. Stvaranje slike (terminal):
%       docker build -t kp_dist .   - stvara sliku
%       docker images               - lista svih slika
%       docker rmi kp_dist          - briše sliku kp_dist
%
% 3. Pokretanje čvora Y: docker run -it --rm --name yd -h y.local kp_dist -sname y
% 4. Pokretanje čvora X: docker run -it --rm --name xd -h x.local --link yd:y kp_dist -sname x
