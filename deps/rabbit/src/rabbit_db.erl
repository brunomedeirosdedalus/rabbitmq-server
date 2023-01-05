%% This Source Code Form is subject to the terms of the Mozilla Public
%% License, v. 2.0. If a copy of the MPL was not distributed with this
%% file, You can obtain one at https://mozilla.org/MPL/2.0/.
%%
%% Copyright (c) 2007-2023 VMware, Inc. or its affiliates.  All rights reserved.
%%

-module(rabbit_db).

-include_lib("khepri/include/khepri.hrl").

-include_lib("kernel/include/logger.hrl").
-include_lib("stdlib/include/assert.hrl").

-export([run/1]).

-export([init/0, sync/0]).
-export([set_migration_flag/1, is_migration_done/1]).

%% Exported to be used by various rabbit_db_* modules
-export([
         list_in_mnesia/2,
         list_in_khepri/1,
         list_in_khepri/2,
         if_has_data/1,
         if_has_data_wildcard/0
        ]).

%% -------------------------------------------------------------------
%% run().
%% -------------------------------------------------------------------

-spec run(Funs) -> Ret when
      Funs :: #{mnesia := Fun},
      Fun :: fun(() -> Ret),
      Ret :: any().
%% @doc Runs the function corresponding to the used database engine.
%%
%% @returns the return value of `Fun'.

run(Funs)
  when is_map(Funs) andalso is_map_key(mnesia, Funs)
       andalso is_map_key(khepri, Funs) ->
    #{mnesia := MnesiaFun,
      khepri := KhepriFun} = Funs,
    case rabbit_khepri:use_khepri() of
        true ->
            run_with_khepri(KhepriFun);
        false ->
            try
                run_with_mnesia(MnesiaFun)
            catch
                _:{Type, {no_exists, Table}}
                  when Type =:= aborted orelse Type =:= error ->
                    %% We wait for the feature flag(s) to be enabled
                    %% or disabled (this is a blocking call) and
                    %% retry.
                    ?LOG_DEBUG(
                       "Mnesia function failed because table ~s "
                       "is gone or read-only; checking if the new "
                       "metadata store was enabled in parallel and "
                       "retry",
                       [Table]),
                    _ = rabbit_khepri:is_enabled(),
                    run(Funs)
            end
    end.

run_with_mnesia(Fun) ->
    Fun().

run_with_khepri(Fun) ->
    Fun().

%% Clustering used on the boot steps
init() ->
    rabbit_db:run(
      #{mnesia => fun() -> init_in_mnesia() end,
        khepri => fun() -> init_in_khepri() end
       }).

init_in_mnesia() ->
    recover_mnesia_tables(),
    rabbit_mnesia:init().

init_in_khepri() ->
    case rabbit_khepri:members() of
        [] ->
            timer:sleep(1000),
            init_in_khepri();
        Members ->
            rabbit_log:warning("Found the following metadata store members: ~p", [Members])
    end.

sync() ->
    rabbit_db:run(
      #{mnesia => fun() -> sync_in_mnesia() end,
        khepri => fun() -> ok end
       }).

sync_in_mnesia() ->
    rabbit_sup:start_child(mnesia_sync).

set_migration_flag(FeatureName) ->
    rabbit_khepri:put([?MODULE, migration_done, FeatureName], true).

is_migration_done(FeatureName) ->
    case rabbit_khepri:get([?MODULE, migration_done, FeatureName]) of
        {ok, Flag} ->
            Flag;
        _ ->
            false
    end.

%% Internal
%% -------------------------------------------------------------
list_in_mnesia(Table, Match) ->
    %% Not dirty_match_object since that would not be transactional when used in a
    %% tx context
    mnesia:async_dirty(fun () -> mnesia:match_object(Table, Match, read) end).

list_in_khepri(Path) ->
    list_in_khepri(Path, #{}).

list_in_khepri(Path, Options) ->
    case rabbit_khepri:match(Path, Options) of
        {ok, Map} -> maps:values(Map);
        _         -> []
    end.

if_has_data_wildcard() ->
    if_has_data([?KHEPRI_WILDCARD_STAR_STAR]).

if_has_data(Conditions) ->
    #if_all{conditions = Conditions ++ [#if_has_data{has_data = true}]}.

recover_mnesia_tables() ->
    %% A failed migration can leave tables in read-only mode before enabling
    %% the feature flag. See rabbit_core_ff:final_sync_from_mnesia_to_khepri/2
    %% Unlock them here as mnesia is still fully functional.
    Tables = rabbit_channel_tracking:get_all_tracked_channel_table_names_for_node(node())
        ++ rabbit_connection_tracking:get_all_tracked_connection_table_names_for_node(node())
        ++ [Table || {Table, _} <- rabbit_table:definitions()],
    [mnesia:change_table_access_mode(Table, read_write) || Table <- Tables],
    ok.
