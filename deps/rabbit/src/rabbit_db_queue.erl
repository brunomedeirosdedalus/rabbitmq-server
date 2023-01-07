%% This Source Code Form is subject to the terms of the Mozilla Public
%% License, v. 2.0. If a copy of the MPL was not distributed with this
%% file, You can obtain one at https://mozilla.org/MPL/2.0/.
%%
%% Copyright (c) 2022-2023 VMware, Inc. or its affiliates.  All rights reserved.
%%

-module(rabbit_db_queue).

-include_lib("khepri/include/khepri.hrl").
-include_lib("rabbit_common/include/rabbit.hrl").
-include("amqqueue.hrl").

-export([
         get/1,
         get_all/0,
         get_all/1,
         get_all_by_type/1,
         list/0,
         count/0,
         count/1,
         create_or_get/2,
         insert/2,
         insert/1,
         delete/2,
         update/2,
         update_decorators/2,
         exists/1
        ]).

%% Once mnesia is removed, all transient entities will be deleted. These can be replaced
%% with the plain get_all* functions
-export([
         get_all_durable/0,
         get_all_durable/1,
         get_all_durable_by_type/1,
         get_durable/1
        ]).

%% Used on_node_down. Can be deleted once transient entities/mnesia are removed.
-export([delete_transient/1]).
-export([on_node_up/2,
         on_node_down/2]).

%% Storing it on Khepri is not needed, this function is just used in
%% rabbit_quorum_queue to ensure the queue is present in the rabbit_queue
%% table and not just in rabbit_durable_queue. Can be deleted with mnesia removal
-export([insert_dirty/1]).

%% Another one that can be deleted when mnesia is removed
-export([not_found_or_absent_queue_dirty/1]).

%% Only used by rabbit_amqqueue:forget_node_for_queue, which is only called
%% by `rabbit_mnesia:remove_node_if_mnesia_running`. Thus, once mnesia and/or
%% HA queues are removed it can be deleted.
-export([internal_delete/3]).

%% Used by other rabbit_db_* modules
-export([
         update_in_mnesia_tx/2,
         update_in_khepri_tx/2,
         not_found_or_absent_queue_in_mnesia/1,
         get_in_khepri_tx/1
        ]).

-export([mnesia_write_to_khepri/2,
         mnesia_delete_to_khepri/2,
         clear_data_in_khepri/1]).

%% -------------------------------------------------------------------
%% get_all().
%% -------------------------------------------------------------------

-spec get_all() -> [Queue] when
      Queue :: amqqueue:amqqueue().

%% @doc Returns all queue records.
%%
%% @returns the list of all queue records.
%%
%% @private

get_all() ->
    rabbit_db:run(
      #{mnesia => fun() -> get_all_in_mnesia() end,
        khepri => fun() -> get_all_in_khepri() end
       }).

get_all_in_mnesia() ->
    list_with_possible_retry_in_mnesia(
      fun() ->
              rabbit_db:list_in_mnesia(rabbit_queue, amqqueue:pattern_match_all())
      end).

get_all_in_khepri() ->
    list_with_possible_retry_in_khepri(
      fun() ->
              rabbit_db:list_in_khepri(khepri_queues_path() ++ [rabbit_db:if_has_data_wildcard()])
      end).

-spec get_all(VHostName) -> [Queue] when
      VHostName :: vhost:name(),
      Queue :: amqqueue:amqqueue().

%% @doc Gets all queues belonging to the given virtual host
%%
%% @returns a list of queue records.
%%
%% @private

get_all(VHost) ->
    rabbit_db:run(
      #{mnesia => fun() -> get_all_in_mnesia(VHost) end,
        khepri => fun() -> get_all_in_khepri(VHost) end
       }).

%% -------------------------------------------------------------------
%% get_all_durable().
%% -------------------------------------------------------------------

-spec get_all_durable() -> [Queue] when
      Queue :: amqqueue:amqqueue().

%% @doc Returns all durable queue records.
%%
%% @returns a list of queue records.
%%
%% @private

