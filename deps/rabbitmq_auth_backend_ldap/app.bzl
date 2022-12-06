load("@rules_erlang//:erlang_bytecode2.bzl", "erlang_bytecode")
load("@rules_erlang//:filegroup.bzl", "filegroup")

def all_beam_files(name = "all_beam_files"):
    filegroup(
        name = "beam_files",
        srcs = ["ebin/rabbit_auth_backend_ldap.beam", "ebin/rabbit_auth_backend_ldap_app.beam", "ebin/rabbit_auth_backend_ldap_util.beam", "ebin/rabbit_log_ldap.beam"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_auth_backend_ldap_app_beam",
        srcs = ["src/rabbit_auth_backend_ldap_app.erl"],
        outs = ["ebin/rabbit_auth_backend_ldap_app.beam"],
        app_name = "rabbitmq_auth_backend_ldap",
        erlc_opts = "//:erlc_opts",
    )
    erlang_bytecode(
        name = "ebin_rabbit_auth_backend_ldap_beam",
        srcs = ["src/rabbit_auth_backend_ldap.erl"],
        outs = ["ebin/rabbit_auth_backend_ldap.beam"],
        app_name = "rabbitmq_auth_backend_ldap",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_auth_backend_ldap_util_beam",
        srcs = ["src/rabbit_auth_backend_ldap_util.erl"],
        outs = ["ebin/rabbit_auth_backend_ldap_util.beam"],
        app_name = "rabbitmq_auth_backend_ldap",
        erlc_opts = "//:erlc_opts",
    )
    erlang_bytecode(
        name = "ebin_rabbit_log_ldap_beam",
        srcs = ["src/rabbit_log_ldap.erl"],
        outs = ["ebin/rabbit_log_ldap.beam"],
        hdrs = ["include/logging.hrl"],
        app_name = "rabbitmq_auth_backend_ldap",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )

def all_test_beam_files(name = "all_test_beam_files"):
    filegroup(
        name = "test_beam_files",
        testonly = True,
        srcs = ["test/rabbit_auth_backend_ldap.beam", "test/rabbit_auth_backend_ldap_app.beam", "test/rabbit_auth_backend_ldap_util.beam", "test/rabbit_log_ldap.beam"],
    )
    erlang_bytecode(
        name = "test_rabbit_auth_backend_ldap_app_beam",
        testonly = True,
        srcs = ["src/rabbit_auth_backend_ldap_app.erl"],
        outs = ["test/rabbit_auth_backend_ldap_app.beam"],
        app_name = "rabbitmq_auth_backend_ldap",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_rabbit_auth_backend_ldap_beam",
        testonly = True,
        srcs = ["src/rabbit_auth_backend_ldap.erl"],
        outs = ["test/rabbit_auth_backend_ldap.beam"],
        app_name = "rabbitmq_auth_backend_ldap",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_auth_backend_ldap_util_beam",
        testonly = True,
        srcs = ["src/rabbit_auth_backend_ldap_util.erl"],
        outs = ["test/rabbit_auth_backend_ldap_util.beam"],
        app_name = "rabbitmq_auth_backend_ldap",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_rabbit_log_ldap_beam",
        testonly = True,
        srcs = ["src/rabbit_log_ldap.erl"],
        outs = ["test/rabbit_log_ldap.beam"],
        hdrs = ["include/logging.hrl"],
        app_name = "rabbitmq_auth_backend_ldap",
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
        srcs = ["priv/schema/rabbitmq_auth_backend_ldap.schema"],
    )
    filegroup(
        name = "private_hdrs",
        srcs = [],
    )
    filegroup(
        name = "srcs",
        srcs = ["src/rabbit_auth_backend_ldap.erl", "src/rabbit_auth_backend_ldap_app.erl", "src/rabbit_auth_backend_ldap_util.erl", "src/rabbit_log_ldap.erl"],
    )
    filegroup(
        name = "public_hdrs",
        srcs = ["include/logging.hrl"],
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
        name = "system_SUITE_beam_files",
        testonly = True,
        srcs = ["test/system_SUITE.erl"],
        outs = ["test/system_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_ldap_seed_beam",
        testonly = True,
        srcs = ["test/rabbit_ldap_seed.erl"],
        outs = ["test/rabbit_ldap_seed.beam"],
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "unit_SUITE_beam_files",
        testonly = True,
        srcs = ["test/unit_SUITE.erl"],
        outs = ["test/unit_SUITE.beam"],
        erlc_opts = "//:test_erlc_opts",
    )