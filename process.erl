-module(process).
-export([start/0, produce/1, consume/1]).

start() ->
    PID = spawn(process, consume, [self()]),
    io:format("Sending message to consumer.~n"),
    produce(PID).

produce(PID) ->
    PID ! {aryan, self()},
    receive
        {result, Msg} ->
            io:format("~s~n",[Msg])
    end.

consume(ProducerPid) ->
    loop(ProducerPid).

loop(ProducerPid) ->
    receive
        {aryan, SenderPid} ->
            io:format("Consumer received message.~n"),
            SenderPid ! {result, "LE BHAI"}
            
    end,
    loop(ProducerPid).
