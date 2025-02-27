%% This Source Code Form is subject to the terms of the Mozilla Public
%% License, v. 2.0. If a copy of the MPL was not distributed with this
%% file, You can obtain one at https://mozilla.org/MPL/2.0/.
%%
%% Copyright (c) 2018-2023 VMware, Inc. or its affiliates.  All rights reserved.
%%

-module(rabbit_core_ff).

-include_lib("kernel/include/logger.hrl").

-include_lib("rabbit_common/include/logging.hrl").

-export([direct_exchange_routing_v2_enable/1,
         listener_records_in_ets_enable/1,
         listener_records_in_ets_post_enable/1,
         tracking_records_in_ets_enable/1,
         tracking_records_in_ets_post_enable/1]).

-rabbit_feature_flag(
   {classic_mirrored_queue_version,
    #{desc          => "Support setting version for classic mirrored queues",
      stability     => stable
     }}).

-rabbit_feature_flag(
   {quorum_queue,
    #{desc          => "Support queues of type `quorum`",
      doc_url       => "https://www.rabbitmq.com/quorum-queues.html",
      stability     => required
     }}).

-rabbit_feature_flag(
   {stream_queue,
    #{desc          => "Support queues of type `stream`",
      doc_url       => "https://www.rabbitmq.com/stream.html",
      %%TODO remove compatibility code
      stability     => required,
      depends_on    => [quorum_queue]
     }}).

-rabbit_feature_flag(
   {implicit_default_bindings,
    #{desc          => "Default bindings are now implicit, instead of "
                       "being stored in the database",
      stability     => required
     }}).

-rabbit_feature_flag(
   {virtual_host_metadata,
    #{desc          => "Virtual host metadata (description, tags, etc)",
      stability     => required
     }}).

-rabbit_feature_flag(
   {maintenance_mode_status,
    #{desc          => "Maintenance mode status",
      stability     => required
     }}).

-rabbit_feature_flag(
    {user_limits,
     #{desc          => "Configure connection and channel limits for a user",
       stability     => required
     }}).

-rabbit_feature_flag(
   {stream_single_active_consumer,
    #{desc          => "Single active consumer for streams",
      doc_url       => "https://www.rabbitmq.com/stream.html",
      stability     => stable,
      depends_on    => [stream_queue]
     }}).

-rabbit_feature_flag(
    {feature_flags_v2,
     #{desc          => "Feature flags subsystem V2",
       stability     => required
     }}).

-rabbit_feature_flag(
   {direct_exchange_routing_v2,
    #{desc       => "v2 direct exchange routing implementation",
      stability  => stable,
      depends_on => [feature_flags_v2, implicit_default_bindings],
      callbacks  => #{enable => {?MODULE, direct_exchange_routing_v2_enable}}
     }}).

-rabbit_feature_flag(
   {listener_records_in_ets,
    #{desc       => "Store listener records in ETS instead of Mnesia",
      stability  => stable,
      depends_on => [feature_flags_v2],
      callbacks  => #{enable =>
                      {?MODULE, listener_records_in_ets_enable},
                      post_enable =>
                      {?MODULE, listener_records_in_ets_post_enable}}
     }}).

-rabbit_feature_flag(
   {tracking_records_in_ets,
    #{desc          => "Store tracking records in ETS instead of Mnesia",
      stability     => stable,
      depends_on    => [feature_flags_v2],
      callbacks     => #{enable =>
                             {?MODULE, tracking_records_in_ets_enable},
                         post_enable =>
                             {?MODULE, tracking_records_in_ets_post_enable}}
     }}).

-rabbit_feature_flag(
   {classic_queue_type_delivery_support,
    #{desc          => "Bug fix for classic queue deliveries using mixed versions",
      doc_url       => "https://github.com/rabbitmq/rabbitmq-server/issues/5931",
      %%TODO remove compatibility code
      stability     => required,
      depends_on    => [stream_queue]
     }}).

-rabbit_feature_flag(
   {restart_streams,
    #{desc          => "Support for restarting streams with optional preferred next leader argument. "
      "Used to implement stream leader rebalancing",
      stability     => stable,
      depends_on    => [stream_queue]
     }}).

%% -------------------------------------------------------------------
%% Direct exchange routing v2.
%% -------------------------------------------------------------------

-spec direct_exchange_routing_v2_enable(Args) -> Ret when
      Args :: rabbit_feature_flags:enable_callback_args(),
      Ret :: rabbit_feature_flags:enable_callback_ret().
