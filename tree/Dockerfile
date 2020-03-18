FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive
RUN rm /etc/apt/apt.conf.d/docker-clean
RUN sed 's/archive.ubuntu.com/linux.yz.yamagata-u.ac.jp/' -i /etc/apt/sources.list
RUN apt update
RUN apt install -y wget python-pyqt5 git xvfb
RUN wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b -p ~/anaconda_ete/
RUN ~/anaconda_ete/bin/conda install -y python=2.7
RUN ~/anaconda_ete/bin/conda install -y -c etetoolkit ete3 ete_toolchain
RUN ~/anaconda_ete/ete3 build check

RUN mkdir /root/tree
ADD ./create_tree.py /root/tree
ADD ./create_tree.sh /root/tree

RUN bash /root/tree/create_tree.sh