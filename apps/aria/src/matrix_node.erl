%%%-------------------------------------------------------------------
%%% @author captcha
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Sep 2017 下午5:50
%%%-------------------------------------------------------------------
-module(matrix_node).
-author("captcha").

-include("aria.hrl").

%% API
-export([
    new_node/0, new_node/4,
    get_id/1, set_id/2,
    get_state/1, set_state/2,
    get_timestamp/1, set_timestamp/2,
    get_next/1, set_next/2
]).

-export([encoder/0, decoder/0, nonstrict_decoder/0]).

-spec new_node() -> matrix_node().
new_node() ->
    #matrix_node{}.

-spec new_node(binary(), binary(), integer(), list()) -> matrix_node().
new_node(Id, State, Timestamp, Next) ->
    #matrix_node{id = Id, node_state = State, timestemp = Timestamp, next = Next}.

%% @doc
%% set id
%% @end
-spec set_id(matrix_node(), binary()) -> matrix_node().
set_id(MatrixNode, Id) ->
    MatrixNode#matrix_node{id = Id}.

%% @doc
%% set node_state
%% @end
-spec set_state(matrix_node(), binary()) -> matrix_node().
set_state(MatrixNode, NodeState) ->
    MatrixNode#matrix_node{node_state = NodeState}.

%% @doc
%% set timestemp
%% @end
-spec set_timestamp(matrix_node(), integer()) -> matrix_node().
set_timestamp(MatrixNode, Timestamp) ->
    MatrixNode#matrix_node{timestemp = Timestamp}.

%% @doc
%% set next
%% @end
-spec set_next(matrix_node(), list()) -> matrix_node().
set_next(MatrixNode, Next) ->
    MatrixNode#matrix_node{next = Next}.

%% @doc
%% get id
%% @end
-spec get_id(matrix_node()) -> binary().
get_id(#matrix_node{id = Id} = _MatrixNode) ->
    Id.

%% @doc
%% get node_state
%% @end
-spec get_state(matrix_node()) -> binary().
get_state(#matrix_node{node_state = NodeState} = _MatrixNode) ->
    NodeState.

%% @doc
%% get timestemp
%% @end
-spec get_timestamp(matrix_node()) -> integer().
get_timestamp(#matrix_node{timestemp = Timestamp} = _MatrixNode) ->
    Timestamp.

%% @doc
%% get next
%% @end
-spec get_next(matrix_node()) -> list().
get_next(#matrix_node{next = Next} = _MatrixNode) ->
    Next.


encoder() ->
    jsx:encoder([{matrix_node, record_info(fields, matrix_node)}]).

decoder() ->
    jsx:decoder([{matrix_node, record_info(fields, matrix_node)}]).

nonstrict_decoder() ->
    jsx:decoder([{matrix_node, record_info(fields, matrix_node)}],
        [{format, proplist}]).



