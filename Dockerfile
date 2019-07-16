FROM ubuntu:bionic

RUN apt-get update && \
    echo 'alias ll="ls -la"' >> ~/.bashrc && \
    apt-get install -y curl 

# install kubectl
RUN cd ~ && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# install powershell on Ubuntu 18.04
RUN apt-get install -y software-properties-common && \
    cd ~ && \
    curl -LO https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell

# install Az
RUN pwsh -Command "& {Install-Module -Name Az -AllowClobber -Force}"

# install AZ CLI
RUN cd ~ && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# install git
# RUN apt-get install -y git

COPY ./scripts /home/scripts

RUN pwsh -Command "& {Register-PackageSource -Name MyNuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet}"
RUN pwsh -Command "& {Install-Package Microsoft.ApplicationInsights -Force}"
RUN chmod +x /home/scripts/RunPwsh-Backups.sh
ENTRYPOINT [ "/bin/bash" ]
CMD ["/home/scripts/RunPwsh-Backups.sh"]
