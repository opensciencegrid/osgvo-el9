FROM rockylinux:9

LABEL opensciencegrid.name="EL 9"
LABEL opensciencegrid.description="Enterprise Linux (Rocky) 9 base image"
LABEL opensciencegrid.url="https://rockylinux.org/"
LABEL opensciencegrid.category="Base"
LABEL opensciencegrid.definition_url="https://github.com/opensciencegrid/osgvo-el9"

# base dnf/yum setup
RUN dnf -y update && \
    dnf -y install yum-utils && \
    dnf -y config-manager --set-enabled crb && \
    dnf -y install epel-release

# osg repo
RUN dnf -y install https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el9-release-latest.rpm
   
# pegasus repo - not available yet
#RUN echo -e "# Pegasus\n[Pegasus]\nname=Pegasus\nbaseurl=https://download.pegasus.isi.edu/wms/download/rhel/9/\$basearch/\ngpgcheck=0\nenabled=1\npriority=50" >/etc/yum.repos.d/pegasus.repo

# well rounded basic system to support a wide range of user jobs
RUN dnf -y groupinstall "Development Tools" \
                        "Scientific Support"

RUN dnf -y install --allowerasing --enablerepo=osg-testing \
           bc \
           binutils \
           binutils-devel \
           coreutils \
           curl \
           fontconfig \
           gcc \
           gcc-c++ \
           gcc-gfortran \
           git \
           glib2-devel \
           glibc-langpack-en \
           glibc-locale-source \
           graphviz \
           gsl-devel \
           java-17-openjdk \
           java-17-openjdk-devel \
           jq \
           libgfortran \
           libGLU \
           libgomp \
           libicu \
           libquadmath \
           libtool \
           libtool-ltdl \
           libtool-ltdl-devel \
           libX11-devel \
           libXaw-devel \
           libXext-devel \
           libXft-devel \
           libxml2 \
           libxml2-devel \
           libXmu-devel \
           libXpm \
           libXpm-devel \
           libXt \
           mesa-libGL-devel \
           openssh \
           openssh-server \
           osg-ca-certs \
           osg-wn-client \
           pegasus \
           python3-devel \
           python3-numpy \
           python3-scipy \
           rsync \
           stashcp \
           subversion \
           tcl-devel \
           tcsh \
           time \
           tk-devel \
           wget \
           which

# CA certs
RUN mkdir -p /etc/grid-security && \
    cd /etc/grid-security && \
    rm -rf certificates && \
    wget -nv https://download.pegasus.isi.edu/containers/certificates.tar.gz && \
    tar xzf certificates.tar.gz && \
    rm -f certificates.tar.gz

# Cleaning caches to reduce size of image
RUN dnf clean all

RUN mkdir -p /.singularity.d
COPY osg-labels.json /.singularity.d/labels.json

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

