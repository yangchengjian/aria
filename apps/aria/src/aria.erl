%%%-------------------------------------------------------------------
%%% @author yangchengjian
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. May 2019 21:28
%%%-------------------------------------------------------------------
-module(aria).
-author("yangchengjian").

%% API
-export([
  init/1
]).

init([{MinZ, MaxZ}, {_MinY, _MaxY}, {_MinX, _MaxX}]) when MinZ >= MaxZ ->
  ok;
init([{MinZ, MaxZ}, {MinY, MaxY}, {MinX, MaxX}]) ->
  init_y([{MinZ, MaxZ}, {MinY, MaxY}, {MinX, MaxX}]),
  init([{MinZ + 1, MaxZ}, {MinY, MaxY}, {MinX, MaxX}]).

init_y([{_MinZ, _MaxZ}, {MinY, MaxY}, {_MinX, _MaxX}]) when MinY >= MaxY ->
  ok;
init_y([{MinZ, MaxZ}, {MinY, MaxY}, {MinX, MaxX}]) ->
  init_x([{MinZ, MaxZ}, {MinY, MaxY}, {MinX, MaxX}]),
  init_y([{MinZ, MaxZ}, {MinY + 1, MaxY}, {MinX, MaxX}]).

init_x([{_MinZ, _MaxZ}, {_MinY, _MaxY}, {MinX, MaxX}]) when MinX >= MaxX ->
  ok;
init_x([{MinZ, MaxZ}, {MinY, MaxY}, {MinX, MaxX}]) ->
  utils_log:debug("[~p, ~p] init_x: ~p~n", [?MODULE, ?LINE, {MinZ, MinY, MinX}]),
  init(MinZ, MinY, MinX),
  init_x([{MinZ, MaxZ}, {MinY, MaxY}, {MinX + 1, MaxX}]).


init(Z, Y, X) ->
  NodeKey = matrix_node_key:get_key({Z, Y, X}),
  NodeState = matrix_node_state:get_state({Z, Y, X}),
  Timestamp = utils_tool:epoch_micro_ts(),
  NodeNext = [matrix_node_key:get_key({Z + 1, Y, X})],
  MatrixNodeJson = utils_json:encode([{id, NodeKey}, {node_state, NodeState}, {timestemp, Timestamp}, {next, NodeNext}]),
  matrix_database:put(NodeKey, MatrixNodeJson).
