%%% This Source Code Form is subject to the terms of the Mozilla Public
%%% License, v. 2.0. If a copy of the MPL was not distributed with this
%%% file, You can obtain one at https://mozilla.org/MPL/2.0/. */
%%%-------------------------------------------------------------------
%%% @author captcha
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Sep 2017 下午1:56
%%%-------------------------------------------------------------------
-module(utils_tool).
-author("captcha").

-define(EPOCH_DIFF, 62167219200).

%% API
%% System Level
-export([local_milli_seconds/0, milli_seconds/0, seconds/0]).
-export([epoch_micro_ts/0, epoch_now/0, epoch_utc/1, epoch_utc_now/0, utc_now/0, utc/1]).

%% Language Level
-export([to_atom/1, to_binary/1, to_integer/1, to_list/1]).
%%% ==================================================================
%%% SYSTEM LEVEL
%%% ==================================================================
%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
local_milli_seconds() ->
  {MegaSecs, Secs, MicroSecs} = os:timestamp(),
  1000000000 * MegaSecs + Secs * 1000 + MicroSecs div 1000.

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
-spec milli_seconds() -> integer().
milli_seconds() ->
  erlang:system_time(milli_seconds).

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
-spec seconds() -> integer().
seconds() ->
  erlang:system_time(seconds).

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
epoch_micro_ts() ->
  T = {_, _, Micro} = os:timestamp(),
  epoch_utc(T) * 1000 + trunc(Micro / 1000).

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
epoch_now() ->
  TS = {_, _, Micro} = os:timestamp(),
  {{Y, M, D}, {H, MM, S}} = calendar:now_to_local_time(TS),
  iolist_to_binary(io_lib:format("~4.4.0w-~2.2.0w-~2.2.0wT~2.2.0w:~2.2.0w:~2.2.0w.~3.3.0wZ", [Y, M, D, H, MM, S, trunc(Micro / 1000)])).

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
epoch_utc(Now) ->
  calendar:datetime_to_gregorian_seconds(calendar:now_to_universal_time(Now)) - ?EPOCH_DIFF.

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
epoch_utc_now() ->
  epoch_utc(os:timestamp()).

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
utc_now() ->
  utc(os:timestamp()).

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
utc(Now = {_, _, Micro}) ->
  {{Y, M, D}, {H, MM, S}} = calendar:now_to_universal_time(Now),
  iolist_to_binary(io_lib:format("~4.4.0w-~2.2.0w-~2.2.0wT~2.2.0w:~2.2.0w:~2.2.0w.~3.3.0wZ", [Y, M, D, H, MM, S, trunc(Micro / 1000)])).


%%% ==================================================================
%%% LANGUAGE LEVEL
%%% ==================================================================
%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
-spec to_atom(X) -> atom()
  when X :: atom()|list()|binary().
to_atom(X) when is_binary(X) ->
  to_atom(binary_to_list(X));
to_atom(X) when is_list(X) ->
  list_to_atom(X);
to_atom(X) when is_atom(X) ->
  X.

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
-spec to_binary(X) -> binary()
  when X :: atom()|integer()|list()|float()|binary().
to_binary(X) when is_atom(X) ->
  to_binary(atom_to_list(X));
to_binary(X) when is_integer(X) ->
  to_binary(integer_to_list(X));
to_binary(X) when is_float(X) ->
  float_to_binary(X);
to_binary(X) when is_list(X) ->
  list_to_binary(X);
to_binary(X) when is_binary(X) ->
  X.

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
-spec to_integer(X) -> binary()
  when X :: atom()|integer()|list()|float()|binary().
to_integer(X) when is_atom(X) ->
  to_integer(atom_to_list(X));
to_integer(X) when is_list(X) ->
  list_to_integer(X);
to_integer(X) when is_float(X) ->
  to_integer(float_to_binary(X));
to_integer(X) when is_binary(X) ->
  binary_to_integer(X);
to_integer(X) when is_integer(X) ->
  X.

%%--------------------------------------------------------------------
%% @doc
%%
%% @end
%%--------------------------------------------------------------------
-spec to_list(X) -> binary()
  when X :: atom()|integer()|list()|float()|binary().
to_list(X) when is_atom(X) ->
  atom_to_list(X);
to_list(X) when is_binary(X) ->
  binary_to_list(X);
to_list(X) when is_integer(X) ->
  integer_to_list(X);
to_list(X) when is_float(X) ->
  float_to_list(X);
to_list(X) when is_list(X) ->
  X.
