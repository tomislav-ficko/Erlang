FROM erlang
ADD . /usr/dir
WORKDIR /usr/dir
ENTRYPOINT ["erl", "-setcookie", "cookie", "-pa", "/usr/dir"]