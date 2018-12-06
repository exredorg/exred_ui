#!/bin/bash
# wait-for-postgres.sh

cmdname=$(basename $0)

usage()
{
    cat << USAGE >&2
Usage:
    $cmdname [options] [-- command args]
    -h HOST              Host or IP under test (default: localhost)
    -p PORT             TCP port under test (default: 5432) 
    -r RETRIES          Number of times to retry connecting  (default: 5)
    -d DATABASE         Database to connect to
    -- COMMAND ARGS     Execute command with args after the test finishes
USAGE
    exit 1
}

# read defaults from environment
# these are passed in through the docker compose env_file
HOST="${EXRED_DB_HOSTNAME:-localhost}"
PORT="${EXRED_DB_PORT:-5432}"
DATABASE="${EXRED_DB_NAME:-postgres}"
USER="${EXRED_DB_USERNAME:-postgres}"
PASSWORD="$EXRED_DB_PASSWORD"

RETRIES=5

# process arguments
while [[ $# -gt 0 ]]
do
    case "$1" in
        -h)
        HOST="$2"
        if [[ $HOST == "" ]]; then break; fi
        shift 2
        ;;

        -p)
        PORT="$2"
        if [[ $PORT == "" ]]; then break; fi
        shift 2
        ;;

        -d)
        DATABASE="$2"
        if [[ $DATABASE == "" ]]; then break; fi
        shift 2
        ;;
 
        -r)
        RETRIES="$2"
        if [[ $RETRIES == "" ]]; then break; fi
        shift 2
        ;;

        --)
        shift
        CMD="$@"
        break
        ;;

        --help)
        usage
        ;;

        *)
        echo "Unknown argument: $1"
        usage
        ;;
    esac
done

echo "Waiting for database $DATABASE on $HOST:$PORT. Connecting as user $USER."
echo

while [[ $RETRIES -gt 0 ]]
do
    PGPASSWORD=$PASSWORD psql -h "$HOST" -U "$USER" -d "$DATABASE" -c "\q" > /dev/null 2>&1;
    result=$?
    if [[ $result -eq 0 ]]; then
        break;
    fi 
    RETRIES=$((RETRIES-=1));
    echo "Waiting for postgres server, $RETRIES remaining attempts...";
    sleep 1;
done

if [[ $result -eq 0 ]]; then
    echo "Postgres is up - executing command"
    exec $CMD;
fi


#until PGPASSWORD=$PASSWORD psql -h "$HOST" -U "$USER" -d "$DATABASE" -c "\q" > /dev/null 2>&1 || [ $RETRIES -eq 0 ]; do
#  echo "Waiting for postgres server, $((RETRIES--)) remaining attempts...";
#  sleep 1;
#done


#>&2 echo "$?  Postgres is up - executing command"
#exec $CMD



