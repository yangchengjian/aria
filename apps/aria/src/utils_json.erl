%%% This Source Code Form is subject to the terms of the Mozilla Public
%%% License, v. 2.0. If a copy of the MPL was not distributed with this
%%% file, You can obtain one at https://mozilla.org/MPL/2.0/. */
%%%-------------------------------------------------------------------
%%% @author captcha
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Sep 2017 下午6:55
%%%-------------------------------------------------------------------
-module(utils_json).
-author("captcha").

%% API
-export([encode/1, decode/1]).

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
-spec encode(list()|tuple()) -> binary().
encode(Data) ->
  jsx:encode(Data).


%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
-spec decode(binary()) -> proplists:proplist().
decode(Bin) ->
  jsx:decode(Bin).

