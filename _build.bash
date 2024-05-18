#!/bin/bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8;
export SRC=$CI_SOURCE_PATH/src

if [ ! -d "$SRC" ]; then
  mkdir $SRC
  cd $SRC
  git clone https://git.yoctoproject.org/git/poky
  git clone https://github.com/openembedded/meta-openembedded.git
  git clone https://git.yoctoproject.org/git/meta-virtualization
  git clone https://git.yoctoproject.org/git/meta-intel
  git clone https://github.com/intel/meta-acrn.git

  source poky/oe-init-build-env
  bitbake-layers add-layer ../meta-openembedded/meta-oe
  bitbake-layers add-layer ../meta-openembedded/meta-python
  bitbake-layers add-layer ../meta-openembedded/meta-networking
  bitbake-layers add-layer ../meta-openembedded/meta-filesystems
  bitbake-layers add-layer ../meta-virtualization
  bitbake-layers add-layer ../meta-intel
  bitbake-layers add-layer ../meta-acrn

  cat <<EOF >> conf/local.conf 
MACHINE = "intel-skylake-64"
TMPDIR = "\${TOPDIR}/master-acrn-sos"
DISTRO = "acrn-demo-service-vm"

# Also use the 'uos' configuration
BBMULTICONFIG = "uos"

# The packages-from-images class (container-package.bbclass) needs to know where images are
CONTAINER_PACKAGE_DEPLOY_DIR = "\${TOPDIR}/master-acrn-uos/deploy/images/\${MACHINE}"
CONTAINER_PACKAGE_MC = "uos"

# Add core-image-base-package to acrn-image-base
IMAGE_INSTALL:append:pn-acrn-image-base = " core-image-base-package"
# Add core-image-weston-package to acrn-image-sato
IMAGE_INSTALL:append:pn-acrn-image-sato = " core-image-weston-package"

# set preferred kernel for sos
PREFERRED_PROVIDER_virtual/kernel = "linux-intel-acrn-service-vm"

ACRN_BOARD = "qemu"
ACRN_RELEASE = "n"
EOF

  mkdir conf/multiconfig
  cat <<EOF >> conf/multiconfig/uos.conf
DISTRO = "acrn-demo-user-vm"
TMPDIR = "\${TOPDIR}/master-acrn-uos"
PREFERRED_PROVIDER_virtual/kernel = "linux-intel-acrn-user-vm"
EOF
else
  cd $SRC
  source poky/oe-init-build-env
fi

bitbake acrn-image-base
bitbake acrn-image-base -c populate_sdk
