%%%-------------------------------------------------------------------
%%% @author captcha
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Sep 2017 下午1:59
%%%-------------------------------------------------------------------
-module(utils_env).
-author("captcha").

%% API
-export([get/1, get/2]).
-export([get_app/2, get_app/3]).
-export([application/0]).

%% @doc
%% @end
-spec get(term()) -> undefined|any().
get(Key) ->
    get(Key, undefined).

%% @doc
%% @end
-spec get(term(), any()) -> any().
get(Key, Defualt) ->
    App = application(),
    get_app(App, Key, Defualt).


%% @doc
%% @end
-spec get_app(atom(), term()) -> undefined|any().
get_app(App, Key) ->
    get_app(App, Key, undefined).

%% @doc
%% @end
-spec get_app(atom(), term(), any()) -> undefined|any().
get_app(App, Key, Defualt) ->
    application:get_env(App, Key, Defualt).

%% @doc
%% @end
-spec application() -> atom().
application() ->
    {ok, Application} = application:get_application(?MODULE),
    Application.