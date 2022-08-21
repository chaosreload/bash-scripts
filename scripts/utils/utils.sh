#!/bin/bash



# usage: checkuser ${username}
function checkuser()
{
    local username="${1}"
    me="$(whoami)"
    if [ "${me}" == "${username}" ];then
        echo "hello, ${username}"
    else
        echo "please run as ${username}"
        return 1
    fi
}

# usage: get_var_from_str "varname"
function get_var_from_str() {
    var_str="${1}"
    echo "$(eval echo \${${var_str}})"
}

# usage: check_var "varname"
function check_var() {
    var_exact=$(eval echo \${${1}})
    if [ ! ${var_exact} ]; then
        echo "${1} not found."
        return 1
    fi
}

# usage: check_path ${path}
function check_path() {
    if [ ! -e "${1}" ]; then
        echo "${1} not found."
        return 1
    fi
}

# check the path of cmd
# usage: check_command ${cmd}
function check_command() {
    cmd="${1}"
    cmd_path=$(which ${cmd})
    if [ -z "${cmd_path}" ];then
        echo "${cmd} can NOT be found in this server, please check"
        return 1
    else
        echo "${cmd} is ${cmd_path}"
    fi
}


# usage: check_status ${operation_cmd} ${?} ${msg_handler}, follow your operation
# msg_handler only support "echo" or your writelog function
function check_status()
{
    msg_handler="${3}"
    operation_cmd="${1}"
    status="${2}"
    if [ "${status}" == '0' ]; then
        ${msg_handler} "operation ${operation_cmd}  [SUCCESS]"
        #write_log "operation: ${operation_cmd} success"
        return 0
    else
        ${msg_handler} "operation ${operation_cmd} [FAILED]"
        #write_log "operation: ${operation_cmd} failed"
        return 1
    fi
}

function char_upper() {
    char="${1}"
    echo "${char}" | tr 'a-z' 'A-Z'
}

function char_lower() {
    char="${1}"
    echo "${char}" | tr 'A-Z' 'a-z'
}




# you'd better wrap this with your custom write_log function
function write_log_base() {
    logpath="${1}"
    logdir="$(dirname ${logpath})"
    if [ ! -e "${logdir}" ];then
        echo "${logdir} not found, create ${logdir} now"
        mkdir -p "${logdir}"
    fi
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ${@:2}" >> ${logpath}
    return ${?}
}

# usage: array_contains 'array_name' 'element_name'
function array_contains () {
    local array="${1}[@]"
    local seeking=${2}
    local in=1
    #echo ${!array}
    for element in "${!array}"; do
        #echo $element
        if [ "${element}" == "${seeking}" ]; then
            in=0
            break
        fi
    done
    return $in
}

# usage: op_srv_supervisor ${operation} ${servicename}
function op_srv_supervisor() {
    op=${1}
    srv=${2}
    supervisorcmd="$(which supervisorctl)"
    if [ -f "${supervisorcmd}" ];then
        sudo ${supervisorcmd} ${op} ${srv}
        return ${?}
    else
        echo "there are no supervisorctl, please check"
        #write_log "there are no supervisorctl, please check"
        return 1
    fi
}
