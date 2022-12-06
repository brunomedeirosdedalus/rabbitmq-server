load("@rules_erlang//:erlang_bytecode2.bzl", "erlang_bytecode")
load("@rules_erlang//:filegroup.bzl", "filegroup")

def all_beam_files(name = "all_beam_files"):
    filegroup(
        name = "beam_files",
        srcs = ["ebin/rabbit_stream_connection_consumers_mgmt.beam", "ebin/rabbit_stream_connection_mgmt.beam", "ebin/rabbit_stream_connection_publishers_mgmt.beam", "ebin/rabbit_stream_connections_mgmt.beam", "ebin/rabbit_stream_connections_vhost_mgmt.beam", "ebin/rabbit_stream_consumers_mgmt.beam", "ebin/rabbit_stream_management_utils.beam", "ebin/rabbit_stream_mgmt_db.beam", "ebin/rabbit_stream_publishers_mgmt.beam"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_connection_consumers_mgmt_beam",
        srcs = ["src/rabbit_stream_connection_consumers_mgmt.erl"],
        outs = ["ebin/rabbit_stream_connection_consumers_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_connection_mgmt_beam",
        srcs = ["src/rabbit_stream_connection_mgmt.erl"],
        outs = ["ebin/rabbit_stream_connection_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_connection_publishers_mgmt_beam",
        srcs = ["src/rabbit_stream_connection_publishers_mgmt.erl"],
        outs = ["ebin/rabbit_stream_connection_publishers_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_connections_mgmt_beam",
        srcs = ["src/rabbit_stream_connections_mgmt.erl"],
        outs = ["ebin/rabbit_stream_connections_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_connections_vhost_mgmt_beam",
        srcs = ["src/rabbit_stream_connections_vhost_mgmt.erl"],
        outs = ["ebin/rabbit_stream_connections_vhost_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_consumers_mgmt_beam",
        srcs = ["src/rabbit_stream_consumers_mgmt.erl"],
        outs = ["ebin/rabbit_stream_consumers_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_management_utils_beam",
        srcs = ["src/rabbit_stream_management_utils.erl"],
        outs = ["ebin/rabbit_stream_management_utils.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_mgmt_db_beam",
        srcs = ["src/rabbit_stream_mgmt_db.erl"],
        outs = ["ebin/rabbit_stream_mgmt_db.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_stream:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_stream_publishers_mgmt_beam",
        srcs = ["src/rabbit_stream_publishers_mgmt.erl"],
        outs = ["ebin/rabbit_stream_publishers_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )

def all_test_beam_files(name = "all_test_beam_files"):
    filegroup(
        name = "test_beam_files",
        testonly = True,
        srcs = ["test/rabbit_stream_connection_consumers_mgmt.beam", "test/rabbit_stream_connection_mgmt.beam", "test/rabbit_stream_connection_publishers_mgmt.beam", "test/rabbit_stream_connections_mgmt.beam", "test/rabbit_stream_connections_vhost_mgmt.beam", "test/rabbit_stream_consumers_mgmt.beam", "test/rabbit_stream_management_utils.beam", "test/rabbit_stream_mgmt_db.beam", "test/rabbit_stream_publishers_mgmt.beam"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_connection_consumers_mgmt_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_connection_consumers_mgmt.erl"],
        outs = ["test/rabbit_stream_connection_consumers_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_connection_mgmt_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_connection_mgmt.erl"],
        outs = ["test/rabbit_stream_connection_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_connection_publishers_mgmt_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_connection_publishers_mgmt.erl"],
        outs = ["test/rabbit_stream_connection_publishers_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_connections_mgmt_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_connections_mgmt.erl"],
        outs = ["test/rabbit_stream_connections_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_connections_vhost_mgmt_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_connections_vhost_mgmt.erl"],
        outs = ["test/rabbit_stream_connections_vhost_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_consumers_mgmt_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_consumers_mgmt.erl"],
        outs = ["test/rabbit_stream_consumers_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_management_utils_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_management_utils.erl"],
        outs = ["test/rabbit_stream_management_utils.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_mgmt_db_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_mgmt_db.erl"],
        outs = ["test/rabbit_stream_mgmt_db.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_stream:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_stream_publishers_mgmt_beam",
        testonly = True,
        srcs = ["src/rabbit_stream_publishers_mgmt.erl"],
        outs = ["test/rabbit_stream_publishers_mgmt.beam"],
        app_name = "rabbitmq_stream_management",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_management:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
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
        srcs = ["priv/www/js/stream.js", "priv/www/js/tmpl/streamConnection.ejs", "priv/www/js/tmpl/streamConnections.ejs", "priv/www/js/tmpl/streamConsumersList.ejs", "priv/www/js/tmpl/streamPublishersList.ejs"],
    )
    filegroup(
        name = "public_hdrs",
        srcs = [],
    )

    filegroup(
        name = "srcs",
        srcs = ["src/rabbit_stream_connection_consumers_mgmt.erl", "src/rabbit_stream_connection_mgmt.erl", "src/rabbit_stream_connection_publishers_mgmt.erl", "src/rabbit_stream_connections_mgmt.erl", "src/rabbit_stream_connections_vhost_mgmt.erl", "src/rabbit_stream_consumers_mgmt.erl", "src/rabbit_stream_management_utils.erl", "src/rabbit_stream_mgmt_db.erl", "src/rabbit_stream_publishers_mgmt.erl"],
    )
    filegroup(
        name = "private_hdrs",
        srcs = [],
    )

def test_suite_beam_files(name = "test_suite_beam_files"):
    erlang_bytecode(
        name = "http_SUITE_beam_files",
        testonly = True,
        srcs = ["test/http_SUITE.erl"],
        outs = ["test/http_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app", "//deps/rabbitmq_ct_helpers:erlang_app"],
    )