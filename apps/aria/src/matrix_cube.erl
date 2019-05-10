%%% This Source Code Form is subject to the terms of the Mozilla Public
%%% License, v. 2.0. If a copy of the MPL was not distributed with this
%%% file, You can obtain one at https://mozilla.org/MPL/2.0/. */
%%%-------------------------------------------------------------------
%%% @author captcha
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. Sep 2017 下午5:26
%%%-------------------------------------------------------------------
-module(matrix_cube).
-author("captcha").

-behaviour(gen_server).

%% API
-export([
    start_link/0,
    get_cubes/0,
    add_cube/2,
    sub_cube/1,
    upt_cube/2
]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {index_node}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%--------------------------------------------------------------------
%% @doc
%% get list of cube with {index, node}
%%
%% @end
%%--------------------------------------------------------------------
-spec get_cubes() -> list().
get_cubes() ->
    read_cube_from_db().

%%--------------------------------------------------------------------
%% @doc
%% add cube to cubes with CubeIndex
%%
%% @end
%%--------------------------------------------------------------------
-spec add_cube(CubeIndex::tuple(), Node::string()) -> ok.
add_cube(CubeIndex, Node) ->
    add_cube_to_matrix(CubeIndex, Node).

%%--------------------------------------------------------------------
%% @doc
%% sub a cube with CubeIndex from cubes
%%
%% @end
%%--------------------------------------------------------------------
-spec sub_cube(CubeIndex::tuple()) -> ok.
sub_cube(CubeIndex) ->
    sub_cube_from_matrix(CubeIndex).

%%--------------------------------------------------------------------
%% @doc
%% sub a cube with CubeIndex in cubes
%%
%% @end
%%--------------------------------------------------------------------
-spec upt_cube(CubeIndex::tuple(), Node::string()) -> ok.
upt_cube(CubeIndex, Node) ->
    update_cude_in_matrix(CubeIndex, Node).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
    {ok, State :: #state{}} | {ok, State :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term()} | ignore).
init([]) ->
    IndexNodeList = read_cube_from_db(),
    utils_log:info("~n[~p, ~p] IndexNodeList : ~p~n", [?MODULE, ?LINE, IndexNodeList]),
    {ok, #state{index_node = IndexNodeList}}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_call(Request :: term(), From :: {pid(), Tag :: term()},
    State :: #state{}) ->
    {reply, Reply :: term(), NewState :: #state{}} |
    {reply, Reply :: term(), NewState :: #state{}, timeout() | hibernate} |
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), Reply :: term(), NewState :: #state{}} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
-spec(handle_cast(Request :: term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_cast(_Request, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
-spec(handle_info(Info :: timeout() | term(), State :: #state{}) ->
    {noreply, NewState :: #state{}} |
    {noreply, NewState :: #state{}, timeout() | hibernate} |
    {stop, Reason :: term(), NewState :: #state{}}).
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
    {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
read_cube_from_db() ->
    CubeMetaKey = utils_env:get(cube_meta_key, <<"cube_meta_key">>),
    utils_log:debug("[~p, ~p] CubeMetaKey: ~p~n", [?MODULE, ?LINE, CubeMetaKey]),
    read_cube_from_db(CubeMetaKey).
read_cube_from_db(CubeMetaKey) ->
    case_matrix_database_get(CubeMetaKey, matrix_database:get(CubeMetaKey)).

case_matrix_database_get(_CubeMetaKey, {ok, IndexNodeJson}) ->
    IndexNodeList = utils_json:decode(IndexNodeJson),
    IndexNodeList;
case_matrix_database_get(CubeMetaKey, {error, _Reason}) ->
    DefaultCubeIndex = utils_env:get(default_cube_index, {0, 0, 1}),
    utils_log:debug("[~p, ~p] DefaultCubeIndex: ~p~n", [?MODULE, ?LINE, DefaultCubeIndex]),
    IndexNodeList = [{matrix_cube_id:get_id(DefaultCubeIndex), node()}],
    IndexNodeJson = utils_json:encode(IndexNodeList),
    matrix_database:put(CubeMetaKey, IndexNodeJson),
    IndexNodeList.

update_cude_in_matrix(CubeIndex, Node) ->
    sub_cube_from_matrix(CubeIndex),
    add_cube_to_matrix(CubeIndex, Node),
    ok.

add_cube_to_matrix(CubeIndex, Node) ->
    CudeKey = matrix_cube_id:get_id(CubeIndex),
    AddIndexNode = [{CudeKey, Node}],
    CubeMetaKey = utils_env:get(cube_meta_key, <<"cube_meta_key">>),
    IndexNodeList = read_cube_from_db(CubeMetaKey),
    NewIndexNodeList = lists:append(AddIndexNode, IndexNodeList),
    NewIndexNodeJson = utils_json:encode(NewIndexNodeList),
    matrix_database:put(CubeMetaKey, NewIndexNodeJson),
    ok.

sub_cube_from_matrix(CubeIndex) ->
    CudeKey = matrix_cube_key:get_key(CubeIndex),
    CubeMetaKey = utils_env:get(cube_meta_key, <<"cube_meta_key">>),
    IndexNodeList = read_cube_from_db(CubeMetaKey),
    NewIndexNodeList = lists:keydelete(CudeKey, 1, IndexNodeList),
    NewIndexNodeJson = utils_json:encode(NewIndexNodeList),
    matrix_database:put(CubeMetaKey, NewIndexNodeJson),
    ok.