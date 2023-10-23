FROM osrf/ros:melodic-desktop-full-bionic
# The OSRF ROS Melodic containers use the root user.
# Therefore, the following commands are executed as root up until the
# USER user statement.

# We love UTF!
ENV LANG C.UTF-8

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Set the nvidia container runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN set -x \
        && apt-get update \
        && apt-get upgrade -y  \
        && apt-get install -y libprotobuf-dev protobuf-compiler \
        && apt-get install -y python3 python3-pip \
        && apt-get install -y tmux \
        && rm -rf /var/lib/apt/lists/*

RUN set -x \
	&& apt-get update \
	&& apt-get --with-new-pkgs upgrade -y \
	&& apt-get install -y mesa-utils \ 
	&& apt-get install -y iputils-ping \ 
	&& apt-get install -y apt-transport-https ca-certificates \
	&& apt-get install -y openssh-server python-pip exuberant-ctags \
	&& apt-get install -y git vim tmux nano htop sudo curl wget gnupg2 \
    && apt-get install -y lsb-release bash-completion \
    && apt-get install -y ros-melodic-desktop-full \
    && apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential \
    && apt-get install -y ros-melodic-turtlebot3* \
    && apt-get install -y ros-melodic-gmapping \
    && apt-get install -y python-rosdep \
    && apt-get autoremove -y \
    && pip install powerline-shell \
    && rm -rf /var/lib/apt/lists/* 

RUN useradd -ms /bin/bash user \
    && echo "user:user" | chpasswd && adduser user sudo \
    && usermod -aG audio user
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY ./scripts/init_commands.sh /scripts/init_commands.sh
RUN ["chmod", "+x", "/scripts/init_commands.sh"]


STOPSIGNAL SIGTERM

USER user
WORKDIR /home/user

RUN git clone https://github.com/jimeh/tmux-themepack.git ~/.tmux-themepack  \
        && git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux-resurrect
COPY --chown=user:user ./.tmux.conf /home/user/.tmux.conf
COPY --chown=user:user ./.powerline.sh /home/user/.powerline.sh

# Set some decent colors if the container needs to be accessed via /bin/bash.
RUN echo LS_COLORS=$LS_COLORS:\'di=1\;33:ln=36\' >> ~/.bashrc \
        && echo export LS_COLORS >> ~/.bashrc \
        && echo 'source ~/.powerline.sh' >> ~/.bashrc \
        && echo 'alias tmux="tmux -2"' >> ~/.bashrc \
        && echo 'PATH=~/bin:~/.local/bin:$PATH' >> ~/.bashrc \
        && touch ~/.sudo_as_admin_successful # To surpress the sudo message at run.

RUN sudo usermod -a -G video user

RUN rosdep update \
        && echo "source /opt/ros/melodic/setup.bash" >> /home/user/.bashrc

RUN mkdir -p /home/user/Projects/turtlebot3_extra_ws/src 
WORKDIR /home/user/Projects/turtlebot3_extra_ws/src
COPY --chown=user:user ./m-explore.tar.gz /home/user/Projects/turtlebot3_extra_ws/src/m-explore.tar.gz
RUN tar xzvf ./m-explore.tar.gz && rm ./m-explore.tar.gz
COPY --chown=user:user ./turtlebot3_mas_teleop.tar.gz /home/user/Projects/turtlebot3_extra_ws/src/turtlebot3_mas_teleop.tar.gz
RUN tar xzvf ./turtlebot3_mas_teleop.tar.gz && rm ./turtlebot3_mas_teleop.tar.gz
WORKDIR /home/user/Projects/turtlebot3_extra_ws/
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd /home/user/Projects/turtlebot3_extra_ws; catkin_make'
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd /home/user/Projects/turtlebot3_extra_ws; catkin_make'
RUN echo "source /home/user/Projects/turtlebot3_extra_ws/devel/setup.bash --extend" >> /home/user/.bashrc

WORKDIR /home/user
RUN mkdir -p Projects/catkin_ws/src 
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd /home/user/Projects/catkin_ws; catkin_make'
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd /home/user/Projects/catkin_ws; catkin_make'

RUN echo "source /home/user/Projects/catkin_ws/devel/setup.bash --extend" >> /home/user/.bashrc