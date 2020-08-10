#!/bin/bash

if ! type getopt >/dev/null 2>&1 ; then
  echo "Error: command \"getopt\" is not found" >&2
  exit 1
fi

getopt_cmd=`getopt -o h -a -l help,mssql-host:,mssql-port:,mssql-user:,mssql-password:,mssql-conn-encrypt:,exporter-host:,exporter-port: -n "start.sh" -- "$@"`
if [ $? -ne 0 ] ; then
    exit 1
fi
eval set -- "$getopt_cmd"

mssql_host="127.0.0.1"
mssql_port=1433
mssql_user=""
mssql_password=""
mssql_conn_encrypt="false"
exporter_host="127.0.0.1"
exporter_port=4000

print_help() {
    echo "Usage:"
    echo "    start_script.sh [options]"
    echo "    start_script.sh --mssql-host 127.0.0.1 --mssql-port 1433 --mssql-user root [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                 show help"
    echo "      --mssql-host           the address of mssql server (\"127.0.0.1\" by default)"
    echo "      --mssql-port           the port of mssql server (1433 by default)"
    echo "      --mssql-user           the user to log in to mssql server"
    echo "      --mssql-password       the password to log in to mssql server"
    echo "      --mssql-conn-encrypt   whether use encrypt connection"

    echo "      --exporter-host        the listen address of exporter (\"127.0.0.1\" by default)"
    echo "      --exporter-port        the listen port of exporter (4000 by default)"
}

while true
do
    case "$1" in
        -h | --help)
            print_help
            shift 1
            exit 0
            ;;
        --mssql-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    mssql_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --mssql-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    mssql_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --mssql-user)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    mssql_user="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --mssql-password)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    mssql_password="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --mssql-conn-encrypt)
            case "$2" in
                "")
                    shift 2
                    ;;
                *)
                    mssql_conn_encrypt="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Error: argument \"$1\" is invalid" >&2
            echo ""
            print_help
            exit 1
            ;;
    esac
done

EASYOPS_COLLECTOR_mssql_server=$mssql_host
EASYOPS_COLLECTOR_mssql_port=$mssql_port
EASYOPS_COLLECTOR_mssql_username=$mssql_user
EASYOPS_COLLECTOR_mssql_password=$mssql_password
EASYOPS_COLLECTOR_mssql_conn_encrypt=$mssql_conn_encrypt

EASYOPS_COLLECTOR_exporter_host=$exporter_host
EASYOPS_COLLECTOR_exporter_port=$exporter_port

export ENCRYPT=$mssql_conn_encrypt
export SERVER=$mssql_host
export PORT=$mssql_port
export USERNAME=$mssql_user
export PASSWORD=$mssql_password
export EXPOSE=$exporter_port

cd src && nohup node index.js &
