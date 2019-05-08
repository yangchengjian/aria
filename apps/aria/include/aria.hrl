%%%-------------------------------------------------------------------
%%% @author yangchengjian
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. May 2019 20:10
%%%-------------------------------------------------------------------
-author("yangchengjian").

-define(LOG, lager).

-export_type([matrix_node/0]).

-record(matrix_node, {
  id :: binary(),              %% 唯一标示
  node_state :: binary(),      %% 状态， 包含一系列激活参数
  timestemp :: integer(),      %% 时间戳， 毫秒级， 表明最近一次激活时间
  next :: list()               %% 下一matrix_node的id
}).

-type matrix_node() :: matrix_node.
