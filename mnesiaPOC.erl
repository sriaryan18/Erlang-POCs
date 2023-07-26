-module(mnesiaPOC).
-export([storeDB/2,getDB/1,initDB/0]).
-include_lib("stdlib/include/qlc.hrl").
-record(factorial,{nodeName,comment,createdOn}).

% initDB()->
%     mnesia:create_schema([node()]),
%     mnesia:start(),
%     try
%         mnesia:table_info(type,factorial)
%     catch
%     _: _ ->
%             mnesia:create_table(factorial,[{attributes,record_info(fields,factorial)},
%                 {type,bag},
%                 {disc_copies,[node()]}])
%     end.
initDB() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(factorial, [
                {attributes, record_info(fields, factorial)},
                {type, bag},
                {disc_copies, [node()]}
            ]).
    % case mnesia:table_info(factorial, type) of
    %     bag -> ok; % Table exists, do nothing
    %     _ -> mnesia:create_table(factorial, [
    %             {attributes, record_info(fields, factorial)},
    %             {type, bag},
    %             {disc_copies, [node()]}
    %         ])
    % end.

storeDB(Nodename, Comment) ->
    AF = fun() ->
        {CreatedOn, _} = calendar:universal_time(),
        mnesia:write(#factorial{nodeName = Nodename, comment = Comment, createdOn = CreatedOn})
    end,
    mnesia:transaction(AF).
getDB(Nodename)->
    AF=fun()->
        Query=qlc:q([X || X <- mnesia:table(factorial),
        X#factorial.nodeName =:= Nodename]),
        Results=qlc:e(Query),
        % Results
        lists:map(fun(Item)->{Item#factorial.comment} end, Results)
        end,
    {atomic,Comments}=mnesia:transaction(AF),
    Comments.