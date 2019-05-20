%%% This Source Code Form is subject to the terms of the Mozilla Public
%%% License, v. 2.0. If a copy of the MPL was not distributed with this
%%% file, You can obtain one at https://mozilla.org/MPL/2.0/. */
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
  init_with_agent/1,
  print_10x10/3
]).


init_with_agent({MinZ, MaxZ}) when MinZ > MaxZ ->
  ok;
init_with_agent({MinZ, MaxZ}) ->
  PidList = matrix_agent_id:get_ids([{0, 99}, {0, 99}]),
  utils_log:debug("[~p, ~p] init_with_agent PidList {Z, Y, X}: ~p", [?MODULE, ?LINE, PidList]),
  matrix_agent:send(PidList, {init, {MinZ, MaxZ}}).

%%aria:print_10x10({0, 0, 0}, 10, 10).
%%[91,92,93,94,95,96,97,98,99,100]
%%
%%[81,82,83,84,85,86,87,88,89,90]
%%
%%[71,72,73,74,75,76,77,78,79,80]
%%
%%[61,62,63,64,65,66,67,68,69,70]
%%
%%[51,52,53,54,55,56,57,58,59,60]
%%
%%[41,42,43,44,45,46,47,48,49,50]
%%
%%[31,32,33,34,35,36,37,38,39,40]
%%
%%[21,22,23,24,25,26,27,28,29,30]
%%
%%[11,12,13,14,15,16,17,18,19,20]
%%
%%[1,2,3,4,5,6,7,8,9,10]
print_10x10(_, 0, _) ->
  ok;
print_10x10({Z, Y, X}, LenY, LenX) ->
  print_every_y({Z, Y + LenY - 1, X}, LenX, []),
  print_10x10({Z, Y, X}, LenY - 1, LenX).

print_every_y(_, 0, Result) ->
  io:format("~n~w~n", [Result]);
print_every_y({Z, Y, X}, LenX, Result) ->
  NodeState = matrix_node:get_node_state({Z, Y, X + LenX - 1}),
  print_every_y({Z, Y, X}, LenX - 1, [NodeState | Result]).



