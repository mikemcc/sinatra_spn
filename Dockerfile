FROM ubuntu:16.04 

LABEL maintainer="mmccafferty@marketron.com"

RUN apt-get update
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential monit nmap logrotate zlib1g-dev libpq-dev libreadline-dev libv8-dev nodejs unattended-upgrades libssl-dev rbenv ruby-build
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y logrotate zlib1g-dev libpq-dev libreadline-dev libv8-dev unattended-upgrades libssl-dev git

# the following are necessary to install ruby via rbenv
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev curl


RUN adduser --disabled-password --gecos 'Marketron' marketron

WORKDIR /home/marketron
USER marketron

# NVM
RUN [ -d .nvm ] || git clone https://github.com/creationix/nvm.git .nvm
WORKDIR /home/marketron/.nvm
RUN git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
WORKDIR /home/marketron
RUN grep 'HOME/.nvm' .bashrc || echo 'NVM_DIR="$HOME/.nvm"' >> .bashrc
RUN grep 'NVM_DIR/nvm.sh' .bashrc || echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" ' >> .bashrc

# RBENV
WORKDIR /home/marketron
RUN git clone https://github.com/sstephenson/rbenv.git .rbenv
RUN mkdir .rbenv/plugins
RUN  git clone https://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build

RUN grep '.rbenv/bin' .bashrc || echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> .bashrc
RUN grep 'rbenv init' .bashrc || echo 'eval "$(rbenv init -)"' >> .bashrc
ENV RBENV_ROOT=/home/marketron/.rbenv
RUN tail -10 .bashrc
RUN /bin/bash -c "source /home/marketron/.bashrc && /home/marketron/.rbenv/bin/rbenv versions | grep 2.5.3 || /home/marketron/.rbenv/bin/rbenv install 2.5.3"
RUN /bin/bash -c "source /home/marketron/.bashrc && /home/marketron/.rbenv/bin/rbenv local 2.5.3 && /home/marketron/.rbenv/versions/2.5.3/bin/gem install bundler"
COPY myapp.rb /home/marketron/myapp.rb
RUN PATH=$PATH:/home/marketron/.rbenv/bin:/home/marketron/.rbenv/shims
RUN /bin/bash -c "source /home/marketron/.bashrc && /home/marketron/.rbenv/bin/rbenv local 2.5.3 && /home/marketron/.rbenv/versions/2.5.3/bin/gem install --no-ri --no-rdoc sinatra"

RUN export PATH=$PATH:/home/marketron/.rbenv/bin:/home/marketron/.rbenv/shims

ENTRYPOINT ["/home/marketron/.rbenv/shims/ruby","./myapp.rb", " -b 0.0.0.0" ]