get_all_durable() ->
    rabbit_db:run(
      #{mnesia => fun() -> get_all_durable_in_mnesia() end,
        khepri => fun() -> get_all_durable_in_khepri() end
       }).

get_all_durable_in_mnesia() ->
    list_with_possible_retry_in_mnesia(
      fun() ->
              rabbit_db:list_in_mnesia(rabbit_durable_queue, amqqueue:pattern_match_all())
      end).

get_all_durable_in_khepri() ->
    list_with_possible_retry_in_khepri(
      fun() ->
              rabbit_db:list_in_khepri(khepri_queues_path() ++ [rabbit_db:if_has_data_wildcard()])
      end).

-spec get_all_durable(VHostName) -> [Queue] when
      VHostName :: vhost:name(),
      Queue :: amqqueue:amqqueue().

%% @doc Gets all durable queues belonging to the given virtual host
%%
%% @returns a list of queue records.
%%
%% @private

get_all_durable(VHost) ->
    rabbit_db:run(
      #{mnesia => fun() -> get_all_durable_in_mnesia(VHost) end,
        khepri => fun() -> get_all_durable_in_khepri(VHost) end
       }).

get_all_durable_in_mnesia(VHost) ->
    list_with_possible_retry_in_mnesia(
      fun() ->
              Pattern = amqqueue:pattern_match_on_name(rabbit_misc:r(VHost, queue)),
              rabbit_db:list_in_mnesia(rabbit_durable_queue, Pattern)
      end).

get_all_durable_in_khepri(VHost) ->
    list_with_possible_retry_in_khepri(
      fun() ->
              rabbit_db:list_in_khepri(khepri_queues_path() ++ [VHost, rabbit_db:if_has_data_wildcard()])
      end).

get_all_durable_by_type(Type) ->
    rabbit_db:run(
      #{mnesia => fun() -> get_all_durable_by_type_in_mnesia(Type) end,
        khepri => fun() -> get_all_durable_by_type_in_khepri(Type) end
       }).

get_all_durable_by_type_in_mnesia(Type) ->
    Pattern = amqqueue:pattern_match_on_type(Type),
    rabbit_db:list_in_mnesia(rabbit_durable_queue, Pattern).

get_all_durable_by_type_in_khepri(Type) ->
    Pattern = amqqueue:pattern_match_on_type(Type),
    rabbit_db:list_in_khepri(khepri_queues_path() ++ [rabbit_db:if_has_data([?KHEPRI_WILDCARD_STAR_STAR, #if_data_matches{pattern = Pattern}])]).

list() ->
    rabbit_db:run(
      #{mnesia => fun() -> list_in_mnesia() end,
        khepri => fun() -> list_in_khepri() end
       }).

list_in_mnesia() ->
    mnesia:dirty_all_keys(rabbit_queue).

list_in_khepri() ->
    case rabbit_khepri:match(khepri_queues_path() ++ [rabbit_db:if_has_data_wildcard()]) of
        {ok, Map} ->
            maps:fold(fun(_K, Q, Acc) -> [amqqueue:get_name(Q) | Acc] end, [], Map);
        _ ->
            []
    end.

count() ->
    rabbit_db:run(
      #{mnesia => fun() -> count_in_mnesia() end,
        khepri => fun() -> count_in_khepri() end
       }).

count_in_mnesia() ->
    mnesia:table_info(rabbit_queue, size).

count_in_khepri() ->
    rabbit_khepri:count_children(khepri_queues_path() ++ [?KHEPRI_WILDCARD_STAR]).

count(VHost) ->
    try
        list_for_count(VHost)
    catch _:Err ->
            rabbit_log:error("Failed to fetch number of queues in vhost ~p:~n~p",
                             [VHost, Err]),
            0
    end.

delete(QueueName, Reason) ->
    rabbit_db:run(
      #{mnesia => fun() -> delete_in_mnesia(QueueName, Reason) end,
        khepri => fun() -> delete_in_khepri(QueueName) end
       }).

internal_delete(QueueName, OnlyDurable, Reason) ->
    %% Only used by rabbit_amqqueue:forget_node_for_queue, which is only called
    %% by `rabbit_mnesia:remove_node_if_mnesia_running`. Thus, once mnesia and/or
    %% HA queues are removed it can be removed.
    rabbit_db:run(
      #{mnesia => fun() -> internal_delete_in_mnesia(QueueName, OnlyDurable, Reason) end,
        khepri => fun() -> ok end
       }).

