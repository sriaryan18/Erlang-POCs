-module(genServer).
-behaviour(gen_server).

-export([start/0, increase/0,print/0]).

-export([handle_call/3, handle_cast/2, terminate/2,handle_info/2,init/1]).

start()->
    gen_server:start_link({local,genServer},genServer,[],[]).

init([])->
    {ok,0}.

increase()->
    gen_server:call(genServer,increment).

print()->
    gen_server:call(genServer,print).

handle_call(increment, _From, Counter) ->
    {reply, ok, Counter + 1};
handle_call(print, _From, Counter) ->
    {reply, Counter, Counter}.

handle_cast(_Msg,Counter)->
    {noreply,Counter}.

handle_info(_Info,Counter)->
    {noreply,Counter}.

terminate(_Reason,_Counter)->
    ok.


