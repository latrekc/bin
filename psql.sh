__run-psql () {
	__DB_USER="$1"
	__DB_PASSWORD="$2"
	__DB_HOST="$3"
	__DB_NAME="$4"
	__DB_COMMAND="$5"

	if [[ -z $__DB_COMMAND ]]
	then
		PGPASSWORD="$__DB_PASSWORD" psql -U $__DB_USER -h $__DB_HOST $__DB_NAME
	else
		PGPASSWORD="$__DB_PASSWORD" psql -U $__DB_USER -h $__DB_HOST $__DB_NAME -c "$__DB_COMMAND"
	fi
}

__run-psql-dump () {
	__ENV="$1"
	__DB_USER="$2"
	__DB_PASSWORD="$3"
	__DB_HOST="$4"
	__DB_NAME="$5"
	__DB_SCHEMAS="$6"

	_TIME=`date +'%Y-%m-%d-%H-%M-%S'`
	_FILENAME="${__DB_NAME}-${__ENV}-${_TIME}.sql"

	PGPASSWORD="$__DB_PASSWORD" pg_dump -U $__DB_USER -h $__DB_HOST $__DB_NAME -s -O $__DB_SCHEMAS -f "$_FILENAME"

	echo
	ls -lh $_FILENAME
}


# Connect to the replica DB by SSM parameters
psql-replica () {
	if [[ -z $1 ]]
	then
		echo "Empty environment name"
		return 1
	fi

	case $1 in 
		production) replicaPath="replica-dev";;
		staging) replicaPath="replica-analytics";;
		*) echo "Wrong environment name $1"; return 2;;
	esac

	local _REPLICA_PREFIX="/databases/rds-pg-threads-main-$replicaPath"
	echo "Connect to $_REPLICA_PREFIX ..."

	eval `AWS_PROFILE="threads-$1" aws ssm get-parameters-by-path --recursive --path "$_REPLICA_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _REPLICA_\"+(.Name|sub(\"$_REPLICA_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`


	local _RO_PREFIX="/databases/rds-pg-threads-main/threads_main/analyticsro"
	echo "Connect to $_RO_PREFIX ..."

	eval `AWS_PROFILE="threads-$1" aws ssm get-parameters-by-path --recursive --path "$_RO_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _RO_\"+(.Name|sub(\"$_RO_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`

	__run-psql "$_RO_USER" "$_RO_PASSWORD" "$_REPLICA_HOST" "$_RO_DB" "$2"
}


# Dump the replica DB by SSM parameters
psql-dump-replica () {
	if [[ -z $1 ]]
	then
		echo "Empty environment name"
		return 1
	fi

	case $1 in 
		production) replicaPath="replica-dev";;
		staging) replicaPath="replica-analytics";;
		*) echo "Wrong environment name $1"; return 2;;
	esac

	local _REPLICA_PREFIX="/databases/rds-pg-threads-main-$replicaPath"
	echo "Connect to $_REPLICA_PREFIX ..."

	eval `AWS_PROFILE="threads-$1" aws ssm get-parameters-by-path --recursive --path "$_REPLICA_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _REPLICA_\"+(.Name|sub(\"$_REPLICA_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`


	local _RO_PREFIX="/databases/rds-pg-threads-main/threads_main/analyticsro"
	echo "Connect to $_RO_PREFIX ..."

	eval `AWS_PROFILE="threads-$1" aws ssm get-parameters-by-path --recursive --path "$_RO_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _RO_\"+(.Name|sub(\"$_RO_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`

	__run-psql-dump "$1" "$_RO_USER" "$_RO_PASSWORD" "$_REPLICA_HOST" "$_RO_DB" "\
		-n parcels \
		-n payments \
		-n constraints \
		-n contacts \
		-n product_catalogue \
		-n public \
		-n users"
}

# Connect to the DB by SSM parameters
psql-for () {
	if [[ -z $1 ]]
	then
		echo "Empty service name"
		return 1
	fi

	if [[ -z $2 ]]
	then
		echo "Empty environment name"
		return 2
	fi

	local _PREFIX="/databases/rds-pg-threads-main/threads_main/$1"
	echo "Connect to $_PREFIX ..."

	eval `AWS_PROFILE="threads-$2" aws ssm get-parameters-by-path --recursive --path "$_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _\"+(.Name|sub(\"$_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`
	echo "host ${_HOST}"

	__run-psql "$_USER" "$_PASSWORD" "$_HOST" "$_DB" "$3"
} 

# Dump to the DB by SSM parameters
psql-dump-for () {
	if [[ -z $1 ]]
	then
		echo "Empty service name"
		return 1
	fi

	if [[ -z $2 ]]
	then
		echo "Empty environment name"
		return 2
	fi

	local _PREFIX="/databases/rds-pg-threads-main/threads_main/$1"
	echo "Connect to $_PREFIX ..."

	eval `AWS_PROFILE="threads-$2" aws ssm get-parameters-by-path --recursive --path "$_PREFIX" --with-decryption | jq -r ".Parameters[] | \"local _\"+(.Name|sub(\"$_PREFIX/\";\"\")|ascii_upcase) + \"='\" + .Value + \"';\""`
	echo "host ${_HOST}"

	__run-psql-dump "$2" "$_USER" "$_PASSWORD" "$_HOST" "$_DB" "-n $_SCHEMA"
}
