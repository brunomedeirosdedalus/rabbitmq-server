load("@rules_erlang//:erlang_bytecode2.bzl", "erlang_bytecode")
load("@rules_erlang//:filegroup.bzl", "filegroup")

def all_beam_files(name = "all_beam_files"):
    filegroup(
        name = "beam_files",
        srcs = ["ebin/rabbit_sharding_exchange_decorator.beam", "ebin/rabbit_sharding_exchange_type_modulus_hash.beam", "ebin/rabbit_sharding_interceptor.beam", "ebin/rabbit_sharding_policy_validator.beam", "ebin/rabbit_sharding_shard.beam", "ebin/rabbit_sharding_util.beam"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_sharding_exchange_decorator_beam",
        srcs = ["src/rabbit_sharding_exchange_decorator.erl"],
        outs = ["ebin/rabbit_sharding_exchange_decorator.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_sharding_exchange_type_modulus_hash_beam",
        srcs = ["src/rabbit_sharding_exchange_type_modulus_hash.erl"],
        outs = ["ebin/rabbit_sharding_exchange_type_modulus_hash.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_sharding_interceptor_beam",
        srcs = ["src/rabbit_sharding_interceptor.erl"],
        outs = ["ebin/rabbit_sharding_interceptor.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_sharding_policy_validator_beam",
        srcs = ["src/rabbit_sharding_policy_validator.erl"],
        outs = ["ebin/rabbit_sharding_policy_validator.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_sharding_shard_beam",
        srcs = ["src/rabbit_sharding_shard.erl"],
        outs = ["ebin/rabbit_sharding_shard.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_sharding_util_beam",
        srcs = ["src/rabbit_sharding_util.erl"],
        outs = ["ebin/rabbit_sharding_util.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )

def all_test_beam_files(name = "all_test_beam_files"):
    filegroup(
        name = "test_beam_files",
        testonly = True,
        srcs = ["test/rabbit_sharding_exchange_decorator.beam", "test/rabbit_sharding_exchange_type_modulus_hash.beam", "test/rabbit_sharding_interceptor.beam", "test/rabbit_sharding_policy_validator.beam", "test/rabbit_sharding_shard.beam", "test/rabbit_sharding_util.beam"],
    )
    erlang_bytecode(
        name = "test_rabbit_sharding_exchange_decorator_beam",
        testonly = True,
        srcs = ["src/rabbit_sharding_exchange_decorator.erl"],
        outs = ["test/rabbit_sharding_exchange_decorator.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_sharding_exchange_type_modulus_hash_beam",
        testonly = True,
        srcs = ["src/rabbit_sharding_exchange_type_modulus_hash.erl"],
        outs = ["test/rabbit_sharding_exchange_type_modulus_hash.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_sharding_interceptor_beam",
        testonly = True,
        srcs = ["src/rabbit_sharding_interceptor.erl"],
        outs = ["test/rabbit_sharding_interceptor.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_sharding_policy_validator_beam",
        testonly = True,
        srcs = ["src/rabbit_sharding_policy_validator.erl"],
        outs = ["test/rabbit_sharding_policy_validator.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_sharding_shard_beam",
        testonly = True,
        srcs = ["src/rabbit_sharding_shard.erl"],
        outs = ["test/rabbit_sharding_shard.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_sharding_util_beam",
        testonly = True,
        srcs = ["src/rabbit_sharding_util.erl"],
        outs = ["test/rabbit_sharding_util.beam"],
        app_name = "rabbitmq_sharding",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )

def all_srcs(name = "all_srcs"):
    filegroup(
        name = "all_srcs",
        srcs = [":public_and_private_hdrs", ":srcs"],
    )
    filegroup(
        name = "public_and_private_hdrs",
        srcs = [":private_hdrs", ":public_hdrs"],
    )
    filegroup(
        name = "licenses",
        srcs = ["LICENSE", "LICENSE-MPL-RabbitMQ", "LICENSE-MPL2"],
    )
    filegroup(
        name = "priv",
        srcs = [],
    )

    filegroup(
        name = "srcs",
        srcs = ["src/rabbit_sharding_exchange_decorator.erl", "src/rabbit_sharding_exchange_type_modulus_hash.erl", "src/rabbit_sharding_interceptor.erl", "src/rabbit_sharding_policy_validator.erl", "src/rabbit_sharding_shard.erl", "src/rabbit_sharding_util.erl"],
    )
    filegroup(
        name = "private_hdrs",
        srcs = [],
    )
    filegroup(
        name = "public_hdrs",
        srcs = [],
    )

def test_suite_beam_files(name = "test_suite_beam_files"):
    erlang_bytecode(
        name = "rabbit_hash_exchange_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_hash_exchange_SUITE.erl"],
        outs = ["test/rabbit_hash_exchange_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "rabbit_sharding_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rabbit_sharding_SUITE.erl"],
        outs = ["test/rabbit_sharding_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbit:erlang_app"],
    )
