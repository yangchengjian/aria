%%%-------------------------------------------------------------------
%%% @author captcha
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Sep 2017 下午2:02
%%%-------------------------------------------------------------------
-module(matrix_entry).
-author("captcha").

%% API
-export([
    map/1
]).

-spec map(Matrix3i::list()) -> ok.
map(Matrix3i) ->
%%    Matrix3i = [
%%        {0, 0, 1}, {0, 1, 2}, {0, 2, 3},
%%        {1, 0, 4}, {1, 1, 5}, {1, 2, 6},
%%        {2, 0, 7}, {2, 1, 8}, {2, 2, 9}],
    Fun = fun({Y, X, Value}) ->
        NodeKey = matrix_node_id:get_id({0, Y, X}),
        Decoder = matrix_node:decoder(),
        Encoder = matrix_node:encoder(),
        NewNode = case matrix_database:get(NodeKey) of
                   {ok, NodeJson} ->
                       RawNode = Decoder(NodeJson),
                       matrix_node:set_state(RawNode, matrix_node_state:get_state({0, 0, Value}));
                   {error, _} ->
                       matrix_node:new_node(NodeKey, matrix_util:to_binary(Value), matrix_util:epoch_micro_ts(), matrix_node_id:get_id({1, Y, X}))
               end,
        NewNodeJson = Encoder(NewNode),
        matrix_database:put(NodeKey, NewNodeJson)
          end,
    lists:foreach(Fun, Matrix3i).