get(Names) when is_list(Names) ->
    rabbit_db:run(
      #{mnesia => fun() -> get_many_in_mnesia(rabbit_queue, Names) end,
        khepri => fun() -> get_many_in_khepri(Names) end
       });
get(Name) ->
    rabbit_db:run(
      #{mnesia => fun() -> get_in_mnesia(Name) end,
        khepri => fun() -> get_in_khepri(Name) end
       }).

get_in_mnesia(Name) ->
    rabbit_misc:dirty_read({rabbit_queue, Name}).

get_durable(Names) when is_list(Names) ->
    rabbit_db:run(
      #{mnesia => fun() -> get_many_in_mnesia(rabbit_durable_queue, Names) end,
        khepri => fun() -> get_many_in_khepri(Names) end
       });
get_durable(Name) ->
    rabbit_db:run(
      #{mnesia => fun() -> get_durable_in_mnesia(Name) end,
        khepri => fun() -> get_in_khepri(Name) end
       }).

get_durable_in_mnesia(Name) ->
    rabbit_misc:dirty_read({rabbit_durable_queue, Name}).

delete_transient(Queues) ->
    rabbit_db:run(
      #{mnesia => fun() -> delete_transient_in_mnesia(Queues) end,
        khepri => fun() -> ok end
       }).

delete_transient_in_mnesia(Queues) ->
    rabbit_misc:execute_mnesia_transaction(
      fun () ->
              [{QName, delete_transient_in_mnesia_tx(QName)}
               || QName <- Queues]
      end).

on_node_up(Node, Fun) ->
    rabbit_db:run(
      #{mnesia => fun() -> on_node_up_in_mnesia(Node, Fun) end,
        khepri => fun() -> ok end
       }).

on_node_up_in_mnesia(Node, Fun) ->
    rabbit_misc:execute_mnesia_transaction(
      fun () ->
              Qs = mnesia:match_object(rabbit_queue,
                                       amqqueue:pattern_match_all(), write),
              [Fun(Node, Q) || Q <- Qs],
              ok
      end).

on_node_down(Node, Fun) ->
    rabbit_db:run(
      #{mnesia => fun() -> on_node_down_in_mnesia(Node, Fun) end,
        khepri => fun() -> ok end
       }).

on_node_down_in_mnesia(Node, Fun) ->
    Partitions = Fun(Node, get_all()),
    lists:unzip(lists:flatten(
                  [case delete_transient(Queues) of
                       {error, noproc} -> [];
                       {error, {timeout, _}} -> [];
                       Value -> Value
                   end || Queues <- Partitions]
                 )).

update(QName, Fun) ->
    rabbit_db:run(
      #{mnesia => fun() -> update_in_mnesia(QName, Fun) end,
        khepri => fun() -> update_in_khepri(QName, Fun) end
       }).

update_in_mnesia(QName, Fun) ->
    rabbit_misc:execute_mnesia_transaction(
      fun() ->
              update_in_mnesia_tx(QName, Fun)
      end).

update_in_khepri(#resource{virtual_host = VHost, name = Name} = QName, Fun) ->
    Path = khepri_queue_path(QName),
    Ret1 = rabbit_khepri:adv_get(Path),
    case Ret1 of
        {ok, #{data := Q, payload_version := Vsn}} ->
            Conditions = #if_all{conditions = [Name, #if_payload_version{version = Vsn}]},
            Q1 = Fun(Q),
            UpdatePath = khepri_queues_path() ++ [VHost, Conditions],
            Ret2 = rabbit_khepri:put(UpdatePath, Q1),
            case Ret2 of
                ok -> Q1;
                {error, {khepri, mismatching_node, _}} ->
                    update_in_khepri(QName, Fun);
                Err -> Err
            end;
        _  ->
            not_found
    end.

update_decorators(Name, Decorators) ->
    rabbit_db:run(
      #{khepri => fun() -> update_decorators_in_mnesia(Name, Decorators) end,
        mnesia => fun() -> update_decorators_in_khepri(Name, Decorators) end
       }).

not_found_or_absent_queue_dirty(Name) ->
    rabbit_db:run(
      #{mnesia => fun() -> not_found_or_absent_queue_dirty_in_mnesia(Name) end,
        %% There are no transient queues in Khepri. Any queue missing from the table is gone
        khepri => fun() -> not_found end
       }).

