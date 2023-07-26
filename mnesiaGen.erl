-module(mnesiaGen).
-behaviour(gen_server).

%% API

-export([start_link/1]).
-export([init/1, handle_call/3, terminate/2, code_change/3,addTODB/2,getFromDB/1]).
-record(state, {}).

% start(Name) ->
%     gen_server:start_child(Name).

% stop(Name) ->
%     gen_server:call(Name, stop).

start_link(Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [], []).

init(_Args) ->
    process_flag(trap_exit,true),
    io:format("....starting ~p",[{global,?MODULE}]),
    mnesiaPOC:initDB(),
    {ok, #state{}}.

addTODB(NodeName,Comment)->
    gen_server:call(mnesiaGen,{store,NodeName,Comment}).

getFromDB(NodeName)->
    gen_server:call(mnesiaGen,{getData,NodeName}).

handle_call({store,NodeName,Comment}, _From, State) ->
   mnesiaPOC:storeDB(NodeName,Comment),
   io:format("Comment has been stored in ~p",[NodeName]),
   {reply,ok,State};
handle_call({getData,Nodename}, _From, State) ->
    Comments=mnesiaPOC:getDB(Nodename),
    lists:map(fun(CM)->
        io:format("Received: ~p~n",[CM])
        end, Comments),
    {reply,ok,State}.

% handle_call(_Request, _From, State) ->
%     {reply, ok, State}.

% handle_info(_Info, State) ->
%     {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