direct_exchange_routing_v2_enable(#{feature_name := FeatureName}) ->
    TableName = rabbit_index_route,
    ok = rabbit_table:wait([rabbit_route, rabbit_exchange], _Retry = true),
    try
        case rabbit_db_binding:create_index_route_table() of
            ok ->
                ok;
            {error, Err} = Error ->
                ?LOG_ERROR(
                  "Feature flags: `~ts`: failed to add copy of table ~ts to "
                  "node ~tp: ~tp",
                   [FeatureName, TableName, node(), Err],
                  #{domain => ?RMQLOG_DOMAIN_FEAT_FLAGS}),
                Error
        end
    catch throw:{error, Reason} ->
              ?LOG_ERROR(
                "Feature flags: `~ts`: enable callback failure: ~tp",
                [FeatureName, Reason],
                #{domain => ?RMQLOG_DOMAIN_FEAT_FLAGS}),
              {error, Reason}
    end.

%% -------------------------------------------------------------------
%% Listener records moved from Mnesia to ETS.
%% -------------------------------------------------------------------

listener_records_in_ets_enable(#{feature_name := FeatureName}) ->
    try
        rabbit_mnesia:execute_mnesia_transaction(
          fun () ->
                  _ = mnesia:lock({table, rabbit_listener}, read),
                  Listeners = mnesia:select(
                                rabbit_listener, [{'$1',[],['$1']}]),
                  lists:foreach(
                    fun(Listener) ->
                            ets:insert(rabbit_listener_ets, Listener)
                    end, Listeners)
          end)
    catch
        throw:{error, {no_exists, rabbit_listener}} ->
            ok;
        throw:{error, Reason} ->
            ?LOG_ERROR(
              "Feature flags: `~ts`: failed to migrate Mnesia table: ~tp",
              [FeatureName, Reason],
              #{domain => ?RMQLOG_DOMAIN_FEAT_FLAGS}),
            {error, Reason}
    end.

listener_records_in_ets_post_enable(#{feature_name := FeatureName}) ->
    try
        case mnesia:delete_table(rabbit_listener) of
            {atomic, ok} ->
                ok;
            {aborted, {no_exists, _}} ->
                ok;
            {aborted, Err} ->
                ?LOG_ERROR(
                  "Feature flags: `~ts`: failed to delete Mnesia table: ~tp",
                  [FeatureName, Err],
                  #{domain => ?RMQLOG_DOMAIN_FEAT_FLAGS}),
                ok
        end
    catch
        throw:{error, Reason} ->
            ?LOG_ERROR(
              "Feature flags: `~ts`: failed to delete Mnesia table: ~tp",
              [FeatureName, Reason],
              #{domain => ?RMQLOG_DOMAIN_FEAT_FLAGS}),
            ok
    end.

tracking_records_in_ets_enable(#{feature_name := FeatureName}) ->
    try
        rabbit_connection_tracking:migrate_tracking_records(),
        rabbit_channel_tracking:migrate_tracking_records()
    catch
        throw:{error, {no_exists, _}} ->
            ok;
        throw:{error, Reason} ->
            ?LOG_ERROR(
               "Enabling feature flag ~ts failed: ~tp",
               [FeatureName, Reason],
               #{domain => ?RMQLOG_DOMAIN_FEAT_FLAGS}),
            {error, Reason}
    end.

tracking_records_in_ets_post_enable(#{feature_name := FeatureName}) ->
    try
        [delete_table(FeatureName, Tab) ||
            Tab <- rabbit_connection_tracking:get_all_tracked_connection_table_names_for_node(node())],
        [delete_table(FeatureName, Tab) ||
            Tab <- rabbit_channel_tracking:get_all_tracked_channel_table_names_for_node(node())]
    catch
        throw:{error, Reason} ->
            ?LOG_ERROR(
               "Enabling feature flag ~ts failed: ~tp",
               [FeatureName, Reason],
               #{domain => ?RMQLOG_DOMAIN_FEAT_FLAGS}),
            %% adheres to the callback interface
            ok
    end.

delete_table(FeatureName, Tab) ->
    case mnesia:delete_table(Tab) of
        {atomic, ok} ->
            ok;
        {aborted, {no_exists, _}} ->
            ok;
        {aborted, Err} ->
            ?LOG_ERROR(
               "Enabling feature flag ~ts failed to delete mnesia table ~tp: ~tp",
               [FeatureName, Tab, Err],
               #{domain => ?RMQLOG_DOMAIN_FEAT_FLAGS}),
            %% adheres to the callback interface
            ok
    end.
