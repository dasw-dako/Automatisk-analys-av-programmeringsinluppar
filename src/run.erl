-module(run).
-compile(export_all).

test() ->
  checkstyle:run("../testcode/","testcodeResults").

oop1() ->
   checkstyle:run("../oop1/","oop1Results").

oop2() ->
   checkstyle:run("../oop2/","oop2Results").

alda() ->
   checkstyle:run("../alda/","aldaResults").