FROM vnmd/neurodesktop:20230728

USER root

# Update package list and install necessary dependencies
RUN apt-get update -y && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker repository
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update package list again and install Docker
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends && \
    apt-get install -y docker-ce python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# This step might require a container restart to take effect
RUN usermod -aG docker ${NB_USER}

# Install python requirements
ADD requirements.txt /ais-requirements.txt
RUN pip install -r /ais-requirements.txt
RUN rm /ais-requirements.txt

USER ${NB_USER}

RUN echo "export XNAT4TESTS_HOME=/home/${NB_USER}/xnat4tests" >> ~/.bashrc
