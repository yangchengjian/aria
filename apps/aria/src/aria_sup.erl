%%%-------------------------------------------------------------------
%% @doc aria top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(aria_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
  MatrixDatabaseLeveldb = child(matrix_database_rocksdb),
  MatrixCube = child(matrix_cube),
  {ok, {{one_for_all, 0, 1}, [
    MatrixDatabaseLeveldb,
    MatrixCube
  ]}}.

%%====================================================================
%% Internal functions
%%====================================================================
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
child(Id) ->
  {Id, {Id, start_link, []}, permanent, 5000, worker, [Id]}.