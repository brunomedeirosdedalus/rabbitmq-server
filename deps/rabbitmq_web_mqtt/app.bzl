load("@rules_erlang//:erlang_bytecode2.bzl", "erlang_bytecode")
load("@rules_erlang//:filegroup.bzl", "filegroup")

def all_beam_files(name = "all_beam_files"):
    filegroup(
        name = "beam_files",
        srcs = ["ebin/rabbit_web_mqtt_app.beam", "ebin/rabbit_web_mqtt_handler.beam", "ebin/rabbit_web_mqtt_stream_handler.beam"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_web_mqtt_app_beam",
        srcs = ["src/rabbit_web_mqtt_app.erl"],
        outs = ["ebin/rabbit_web_mqtt_app.beam"],
        app_name = "rabbitmq_web_mqtt",
        erlc_opts = "//:erlc_opts",
    )

    erlang_bytecode(
        name = "ebin_rabbit_web_mqtt_handler_beam",
        srcs = ["src/rabbit_web_mqtt_handler.erl"],
        outs = ["ebin/rabbit_web_mqtt_handler.beam"],
        app_name = "rabbitmq_web_mqtt",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbit_common:erlang_app", "//deps/rabbitmq_mqtt:erlang_app", "@cowboy//:erlang_app"],
    )

    erlang_bytecode(
        name = "ebin_rabbit_web_mqtt_stream_handler_beam",
        srcs = ["src/rabbit_web_mqtt_stream_handler.erl"],
        outs = ["ebin/rabbit_web_mqtt_stream_handler.beam"],
        app_name = "rabbitmq_web_mqtt",
        erlc_opts = "//:erlc_opts",
        deps = ["@cowboy//:erlang_app"],
    )

def all_test_beam_files(name = "all_test_beam_files"):
    filegroup(
        name = "test_beam_files",
        testonly = True,
        srcs = ["test/rabbit_web_mqtt_app.beam", "test/rabbit_web_mqtt_handler.beam", "test/rabbit_web_mqtt_stream_handler.beam"],
    )
    erlang_bytecode(
        name = "test_rabbit_web_mqtt_app_beam",
        testonly = True,
        srcs = ["src/rabbit_web_mqtt_app.erl"],
        outs = ["test/rabbit_web_mqtt_app.beam"],
        app_name = "rabbitmq_web_mqtt",
        erlc_opts = "//:test_erlc_opts",
    )

    erlang_bytecode(
        name = "test_rabbit_web_mqtt_handler_beam",
        testonly = True,
        srcs = ["src/rabbit_web_mqtt_handler.erl"],
        outs = ["test/rabbit_web_mqtt_handler.beam"],
        app_name = "rabbitmq_web_mqtt",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbit_common:erlang_app", "//deps/rabbitmq_mqtt:erlang_app", "@cowboy//:erlang_app"],
    )

    erlang_bytecode(
        name = "test_rabbit_web_mqtt_stream_handler_beam",
        testonly = True,
        srcs = ["src/rabbit_web_mqtt_stream_handler.erl"],
        outs = ["test/rabbit_web_mqtt_stream_handler.beam"],
        app_name = "rabbitmq_web_mqtt",
        erlc_opts = "//:test_erlc_opts",
        deps = ["@cowboy//:erlang_app"],
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
        srcs = ["priv/schema/rabbitmq_web_mqtt.schema"],
    )
    filegroup(
        name = "public_hdrs",
        srcs = [],
    )

    filegroup(
        name = "srcs",
        srcs = ["src/rabbit_web_mqtt_app.erl", "src/rabbit_web_mqtt_handler.erl", "src/rabbit_web_mqtt_stream_handler.erl"],
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
        name = "proxy_protocol_SUITE_beam_files",
        testonly = True,
        srcs = ["test/proxy_protocol_SUITE.erl"],
        outs = ["test/proxy_protocol_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "system_SUITE_beam_files",
        testonly = True,
        srcs = ["test/system_SUITE.erl"],
        outs = ["test/system_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
    )

    erlang_bytecode(
        name = "test_src_rabbit_ws_test_util_beam",
        testonly = True,
        srcs = ["test/src/rabbit_ws_test_util.erl"],
        outs = ["test/src/rabbit_ws_test_util.beam"],
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_src_rfc6455_client_beam",
        testonly = True,
        srcs = ["test/src/rfc6455_client.erl"],
        outs = ["test/src/rfc6455_client.beam"],
        erlc_opts = "//:test_erlc_opts",
    )
