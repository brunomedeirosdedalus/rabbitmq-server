load("@rules_erlang//:erlang_bytecode2.bzl", "erlang_bytecode")
load("@rules_erlang//:filegroup.bzl", "filegroup")

def all_beam_files(name = "all_beam_files"):
    filegroup(
        name = "beam_files",
        srcs = ["ebin/rabbit_top_app.beam", "ebin/rabbit_top_extension.beam", "ebin/rabbit_top_sup.beam", "ebin/rabbit_top_util.beam", "ebin/rabbit_top_wm_ets_tables.beam", "ebin/rabbit_top_wm_process.beam", "ebin/rabbit_top_wm_processes.beam", "ebin/rabbit_top_worker.beam"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_top_app_beam",
        srcs = ["src/rabbit_top_app.erl"],
        outs = ["ebin/rabbit_top_app.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:erlc_opts",
    )
    erlang_bytecode(
        name = "ebin_rabbit_top_extension_beam",
        srcs = ["src/rabbit_top_extension.erl"],
        outs = ["ebin/rabbit_top_extension.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbitmq_management:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_top_sup_beam",
        srcs = ["src/rabbit_top_sup.erl"],
        outs = ["ebin/rabbit_top_sup.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_top_util_beam",
        srcs = ["src/rabbit_top_util.erl"],
        outs = ["ebin/rabbit_top_util.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_top_wm_ets_tables_beam",
        srcs = ["src/rabbit_top_wm_ets_tables.erl"],
        outs = ["ebin/rabbit_top_wm_ets_tables.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_top_wm_process_beam",
        srcs = ["src/rabbit_top_wm_process.erl"],
        outs = ["ebin/rabbit_top_wm_process.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_top_wm_processes_beam",
        srcs = ["src/rabbit_top_wm_processes.erl"],
        outs = ["ebin/rabbit_top_wm_processes.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "ebin_rabbit_top_worker_beam",
        srcs = ["src/rabbit_top_worker.erl"],
        outs = ["ebin/rabbit_top_worker.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:erlc_opts",
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
        srcs = ["priv/www/js/tmpl/ets_tables.ejs", "priv/www/js/tmpl/process.ejs", "priv/www/js/tmpl/processes.ejs", "priv/www/js/top.js"],
    )
    filegroup(
        name = "public_hdrs",
        srcs = [],
    )

    filegroup(
        name = "srcs",
        srcs = ["src/rabbit_top_app.erl", "src/rabbit_top_extension.erl", "src/rabbit_top_sup.erl", "src/rabbit_top_util.erl", "src/rabbit_top_wm_ets_tables.erl", "src/rabbit_top_wm_process.erl", "src/rabbit_top_wm_processes.erl", "src/rabbit_top_worker.erl"],
    )
    filegroup(
        name = "private_hdrs",
        srcs = [],
    )

def all_test_beam_files(name = "all_test_beam_files"):
    filegroup(
        name = "test_beam_files",
        testonly = True,
        srcs = ["test/rabbit_top_app.beam", "test/rabbit_top_extension.beam", "test/rabbit_top_sup.beam", "test/rabbit_top_util.beam", "test/rabbit_top_wm_ets_tables.beam", "test/rabbit_top_wm_process.beam", "test/rabbit_top_wm_processes.beam", "test/rabbit_top_worker.beam"],
    )
    erlang_bytecode(
        name = "test_rabbit_top_app_beam",
        testonly = True,
        srcs = ["src/rabbit_top_app.erl"],
        outs = ["test/rabbit_top_app.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:test_erlc_opts",
    )
    erlang_bytecode(
        name = "test_rabbit_top_extension_beam",
        testonly = True,
        srcs = ["src/rabbit_top_extension.erl"],
        outs = ["test/rabbit_top_extension.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbitmq_management:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_top_sup_beam",
        testonly = True,
        srcs = ["src/rabbit_top_sup.erl"],
        outs = ["test/rabbit_top_sup.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_top_util_beam",
        testonly = True,
        srcs = ["src/rabbit_top_util.erl"],
        outs = ["test/rabbit_top_util.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/rabbit_common:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_top_wm_ets_tables_beam",
        testonly = True,
        srcs = ["src/rabbit_top_wm_ets_tables.erl"],
        outs = ["test/rabbit_top_wm_ets_tables.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_top_wm_process_beam",
        testonly = True,
        srcs = ["src/rabbit_top_wm_process.erl"],
        outs = ["test/rabbit_top_wm_process.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_top_wm_processes_beam",
        testonly = True,
        srcs = ["src/rabbit_top_wm_processes.erl"],
        outs = ["test/rabbit_top_wm_processes.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:test_erlc_opts",
        deps = ["//deps/amqp_client:erlang_app", "//deps/rabbitmq_management_agent:erlang_app"],
    )
    erlang_bytecode(
        name = "test_rabbit_top_worker_beam",
        testonly = True,
        srcs = ["src/rabbit_top_worker.erl"],
        outs = ["test/rabbit_top_worker.beam"],
        app_name = "rabbitmq_top",
        erlc_opts = "//:test_erlc_opts",
    )

def test_suite_beam_files(name = "test_suite_beam_files"):
    pass
