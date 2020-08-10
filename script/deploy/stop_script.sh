#!/bin/bash

ps -ef | grep node | grep mssql_collector_plugin | awk \'{print $2}\' | xargs kill -9