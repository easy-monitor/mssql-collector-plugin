#!/bin/bash


PACKAGE_NAME=mssql-collector-plugin
PACKAGE_PATH=$(dirname "$(cd `dirname $0`; pwd)")
LOG_DIRECTORY=$PACKAGE_PATH/log
LOG_FILE=$LOG_DIRECTORY/$PACKAGE_NAME.log


if ! type getopt >/dev/null 2>&1 ; then
  message="command \"getopt\" is not found"
  echo "[ERROR] Message: $message" >& 2
  echo "$(date "+%Y-%m-%d %H:%M:%S") [ERROR] Message: $message" > $LOG_FILE
  exit 1
fi

getopt_cmd=`getopt -o h -a -l help:,mssql-host:,mssql-port:,mssql-user:,mssql-password:,mssql-conn-encrypt:,exporter-port: -n "start_script.sh" -- "$@"`
if [ $? -ne 0 ] ; then
    exit 1
fi
eval set -- "$getopt_cmd"


mssql_host="127.0.0.1"
mssql_port=1433
mssql_user=""
mssql_password=""
mssql_conn_encrypt="false"
exporter_port=4000

print_help() {
    echo "Usage:"
    echo "    start_script.sh [options]"
    echo "    start_script.sh --mssql-port 1433 --mssql-user root [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                 show help"
    echo "      --mssql-host           the address of mssql server (\"127.0.0.1\" by default)"
    echo "      --mssql-port           the port of mssql server (1433 by default)"
    echo "      --mssql-user           the user to log in to mssql server"
    echo "      --mssql-password       the password to log in to mssql server"
    echo "      --mssql-conn-encrypt   whether use encrypt connection"
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
            message="argument \"$1\" is invalid"
            echo "[ERROR] Message: $message" >& 2
            echo "$(date "+%Y-%m-%d %H:%M:%S") [ERROR] Message: $message" > $LOG_FILE
            print_help
            exit 1
            ;;
    esac
done

mkdir -p $LOG_DIRECTORY

message="start exporter"
echo "[INFO] Message: $message"
echo "$(date "+%Y-%m-%d %H:%M:%S") [INFO] Message: $message" >> $LOG_FILE

cd $PACKAGE_PATH

export SERVER=$mssql_host
export PORT=$mssql_port
export USERNAME=$mssql_user
export PASSWORD=$mssql_password
export ENCRYPT=$mssql_conn_encrypt
export EXPOSE=$exporter_port

./src/node/bin/node src/index.js 2>&1 | tee -a $LOG_FILE
