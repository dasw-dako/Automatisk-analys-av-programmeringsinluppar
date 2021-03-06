%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Runs checkstyle on all files in given directory.                        % 
%All uncommented lines are counted and results are saved to results.html %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(checkstyle).
-export([run/2,save_from_backup/1]).

save_from_backup(BackupFile) ->
  {ok, Binary}  = file:read_file(BackupFile),
  Backup = binary_to_term(Binary),
  save:save_to_file(Backup,false).

run(Dir,SaveName) -> 
  {ok, Count, Results,AverageComments,NrLines} = run_per_dir(Dir),
  Stddiv = analyze:get_stddiv(Results,Count),
  save:save_to_file({Results,Count, Stddiv, NrLines , AverageComments ,SaveName},true).

run_per_dir(Dir) ->
    {ok,Filenames} = file:list_dir(Dir),
    run_per_dir(Dir,Filenames,0,[],0,0).

run_per_dir(_,[],Count,Res,AverageComents,NrLines) -> {ok, Count, Res,AverageComents,NrLines};
run_per_dir(Dir, [DirName|Filenames],Count, Res, AverageComents,NrLines) ->
  PathDir = Dir ++ DirName,
  case filelib:is_dir(PathDir) of 
    true ->
      case Result = run_checkstyle(DirName,PathDir) of 

      false -> 
        run_per_dir(Dir, Filenames,Count ,Res,AverageComents,NrLines);
      {_,NrLines1,_,_,AverageComments1} ->
          Res1 = Res ++ [Result],
           run_per_dir(Dir, Filenames,Count + 1,Res1,AverageComments1 + AverageComents,NrLines + NrLines1)
      end;
     
    false ->
      run_per_dir(Dir, Filenames,Count,Res,AverageComents,NrLines)
  end.
 
run_checkstyle(DirName,Path) ->
  {NrLines,NrComments} = count_lines:count(Path ++ "/"),
  io:format("Running Checkstyle at ~p ~n", [Path]),
  Checkstyle = os:cmd("java -jar ../checkstyle/checkstyle-5.7-all.jar -c ../checkstyle/sun_checks.xml -r " ++ Path ++ "/*.java" ++  " -f xml"),
  io:format("CheckStyle on ~p completed ~n", [Path]),
  io:format("Analyzing results on ~p ~n", [Path]),
  Results = analyze:get_error_frequency(Checkstyle),
  case Results of 
    false ->
      false;
    _else ->
        {Results, NrLines,NrComments, DirName,NrComments / NrLines}
  end.








