%%%-------------------------------------------------------------------
%%% @author mike
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Oct 2017 1:56 PM
%%%-------------------------------------------------------------------
-module(matrix_cube_id).
-author("mike").

%% API
-export([]).

%% API
-export([
    get_id/1,
    get_zyx/1
]).

%% @doc
%% according to X, Y, Z get id for save data
%% @end
-spec get_id(X :: tuple()) -> binary().
get_id({Z, Y, X}) ->
    <<Z:16/integer, Y:16/integer, X:16/integer>>.

%% @doc
%% according to id get x, y, z
%% @end
-spec get_zyx(Key :: binary()) -> tuple().
get_zyx(Key) ->
    <<Z:16/integer, Y:16/integer, X:16/integer>> = Key,
    {Z, Y, X}.