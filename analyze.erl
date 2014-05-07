-module(analyze).
-compile(export_all).



match_errors(Res) ->
  Reg = "source=\"com\.puppycrawl\.tools\.checkstyle\.checks\.(?<ERR>.+)\"",
  {match,Results} = re:run(Res,Reg,[global,{capture,['ERR'],list}]),
  Results.

get_error_frequency(Checkstyle) ->
	Results = match_errors(Checkstyle),
	get_error_frequency(Results, dict:new()).

get_error_frequency([],Res) -> Res;
get_error_frequency([[H]|T],Res) -> 
  case dict:is_key(H,Res) of
    true ->
      get_error_frequency(T,dict:update(H,fun(Val) -> Val+1 end, Res));
    false ->
      get_error_frequency(T,dict:store(H,1,Res))
  end.


get_stddiv(Results,Count) ->
	EmptyList = make_empty_list(Count),
	ErrorDict = get_occuring_errors(Results,dict:new(),EmptyList),
	erlang:display(get_freq_per_error(Results,dict:to_list(ErrorDict),dict:new())).

get_occuring_errors([],ErrorDict,_) -> ErrorDict;
get_occuring_errors([Result|Results],ErrorDict,EmptyList) ->
	{Errors, _, _} = Result,
	ErrorDict1 = check_errors(dict:to_list(Errors),ErrorDict,EmptyList),
	get_occuring_errors(Results, ErrorDict1, EmptyList).

check_errors([],ErrorDict,_) -> ErrorDict;
check_errors([{ErrorType, _}| Errors],ErrorDict,EmptyList) ->
	case dict:is_key(ErrorType, ErrorDict) of 
		true ->
			check_errors(Errors,ErrorDict,EmptyList);
		false ->
			check_errors(Errors,dict:store(ErrorType, EmptyList, ErrorDict), EmptyList)
	end.

make_empty_list(0) -> [];
make_empty_list(Count) ->
	[0] ++ make_empty_list(Count - 1).

get_freq_per_error(_,[],Result) -> Result;

get_freq_per_error(Results,[{Type, CountList} | Errors],ResultDict) -> 
	CountList1 = get_freq_per_error(Results,Type,CountList,[]),
	ResultDict1 = dict:store(Type, CountList1, ResultDict),
	get_freq_per_error(Results, Errors, ResultDict1).

get_freq_per_error([], _, _, CountList) -> CountList;

get_freq_per_error([Result | Results], ErrorTypeToCount, [_CurrentCount | CountList], FinalCountList) ->
	{Errors, _, _} = Result,
	Frequency = 
	case dict:is_key(ErrorTypeToCount, Errors) of 
		true ->
			dict:fetch(ErrorTypeToCount, Errors);
		false ->
			0
	end,
	get_freq_per_error(Results, ErrorTypeToCount, CountList, FinalCountList ++ [Frequency]).










