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
  init_with_agent/1
]).


init_with_agent([{MinZ, MaxZ}]) when MinZ > MaxZ ->
  ok;
init_with_agent([{MinZ, MaxZ}]) ->
  PidList = matrix_agent_id:get_ids([{0, 99}, {0, 99}]),
  utils_tool:send(PidList, {init, {MinZ, MaxZ}}).

