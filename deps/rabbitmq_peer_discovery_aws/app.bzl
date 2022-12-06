load("@rules_erlang//:erlang_bytecode2.bzl", "erlang_bytecode")
load("@rules_erlang//:filegroup.bzl", "filegroup")

def all_beam_files(name = "all_beam_files"):
    filegroup(
        name = "beam_files",
        srcs = ["ebin/rabbit_peer_discovery_aws.beam", "ebin/rabbitmq_peer_discovery_aws.beam"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_peer_discovery_aws_beam",
        srcs = ["src/rabbit_peer_discovery_aws.erl"],
        outs = ["ebin/rabbit_peer_discovery_aws.beam"],
        app_name = "rabbitmq_peer_discovery_aws",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_peer_discovery_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbitmq_peer_discovery_aws_beam",
        srcs = ["src/rabbitmq_peer_discovery_aws.erl"],
        outs = ["ebin/rabbitmq_peer_discovery_aws.beam"],
        app_name = "rabbitmq_peer_discovery_aws",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )

def all_test_beam_files(name = "all_test_beam_files"):
    filegroup(
        name = "test_beam_files",
        testonly = True,
        srcs = ["test/rabbit_peer_discovery_aws.beam", "test/rabbitmq_peer_discovery_aws.beam"],
    )
    erlang_bytecode(
        name = "test_rabbit_peer_discovery_aws_beam",
        testonly = True,
        srcs = ["src/rabbit_peer_discovery_aws.erl"],
        outs = ["test/rabbit_peer_discovery_aws.beam"],
        app_name = "rabbitmq_peer_discovery_aws",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_peer_discovery_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbitmq_peer_discovery_aws_beam",
        testonly = True,
        srcs = ["src/rabbitmq_peer_discovery_aws.erl"],
        outs = ["test/rabbitmq_peer_discovery_aws.beam"],
        app_name = "rabbitmq_peer_discovery_aws",
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
        srcs = ["LICENSE", "LICENSE-MPL-RabbitMQ"],
    )
    filegroup(
        name = "priv",
        srcs = ["priv/schema/rabbitmq_peer_discovery_aws.schema"],
    )
    filegroup(
        name = "public_hdrs",
        srcs = [],
    )

    filegroup(
        name = "srcs",
        srcs = ["src/rabbit_peer_discovery_aws.erl", "src/rabbitmq_peer_discovery_aws.erl"],
    )
    filegroup(
        name = "private_hdrs",
        srcs = [],
    )

def test_suite_beam_files(name = "test_suite_beam_files"):
    erlang_bytecode(
        name = "config_schema_SUITE_beam_files",
        testonly = True,
        srcs = ["test/config_schema_SUITE.erl"],
        outs = ["test/config_schema_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "integration_SUITE_beam_files",
        testonly = True,
        srcs = ["test/integration_SUITE.erl"],
        outs = ["test/integration_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "test_aws_ecs_util_beam",
        testonly = True,
        srcs = ["test/aws_ecs_util.erl"],
        outs = ["test/aws_ecs_util.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbitmq_ct_helpers:erlang_app"],
    )
    erlang_bytecode(
        name = "unit_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_SUITE.erl"],
        outs = ["test/unit_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
    )