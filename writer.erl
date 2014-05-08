-module(writer).
-compile(export_all).

write(Data) ->  
  writer ! {write, Data}.

close() -> writer ! {close}.

run(FileName) ->
  register(writer,spawn(fun() -> 
    {ok, IO} = file:open(FileName,[write,raw]),
    writer(IO) 
  end)).
  

writer(IO) ->
  receive 
    {write, Data} ->
      ok = file:write(IO, Data),
      writer(IO);
    {close} ->
      file:close(IO),
      unregister(writer)
  end.