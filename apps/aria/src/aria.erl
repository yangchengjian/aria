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


init_with_agent([{MinZ, MaxZ}, {_MinY, _MaxY}, {_MinX, _MaxX}]) when MinZ >= MaxZ ->
  ok;
init_with_agent([{MinZ, MaxZ}, {MinY, MaxY}, {MinX, MaxX}]) ->
  PidList = matrix_agent_id:get_ids([{MinY, MaxY}, {MinX, MaxX}]),
  utils_tool:send(PidList, {init, {MinZ, MaxZ}}).

