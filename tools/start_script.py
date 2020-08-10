#!/usr/local/easyops/python/bin/python
# -*- coding: UTF-8 -*-

import os
import subprocess


mssql_server = os.environ.get("EASYOPS_COLLECTOR_mssql_server", "127.0.0.1")
mssql_port = os.environ.get("EASYOPS_COLLECTOR_mssql_port", "1433")
mssql_username = os.environ.get("EASYOPS_COLLECTOR_mssql_username", "")
mssql_password = os.environ.get("EASYOPS_COLLECTOR_mssql_password", "")
mssql_conn_encrypt = os.environ.get("EASYOPS_COLLECTOR_mssql_conn_encrypt", "false")

exporter_host = os.environ.get("EASYOPS_COLLECTOR_exporter_host", "127.0.0.1")
exporter_port = os.environ.get("EASYOPS_COLLECTOR_exporter_port", "4000")


def run_command(command, env={}, shell=False, close_fds=True):
    process = subprocess.Popen(
        command,
        env=env,
        shell=shell,
        close_fds=close_fds
    )

    return process.returncode


if __name__ == "__main__":
    src_path = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "src")
    env = os.environ.copy()
    env["ENCRYPT"] = mssql_conn_encrypt
    env["SERVER"] = mssql_server
    env["PORT"] = mssql_port
    env["USERNAME"] = mssql_username
    env["PASSWORD"] = mssql_password
    env["EXPOSE"] = exporter_port

    start_cmd = "node {entry}".format(entry=os.path.join(src_path, "index.js"))
    run_command(start_cmd, shell=True, env=env)
