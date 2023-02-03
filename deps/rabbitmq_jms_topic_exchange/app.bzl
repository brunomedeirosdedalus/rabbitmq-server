load("@rules_erlang//:erlang_bytecode2.bzl", "erlang_bytecode")
load("@rules_erlang//:filegroup.bzl", "filegroup")

def all_beam_files(name = "all_beam_files"):
    filegroup(
        name = "beam_files",
        srcs = ["ebin/rabbit_db_jms_exchange.beam", "ebin/rabbit_jms_topic_exchange.beam", "ebin/sjx_evaluator.beam"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_jms_topic_exchange_beam",
        srcs = ["src/rabbit_jms_topic_exchange.erl"],
        outs = ["ebin/rabbit_jms_topic_exchange.beam"],
        hdrs = ["include/rabbit_jms_topic_exchange.hrl"],
        app_name = "rabbitmq_jms_topic_exchange",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_sjx_evaluator_beam",
        srcs = ["src/sjx_evaluator.erl"],
        outs = ["ebin/sjx_evaluator.beam"],
        app_name = "rabbitmq_jms_topic_exchange",
        erlc_opts = "//:erlc_opts",
    )
    erlang_bytecode(
        name = "ebin_rabbit_db_jms_exchange_beam",
        srcs = ["src/rabbit_db_jms_exchange.erl"],
        outs = ["ebin/rabbit_db_jms_exchange.beam"],
        hdrs = ["include/rabbit_jms_topic_exchange.hrl"],
        app_name = "rabbitmq_jms_topic_exchange",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )

def all_test_beam_files(name = "all_test_beam_files"):
    filegroup(
        name = "test_beam_files",
        testonly = True,
        srcs = ["test/rabbit_db_jms_exchange.beam", "test/rabbit_jms_topic_exchange.beam", "test/sjx_evaluator.beam"],
    )
    erlang_bytecode(
        name = "test_rabbit_jms_topic_exchange_beam",
        testonly = True,
        srcs = ["src/rabbit_jms_topic_exchange.erl"],
        outs = ["test/rabbit_jms_topic_exchange.beam"],
        hdrs = ["include/rabbit_jms_topic_exchange.hrl"],
        app_name = "rabbitmq_jms_topic_exchange",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit:erlang_app", "//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_sjx_evaluator_beam",
        testonly = True,
        srcs = ["src/sjx_evaluator.erl"],
        outs = ["test/sjx_evaluator.beam"],
        app_name = "rabbitmq_jms_topic_exchange",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_rabbit_db_jms_exchange_beam",
        testonly = True,
        srcs = ["src/rabbit_db_jms_exchange.erl"],
        outs = ["test/rabbit_db_jms_exchange.beam"],
        hdrs = ["include/rabbit_jms_topic_exchange.hrl"],
        app_name = "rabbitmq_jms_topic_exchange",
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
        srcs = [],
    )

    filegroup(
        name = "srcs",
        srcs = ["src/rabbit_db_jms_exchange.erl", "src/rabbit_jms_topic_exchange.erl", "src/sjx_evaluator.erl"],
    )
    filegroup(
        name = "public_hdrs",
        srcs = ["include/rabbit_jms_topic_exchange.hrl"],
    )
    filegroup(
        name = "private_hdrs",
        srcs = [],
    )

def test_suite_beam_files(name = "test_suite_beam_files"):
    erlang_bytecode(
        name = "rjms_topic_selector_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rjms_topic_selector_SUITE.erl"],
        outs = ["test/rjms_topic_selector_SUITE.beam"],
        hdrs = ["include/rabbit_jms_topic_exchange.hrl"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "rjms_topic_selector_unit_SUITE_beam_files",
        testonly = True,
        srcs = ["test/rjms_topic_selector_unit_SUITE.erl"],
        outs = ["test/rjms_topic_selector_unit_SUITE.beam"],
        hdrs = ["include/rabbit_jms_topic_exchange.hrl"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "sjx_evaluation_SUITE_beam_files",
        testonly = True,
        srcs = ["test/sjx_evaluation_SUITE.erl"],
        outs = ["test/sjx_evaluation_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
    )
