%%% This Source Code Form is subject to the terms of the Mozilla Public
%%% License, v. 2.0. If a copy of the MPL was not distributed with this
%%% file, You can obtain one at https://mozilla.org/MPL/2.0/. */
%%%-------------------------------------------------------------------
%%% @author captcha
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Sep 2017 下午2:03
%%%-------------------------------------------------------------------
-module(matrix_database).
-author("captcha").

%% API
-export([
    get/1,
    put/2
]).

get(Key) ->
   matrix_database_rocksdb:get(Key).

put(Key, Value) ->
  matrix_database_rocksdb:put(Key, Value).
