# dockerfile template
#
# VERSION               0.0.1

FROM      ubuntu:16.04
LABEL     maintainer="allen7575@gmail.com"

##
## Ubuntu - Packages - Search
## https://packages.ubuntu.com/search?suite=xenial&section=all&arch=amd64&searchon=contents&keywords=Search
##

############
# update package list and upgrade
############
# E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing? - Ask Ubuntu
# https://askubuntu.com/questions/364404/e-unable-to-fetch-some-archives-maybe-run-apt-get-update-or-try-with-fix-mis
RUN apt update && apt upgrade -y && apt-get clean

##############################
#########################
## install packages
#########################
##############################

############
# put something here...
############

##########
# install vim
##########
RUN apt install -y vim

# Ubuntu Missing dependencies? · Issue #92 · electron-userland/electron-prebuilt
# https://github.com/electron-userland/electron-prebuilt/issues/92
RUN apt install -y fuse libgtk2.0-0 libnss3 libgtk-3-0 libasound2

# Failed to load module “canberra-gtk-module” .... but already installed - Ask Ubuntu
# https://askubuntu.com/questions/342202/failed-to-load-module-canberra-gtk-module-but-already-installed
# 
# missing libgobject-2.0.so.0 error on Kubuntu 16.10 - Ask Ubuntu
# https://askubuntu.com/questions/892578/missing-libgobject-2-0-so-0-error-on-kubuntu-16-10
RUN apt install -y libcanberra-gtk-module libcanberra-gtk3-module

# Tray | Electron
# https://electronjs.org/docs/api/tray
# On Linux distributions that only have app indicator support, you have to install libappindicator1 to make the tray icon work.
RUN apt install -y libappindicator1

# Tray icon on Ubuntu is missing · Issue #765 · mattermost/desktop
# https://github.com/mattermost/desktop/issues/765
RUN apt install -y libgtk2-appindicator-perl

# linux - Dropbox system tray icon missing, not working - Super User
# https://superuser.com/questions/1037769/dropbox-system-tray-icon-missing-not-working
RUN apt install -y dbus-x11


# install desktop-file-utils and xdg icon resource
# http://cgit.freedesktop.org/xdg/desktop-file-utils/
RUN apt install -y xdg-utils
RUN apt install -y desktop-file-utils


##############################
#########################
## modify configuration
#########################
##############################

############
# put something here...
############

############
# add, change username,password,group here
############
# change root password
# RUN echo root:root | chpasswd

# add guest user
# useradd - Ubuntu 14.04: New user created from command line has missing features - Ask Ubuntu
# https://askubuntu.com/questions/643411/ubuntu-14-04-new-user-created-from-command-line-has-missing-features
# RUN useradd -m guest -s /bin/bash && \
#     echo guest:guest | chpasswd

# grant access for guest to video device
# RUN usermod -a -G video guest `# grant access to video device`

##############
##########
# setup chinese locale
##########
##############

# How to set the locale inside a Ubuntu Docker container? - Stack Overflow
# https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-ubuntu-docker-container

# install locales package
RUN apt-get -y install locales

# Set the locale
#RUN sed -i -e 's/# zh_TW.UTF-8 UTF-8/zh_TW.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

RUN locale-gen zh_TW.UTF-8 zh_CN.UTF-8

##########
# docker 学习 - 解决ubuntu镜像中文乱码问题 - 简书
# https://www.jianshu.com/p/43a3468362aa
##########
# set locale env
#
# 通常设置`LANG、LANGUAGE、LC_ALL`这三个就行了。
# 关于他们三的关系简言之：
# LANG默认设置，LC_*没设值的时候就拿LANG；
# LANGUAGE是程序语言设置；
# LC_ALL强制设置所有LC_*
# 详细传送门： [https://blog.csdn.net/nick357/article/details/8513699]
ENV LANG zh_TW.UTF-8
ENV LANGUAGE zh_TW.UTF-8
ENV LC_ALL zh_TW.UTF-8

# 输入 `locale -a` ，查看一下现在已安装的语言，已经有`C.UTF-8`字符集
# RUN locale -a
# 输入 `locale` 查看下语言情况，显示语言不正确。
# RUN locale

########
# 在 x64 Linux 桌面利用 Docker 技術進行「稅額試算服務線上登錄」作業 « Jamyy's Weblog
# http://jamyy.us.to/blog/2015/05/7408.html
########
# 安装文泉驿微米黑字体
# install chinese font
RUN apt-get -y install ttf-wqy-microhei

########
# Docker容器时区设置与中文字符支持 - 倚楼听风雨 - SegmentFault 思否
# https://segmentfault.com/a/1190000005026503
########
# Set the timezone.
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



# change password with username:password
RUN echo root:root | chpasswd

# add guest user
# useradd - Ubuntu 14.04: New user created from command line has missing features - Ask Ubuntu
# https://askubuntu.com/questions/643411/ubuntu-14-04-new-user-created-from-command-line-has-missing-features
#
# You should run the command in the following manner:
# sudo useradd -m sam -s /bin/bash
#
#  -s, --shell SHELL
#       The name of the user's login shell.
#  -m, --create-home
#       Create the user's home directory if it does not exist.
#
RUN useradd -m guest -s /bin/bash && \
    echo guest:guest | chpasswd 

# grant access for guest to video device
RUN usermod -a -G video guest `# grant access to video device`

USER guest 
ENV HOME /home/guest 
ENV USER guest 

# change user
USER root

##############################
#########################
## cleanup image
#########################
##############################

##############
# upgrade
##############
# RUN apt upgrade -y



##############
# cleanup
##############
# debian - clear apt-get list - Unix & Linux Stack Exchange
# https://unix.stackexchange.com/questions/217369/clear-apt-get-list
#
# bash - autoremove option doesn't work with apt alias - Ask Ubuntu
# https://askubuntu.com/questions/573624/autoremove-option-doesnt-work-with-apt-alias
#
# RUN apt-get autoremove && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

##############################
#########################
## run commands when image start
#########################
##############################

#################
# initial script
#################

# docker - Dockerfile copy keep subdirectory structure - Stack Overflow
# https://stackoverflow.com/questions/30215830/dockerfile-copy-keep-subdirectory-structure
COPY ./scripts/ /scripts/

# starting container process caused "exec: \"./extra/service_startup.sh\": permission denied" · Issue #431 · facebook/fbctf
# https://github.com/facebook/fbctf/issues/431
RUN chmod +x /scripts/*

# dockerfile - How do I Docker COPY as non root? - Stack Overflow
# https://stackoverflow.com/questions/44766665/how-do-i-docker-copy-as-non-root
RUN chown -R guest:guest /scripts/*


ENTRYPOINT ["/scripts/init.sh"]

CMD ["bash"]