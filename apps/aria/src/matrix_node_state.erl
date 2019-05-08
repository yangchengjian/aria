%%%-------------------------------------------------------------------
%%% @author captcha
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Sep 2017 下午4:13
%%%-------------------------------------------------------------------
-module(matrix_node_state).
-author("captcha").

%% API
-export([
    get_state/1,
    get_zyx/1
]).

%% @doc
%% according to X, Y, Z get a key for save data
%% @end
-spec get_state(X :: tuple()) -> binary().
get_state({Z, Y, X}) ->
    <<Z:16/integer, Y:16/integer, X:16/integer>>.

%% @doc
%% according to Key get x, y, z
%% @end
-spec get_zyx(Key::binary()) -> tuple().
get_zyx(Key) ->
    <<Z:16/integer, Y:16/integer, X:16/integer>> = Key,
    {Z, Y, X}.
