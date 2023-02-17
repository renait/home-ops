#!/bin/bash

#set -e

## The following commented environment variables should be set
## before running this script

# export GOVC_USERNAME='administrator@vsphere.local'
# export GOVC_PASSWORD='xxx'
# export GOVC_INSECURE=true
# export GOVC_URL='https://172.16.199.151'
# export GOVC_DATASTORE='xxx'

CLUSTER_NAME=${CLUSTER_NAME:=cluster-0}
TALOS_VERSION=v1.3.4
OVA_PATH=${OVA_PATH:="https://github.com/siderolabs/talos/releases/download/${TALOS_VERSION}/vmware-amd64.ova"}

CONTROL_PLANE_CPU=${CONTROL_PLANE_CPU:=2}
CONTROL_PLANE_MEM=${CONTROL_PLANE_MEM:=4096}
CONTROL_PLANE_DISK=${CONTROL_PLANE_DISK:=32G}
CONTROL_PLANE_MACHINE_CONFIG_PATH_GLOB="./clusterconfig/*control*"
CONTROL_PLANE_MAC_ADDRESSES=("00:50:56:a8:c0:61" "00:50:56:a8:f3:43" "00:50:56:a8:fb:24")

WORKER_CPU=${WORKER_CPU:=2}
WORKER_MEM=${WORKER_MEM:=4096}
WORKER_DISK=${WORKER_DISK:=32G}
WORKER_MACHINE_CONFIG_PATH_GLOB="./clusterconfig/*worker*"
WORKER_MAC_ADDRESSES=("00:50:56:a8:2e:fa" "00:50:56:a8:ef:7a")

#set -x

upload_ova () {
    ## Import desired Talos Linux OVA into a new content library
    govc library.create ${CLUSTER_NAME}
    govc library.import -n talos-${TALOS_VERSION} ${CLUSTER_NAME} ${OVA_PATH}
}

create_control_plane () {
    local vm=$1
    local config=$2
    local mac=$3

    govc library.deploy ${CLUSTER_NAME}/talos-${TALOS_VERSION} "${vm}"

    govc vm.change \
    -c ${CONTROL_PLANE_CPU}\
    -m ${CONTROL_PLANE_MEM} \
    -e "guestinfo.talos.config=${config}" \
    -e "disk.enableUUID=1" \
    -vm "${vm}"

    govc vm.disk.change -vm "${vm}" -disk.name disk-1000-0 -size ${CONTROL_PLANE_DISK}
    govc vm.network.change -vm "${vm}" -net "${GOVC_NETWORK}" -net.address="${mac}" ethernet-0

    govc vm.power -on "${vm}"
}

create_worker()  {
    local vm=$1
    local config=$2
    local mac=$3

    govc library.deploy ${CLUSTER_NAME}/talos-${TALOS_VERSION} "${vm}"

    govc vm.change \
    -c ${WORKER_CPU}\
    -m ${WORKER_MEM} \
    -e "guestinfo.talos.config=${config}" \
    -e "disk.enableUUID=1" \
    -vm "${vm}"

    govc vm.disk.change -vm "${vm}" -disk.name disk-1000-0 -size ${WORKER_DISK}
    govc vm.network.change -vm "${vm}" -net "${GOVC_NETWORK}" -net.address="${mac}" ethernet-0

    govc vm.power -on "${vm}"
}

create() {
    node=0
    ## Create control plane nodes and edit their settings
    for path in ${CONTROL_PLANE_MACHINE_CONFIG_PATH_GLOB}; do
        ## Encode machine configs
        #local controlPlaneMachineConfigPath=${CONTROL_PLANE_MACHINE_CONFIG_PATH_GLOB}-${i}
        echo "Found control plane config: ${path}"
        machine_config=$(cat "${path}" | base64 | tr -d '\n')

        local vm="$CLUSTER_NAME-k8s-control-plane-${node}"

        echo ""
        echo "launching control plane node: ${vm}"
        echo ""

        create_control_plane $vm "$machine_config" "${CONTROL_PLANE_MAC_ADDRESSES[$node]}"

        ((node=node+1))
    done

    node=0
    ## Create worker nodes and edit their settings
    for path in ${WORKER_MACHINE_CONFIG_PATH_GLOB}; do
        echo "Found worker config: ${path}"
        machine_config=$(cat "${path}" | base64 | tr -d '\n')

        local vm="$CLUSTER_NAME-k8s-worker-${node}"

        echo ""
        echo "launching worker node: ${vm}"
        echo ""

        create_worker $vm "$machine_config" "${WORKER_MAC_ADDRESSES[$node]}"

        ((node=node+1))
    done
}

destroy() {
    node=0
    ## Create control plane nodes and edit their settings
    for path in ${CONTROL_PLANE_MACHINE_CONFIG_PATH_GLOB}; do
        local vm="$CLUSTER_NAME-k8s-control-plane-${node}"

        echo ""
        echo "destroying control plane node: ${vm}"
        echo ""

        govc vm.destroy ${vm}

        ((node=node+1))
    done

    node=0
    ## Create worker nodes and edit their settings
    for path in ${WORKER_MACHINE_CONFIG_PATH_GLOB}; do
        local vm="$CLUSTER_NAME-k8s-worker-${node}"

        echo ""
        echo "destroying worker node: ${vm}"
        echo ""
        govc vm.destroy ${vm}

        ((node=node+1))
    done
}

delete_ova() {
    govc library.rm ${CLUSTER_NAME}
}

"$@"
