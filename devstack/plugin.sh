# container - Devstack extras script to install container engine

# Save trace setting
XTRACE=$(set +o | grep xtrace)
set -o xtrace

echo_summary "container's plugin.sh was called..."
source $DEST/devstack-plugin-container/devstack/lib/docker
(set -o posix; set)

if is_service_enabled container; then
    if [[ "$1" == "stack" && "$2" == "install" ]]; then
        echo_summary "Installing container engine"
        if [[ ${CONTAINER_ENGINE} == "docker" ]]; then
            check_docker || install_docker
        fi
    elif [[ "$1" == "stack" && "$2" == "post-config" ]]; then
        echo_summary "Configuring container engine"
        if [[ ${CONTAINER_ENGINE} == "docker" ]]; then
            configure_docker
        fi
    fi

    if [[ "$1" == "unstack" ]]; then
        if [[ ${CONTAINER_ENGINE} == "docker" ]]; then
            stop_docker
        fi
    fi

    if [[ "$1" == "clean" ]]; then
        # nothing needed here
        :
    fi
fi

# Restore xtrace
$XTRACE