exists(Name) ->
    rabbit_db:run(
      #{mnesia => fun() -> exists_in_mnesia(Name) end,
        khepri => fun() -> exists_in_khepri(Name) end
       }).

exists_in_mnesia(Name) ->
    ets:member(rabbit_queue, Name).

exists_in_khepri(Name) ->
    ets:member(rabbit_khepri_queue, Name).

get_all_by_type(Type) ->
    Pattern = amqqueue:pattern_match_on_type(Type),
    rabbit_db:run(
      #{mnesia => fun() -> get_all_by_pattern_in_mnesia(Pattern) end,
        khepri => fun() -> get_all_by_pattern_in_khepri(Pattern) end
       }).

get_all_by_pattern_in_mnesia(Pattern) ->
    rabbit_db:list_in_mnesia(rabbit_queue, Pattern).

get_all_by_pattern_in_khepri(Pattern) ->
    rabbit_db:list_in_khepri(khepri_queues_path() ++ [rabbit_db:if_has_data([?KHEPRI_WILDCARD_STAR_STAR, #if_data_matches{pattern = Pattern}])]).

create_or_get(DurableQ, Q) ->
    rabbit_db:run(
      #{mnesia => fun() -> create_or_get_in_mnesia(DurableQ, Q) end,
        khepri => fun() -> create_or_get_in_khepri(Q) end
       }).

create_or_get_in_mnesia(DurableQ, Q) ->
    QueueName = amqqueue:get_name(Q),
    rabbit_misc:execute_mnesia_transaction(
      fun () ->
              case mnesia:wread({rabbit_queue, QueueName}) of
                  [] ->
                      case not_found_or_absent_queue_in_mnesia(QueueName) of
                          not_found           ->
                              insert_in_mnesia_tx(DurableQ, Q),
                              {created, Q};
                          {absent, _Q, _} = R ->
                              R
                      end;
                  [ExistingQ] ->
                      {existing, ExistingQ}
              end
      end).

create_or_get_in_khepri(Q) ->
    QueueName = amqqueue:get_name(Q),
    Path = khepri_queue_path(QueueName),
    case rabbit_khepri:adv_create(Path, Q) of
        {error, {khepri, mismatching_node, #{node_props := #{data := ExistingQ}}}} ->
            {existing, ExistingQ};
        _ ->
            {created, Q}
    end.

insert(DurableQ, Q) ->
    rabbit_db:run(
      #{mnesia => fun() -> insert_in_mnesia(DurableQ, Q) end,
        khepri => fun() -> insert_in_khepri(Q) end
       }).

insert_in_mnesia(DurableQ, Q) ->
    rabbit_misc:execute_mnesia_transaction(
      fun () ->
              insert_in_mnesia_tx(DurableQ, Q)
      end).

insert_in_khepri(Q) ->
    Path = khepri_queue_path(amqqueue:get_name(Q)),
    rabbit_khepri:put(Path, Q).

insert(Qs) ->
    rabbit_db:run(
      #{mnesia => fun() -> insert_many_in_mnesia(Qs) end,
        khepri => fun() -> insert_many_in_khepri(Qs) end
       }).

insert_many_in_mnesia(Qs) ->
    rabbit_misc:execute_mnesia_transaction(
      fun() ->
              [ok = mnesia:write(rabbit_durable_queue, Q, write) || Q <- Qs]
      end).

insert_many_in_khepri(Qs) ->
    rabbit_khepri:transaction(
      fun() ->
              [begin
                   Path = khepri_queue_path(amqqueue:get_name(Q)),
                   case khepri_tx:put(Path, Q) of
                       ok      -> ok;
                       Error   -> khepri_tx:abort(Error)
                   end
               end || Q <- Qs]
      end).

insert_dirty(Q) ->
    %% Storing it on Khepri is not needed, this function is just used in
    %% rabbit_quorum_queue to ensure the queue is present in the rabbit_queue
    %% table and not just in rabbit_durable_queue
    rabbit_db:run(
      #{mnesia => fun() -> insert_dirty_in_mnesia(Q) end,
        khepri => fun() -> ok end
       }).

insert_dirty_in_mnesia(Q) ->
    ok = mnesia:dirty_write(rabbit_queue, rabbit_queue_decorator:set(Q)).

%% TODO this should be internal, it's here because of mirrored queues
get_in_khepri_tx(Name) ->
    case khepri_tx:get(khepri_queue_path(Name)) of
        {ok, X} -> [X];
        _ -> []
    end.

update_in_mnesia_tx(Name, Fun) ->
    case mnesia:wread({rabbit_queue, Name}) of
        [Q] ->
            Durable = amqqueue:is_durable(Q),
            Q1 = Fun(Q),
            ok = mnesia:write(rabbit_queue, Q1, write),
            case Durable of
                true -> ok = mnesia:write(rabbit_durable_queue, Q1, write);
                _    -> ok
            end,
            Q1;
        [] ->
            not_found
    end.

update_in_khepri_tx(Name, Fun) ->
    Path = khepri_queue_path(Name),
    case khepri_tx:get(Path) of
        {ok, Q} ->
            Q1 = Fun(Q),
            ok = khepri_tx:put(Path, Q1),
            Q1;
        _  ->
            not_found
    end.

not_found_or_absent_queue_in_mnesia(Name) ->
    %% NB: we assume that the caller has already performed a lookup on
    %% rabbit_queue and not found anything
    case mnesia:read({rabbit_durable_queue, Name}) of
        []  -> not_found;
        [Q] -> {absent, Q, nodedown} %% Q exists on stopped node
    end.

%% Feature flags
%% --------------------------------------------------------------

mnesia_write_to_khepri(rabbit_queue, Qs) ->
    rabbit_khepri:transaction(
      fun() ->
              [begin
                   Path = khepri_queue_path(amqqueue:get_name(Q)),
                   case khepri_tx:create(Path, Q) of
                       ok -> ok;
                       {error, {khepri, mismatching_node, _}} -> ok;
                       Error -> throw(Error)
                   end
               end || Q <- Qs]
      end, rw);
mnesia_write_to_khepri(rabbit_durable_queue, _Qs) ->
    %% All durable queues are on the `rabbit_queue` table too
    ok.

mnesia_delete_to_khepri(rabbit_queue, Q) when ?is_amqqueue(Q) ->
    khepri_delete(khepri_queue_path(amqqueue:get_name(Q)));
mnesia_delete_to_khepri(rabbit_queue, Name) when is_record(Name, resource) ->
    khepri_delete(khepri_queue_path(Name));
mnesia_delete_to_khepri(rabbit_durable_queue, Q) when ?is_amqqueue(Q) ->
    khepri_delete(khepri_queue_path(amqqueue:get_name(Q)));
mnesia_delete_to_khepri(rabbit_durable_queue, Name) when is_record(Name, resource) ->
    khepri_delete(khepri_queue_path(Name)).

clear_data_in_khepri(rabbit_queue) ->
    khepri_delete(khepri_queues_path());
clear_data_in_khepri(rabbit_durable_queue) ->
    khepri_delete(khepri_queues_path()).

%% Internal
%% --------------------------------------------------------------
khepri_queues_path() ->
    [?MODULE, queues].

khepri_queue_path(#resource{virtual_host = VHost, name = Name}) ->
    [?MODULE, queues, VHost, Name].

get_in_khepri(Name) ->
    case ets:lookup(rabbit_khepri_queue, Name) of
        [X] -> {ok, X};
        []  -> {error, not_found}
    end.

get_many_in_mnesia(Table, [Name]) ->
    ets:lookup(Table, Name);
get_many_in_mnesia(Table, Names) when is_list(Names) ->
    %% Normally we'd call mnesia:dirty_read/1 here, but that is quite
    %% expensive for reasons explained in rabbit_misc:dirty_read/1.
    lists:append([ets:lookup(Table, Name) || Name <- Names]).

get_many_in_khepri(Names) when is_list(Names) ->
    lists:append([ets:lookup(rabbit_khepri_queue, Name) || Name <- Names]).

delete_transient_in_mnesia_tx(QName) ->
    ok = mnesia:delete({rabbit_queue, QName}),
    rabbit_db_binding:delete_transient_for_destination_in_mnesia(QName).

get_all_in_mnesia(VHost) ->
    list_with_possible_retry_in_mnesia(
      fun() ->
              Pattern = amqqueue:pattern_match_on_name(rabbit_misc:r(VHost, queue)),
              rabbit_db:list_in_mnesia(rabbit_queue, Pattern)
      end).

get_all_in_khepri(VHost) ->
    list_with_possible_retry_in_khepri(
      fun() ->
              rabbit_db:list_in_khepri(khepri_queues_path() ++ [VHost, rabbit_db:if_has_data_wildcard()])
      end).

not_found_or_absent_queue_dirty_in_mnesia(Name) ->
    %% We should read from both tables inside a tx, to get a
    %% consistent view. But the chances of an inconsistency are small,
    %% and only affect the error kind.
    case rabbit_misc:dirty_read({rabbit_durable_queue, Name}) of
        {error, not_found} -> not_found;
        {ok, Q}            -> {absent, Q, nodedown}
    end.

list_with_possible_retry_in_mnesia(Fun) ->
    %% amqqueue migration:
    %% The `rabbit_queue` or `rabbit_durable_queue` tables
    %% might be migrated between the time we query the pattern
    %% (with the `amqqueue` module) and the time we call
    %% `mnesia:dirty_match_object()`. This would lead to an empty list
    %% (no object matching the now incorrect pattern), not a Mnesia
    %% error.
    %%
    %% So if the result is an empty list and the version of the
    %% `amqqueue` record changed in between, we retry the operation.
    %%
    %% However, we don't do this if inside a Mnesia transaction: we
    %% could end up with a live lock between this started transaction
    %% and the Mnesia table migration which is blocked (but the
    %% rabbit_feature_flags lock is held).
    AmqqueueRecordVersion = amqqueue:record_version_to_use(),
    case Fun() of
        [] ->
            case mnesia:is_transaction() of
                true ->
                    [];
                false ->
                    case amqqueue:record_version_to_use() of
                        AmqqueueRecordVersion -> [];
                        _                     -> Fun()
                    end
            end;
        Ret ->
            Ret
    end.

list_with_possible_retry_in_khepri(Fun) ->
    %% See equivalent `list_with_possible_retry_in_mnesia` first.
    %% Not sure how much of this is possible in Khepri, as there is no dirty read,
    %% but the amqqueue record migration is still happening.
    %% Let's retry just in case
    AmqqueueRecordVersion = amqqueue:record_version_to_use(),
    case Fun() of
        [] ->
            case khepri_tx:is_transaction() of
                true ->
                    [];
                false ->
                    case amqqueue:record_version_to_use() of
                        AmqqueueRecordVersion -> [];
                        _                     -> Fun()
                    end
            end;
        Ret ->
            Ret
    end.

delete_in_mnesia(QueueName, Reason) ->
    rabbit_misc:execute_mnesia_transaction(
      fun () ->
              case {mnesia:wread({rabbit_queue, QueueName}),
                    mnesia:wread({rabbit_durable_queue, QueueName})} of
                  {[], []} ->
                      ok;
                  _ ->
                      internal_delete_in_mnesia(QueueName, false, Reason)
              end
      end).

delete_in_khepri(Name) ->
    rabbit_khepri:transaction(
      fun () ->
              Path = khepri_queue_path(Name),
              case khepri_tx_adv:delete(Path) of
                  {ok, #{data := _}} ->
                      %% we want to execute some things, as decided by rabbit_exchange,
                      %% after the transaction.
                      rabbit_db_binding:delete_for_destination_in_khepri(Name, false);
                  {ok, _} ->
                      ok
              end
      end, rw).

internal_delete_in_mnesia(QueueName, OnlyDurable, Reason) ->
    ok = mnesia:delete({rabbit_queue, QueueName}),
    case Reason of
        auto_delete ->
            case mnesia:wread({rabbit_durable_queue, QueueName}) of
                []  -> ok;
                [_] -> ok = mnesia:delete({rabbit_durable_queue, QueueName})
            end;
        _ ->
            mnesia:delete({rabbit_durable_queue, QueueName})
    end,
    %% we want to execute some things, as decided by rabbit_exchange,
    %% after the transaction.
    rabbit_db_binding:delete_for_destination_in_mnesia(QueueName, OnlyDurable).

list_for_count(VHost) ->
    rabbit_db:run(
      #{mnesia => fun() -> list_for_count_in_mnesia(VHost) end,
        khepri => fun() -> list_for_count_in_khepri(VHost) end
       }).

list_for_count_in_mnesia(VHost) ->
    %% this is certainly suboptimal but there is no way to count
    %% things using a secondary index in Mnesia. Our counter-table-per-node
    %% won't work here because with master migration of mirrored queues
    %% the "ownership" of queues by nodes becomes a non-trivial problem
    %% that requires a proper consensus algorithm.
    list_with_possible_retry_in_mnesia(
      fun() ->
              length(mnesia:dirty_index_read(rabbit_queue,
                                             VHost,
                                             amqqueue:field_vhost()))
      end).

list_for_count_in_khepri(VHost) ->
    list_with_possible_retry_in_khepri(
      fun() ->
              rabbit_khepri:count_children(khepri_queues_path() ++ [VHost])
      end).

update_decorators_in_mnesia(Name, Decorators) ->
    rabbit_misc:execute_mnesia_transaction(
      fun() ->
              case mnesia:wread({rabbit_queue, Name}) of
                  [Q] -> ok = mnesia:write(rabbit_queue, amqqueue:set_decorators(Q, Decorators),
                                           write);
                  []  -> ok
              end
      end).

update_decorators_in_khepri(#resource{virtual_host = VHost, name = Name} = QName,
                            Decorators) ->
    %% Decorators are stored on an ETS table, so we need to query them before the transaction.
    %% Also, to verify which ones are active could lead to any kind of side-effects.
    %% Thus it needs to be done outside of the transaction.
    %% Decorators have just been calculated on `rabbit_queue_decorator:maybe_recover/1`, thus
    %% we can update them here directly.
    Path = khepri_queue_path(QName),
    Ret1 = rabbit_khepri:adv_get(Path),
    case Ret1 of
        {ok, #{data := Q0, payload_version := Vsn}} ->
            Q1 = amqqueue:reset_mirroring_and_decorators(Q0),
            Q2 = amqqueue:set_decorators(Q1, Decorators),
            Conditions = #if_all{conditions = [Name, #if_payload_version{version = Vsn}]},
            UpdatePath = khepri_queues_path() ++ [VHost, Conditions],
            Ret2 = rabbit_khepri:put(UpdatePath, Q2),
            case Ret2 of
                ok -> ok;
                {error, {khepri, mismatching_node, _}} ->
                    update_decorators_in_khepri(QName, Decorators);
                {error, _} = Error -> Error
            end;
        _  ->
            ok
    end.

khepri_delete(Path) ->
    case rabbit_khepri:delete(Path) of
        ok -> ok;
        Error -> throw(Error)
    end.

insert_in_mnesia_tx(DurableQ, Q) ->
    case ?amqqueue_is_durable(Q) of
        true ->
            ok = mnesia:write(rabbit_durable_queue, DurableQ, write);
        false ->
            ok
    end,
    ok = mnesia:write(rabbit_queue, Q, write).
