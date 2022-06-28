# This is a fork from [rAthena](github.com/rathena/rathena) with Docker and some sample terraform code

### Ragzinho Infra
- [x] user data to enable docker without sudo
- user data to mount EBS volume
> is it ready when instance is building?
- [x] elastic IP
- [x] enable flow from all UDP and TCP necessary ports
- test EBS volume to have consistent records in DB in docker path (since mariadb normally will save in root directory)

### Server configuration
Install other pre-requisites

    sudo apt-get update -y
    sudo apt-get install build-essential mysql-server zlib1g-dev libmysqlclient-dev -y
    
Secure mysql installation

    sudo mysql_secure_installation
    
Git clone the repo, then access it

    git clone https://github.com/rathena/rathena.git ~/rAthena
    cd rAthena
    
Build the latest .sql files

    cd tools
    ./convert_sql.pl --i=../db/re/item_db.txt --o=../sql-files/item_db_re.sql -t=re --m=item

### MySQL Installation
    sudo su
    mysql -p
    mysql> CREATE DATABASE (your ragnarok database name);
    mysql> CREATE USER 'sammy'@'localhost' IDENTIFIED BY 'password';
    mysql> GRANT ALL ON yourragnarokdatabasename.* TO yourdatabaseusername@localhost;
    myqsl> exit
    
Import mysql database

    for F in sql-files/*.sql; do mysql -u yourragnarokusername -p yourragnarokdatabasename < $F; done
    
Change default server password

    update login set userid = "server", user_pass = md5("secret") where account_id = 1;

Create gm account

    insert into `login` (account_id, userid, user_pass, sex, group_id) values (2000000, "gm", md5("secret"), "M", 99);
    
### Iptables configuration
    -A INPUT -p udp --dport 6900 -m state --state NEW -j ACCEPT
    -A INPUT -p udp --dport 5121 -m state --state NEW -j ACCEPT
    -A INPUT -p udp --dport 6121 -m state --state NEW -j ACCEPT
    -A INPUT -p tcp --dport 6900 -m state --state NEW -j ACCEPT
    -A INPUT -p tcp --dport 5121 -m state --state NEW -j ACCEPT
    -A INPUT -p tcp --dport 6121 -m state --state NEW -j ACCEPT
    
### Connectivity Configuration
Edit conf/inter_athena.conf with following configuration:

    // MySQL Login server
    login_server_ip: 127.0.0.1
    login_server_port: 3306
    login_server_id: ragnarok
    login_server_pw: ragnarok
    login_server_db: ragnarok
    login_codepage:
    login_case_sensitive: no

    ipban_db_ip: 127.0.0.1
    ipban_db_port: 3306
    ipban_db_id: ragnarok
    ipban_db_pw: ragnarok
    ipban_db_db: ragnarok
    ipban_codepage:
    
    // MySQL Character server
    char_server_ip: 127.0.0.1
    char_server_port: 3306
    char_server_id: ragnarok
    char_server_pw: ragnarok
    char_server_db: ragnarok
    
    // MySQL Map Server
    map_server_ip: 127.0.0.1
    map_server_port: 3306
    map_server_id: ragnarok
    map_server_pw: ragnarok
    map_server_db: ragnarok
    
    // MySQL Log Database
    log_db_ip: 127.0.0.1
    log_db_port: 3306
    log_db_id: ragnarok
    log_db_pw: ragnarok
    log_db_db: ragnarok
    log_codepage:
    log_login_db: loginlog
    
Next conf/import/char_conf.txt:

    userid: server
    passwd: password
    login_ip: 127.0.0.1
    map_ip: 127.0.0.1

Next conf/import/map_conf.txt

    userid: server
    passwd: password
    char_ip: 127.0.0.1
    login_ip: 127.0.0.1

Next conf/import/login_conf.txt

    userid: server
    passwd: password
    map_ip: 127.0.0.1
    char_ip: 127.0.0.1
    use_MD5_passwords: yes

Next conf/map_athena.conf
    
    userid: s1
    psswd: p1

Next conf/char_athena.conf
    
    userid: s1
    psswd: p1

Configure server

    ./configure --enable-packetver=20150620 (clientversion)
    make server
    chmod a+x login-server && chmod a+x char-server && chmod a+x map-server
 
 How to recompile
 
    make clean && make server
    
### How to start
 To Start:
 
    ./athena-start start

To Stop:

    ./athena-start stop

To Restart:

    ./athena-start restart
    
## Client configuration
Download kRO, client, Nemo, and Translation
[translation](https://github.com/llchrisll/ROenglishRE)
[Nemo](https://github.com/motizukilucas/Nemo)

Run form kRO folder
    rsu-kro-renewal-lite.exe

Get the data/ and System/ folder from ROenglish and place the texture from basci texture inside data/ folder

Open Nemo, browse to the 2015 client, then click Load Client 
Select recommended
Make sure this options are selected in Nemo

    Disable 1rag1 type parameters
    Disable game guard
    Fixes the Korean Job name
    Translate Client
    *Use Ragnarok Icon*
    *Read data folder first*

On GRF editor click open file data.grf from kRO folder and add this to clientinfo.xml

    <?xml version="1.0" encoding="euc-kr" ?>
    <clientinfo>
        <desc>Private Server Description</desc>
        <servicetype>korea</servicetype>
        <servertype>primary</servertype>
        <connection>
            <display>ragzinho</display>
              <address>127.0.0.1</address>
              <port>6900</port>
              <version>54</version>
              <langtype>1</langtype>
            <registrationweb>www.ragnarok.com</registrationweb>
            <loading>
                <image>loading00.jpg</image>
                <image>loading01.jpg</image>
                <image>loading02.jpg</image>
                <image>loading03.jpg</image>
                <image>loading04.jpg</image>
            </loading>
            <yellow>
                <admin>2000000</admin>
            </yellow>
           </connection>
    </clientinfo>

## AWS Lightsail deployment
* Enable these as TCP & UDP ports 5121, 6121 & 6900

* Also create an static public IP for your instance

<img src="doc/logo.png" align="right" height="90" />

# rAthena
[![Build Status](https://travis-ci.org/rathena/rathena.png?branch=master)](https://travis-ci.org/rathena/rathena) [![Build status](https://ci.appveyor.com/api/projects/status/8574b8nlwd57loda/branch/master?svg=true)](https://ci.appveyor.com/project/rAthenaAPI/rathena/branch/master) [![Total alerts](https://img.shields.io/lgtm/alerts/g/rathena/rathena.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/rathena/rathena/alerts/) [![Language grade: C/C++](https://img.shields.io/lgtm/grade/cpp/g/rathena/rathena.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/rathena/rathena/context:cpp) ![GitHub](https://img.shields.io/github/license/rathena/rathena.svg) ![GitHub repo size](https://img.shields.io/github/repo-size/rathena/rathena.svg)
> rAthena is a collaborative software development project revolving around the creation of a robust massively multiplayer online role playing game (MMORPG) server package. Written in C, the program is very versatile and provides NPCs, warps and modifications. The project is jointly managed by a group of volunteers located around the world as well as a tremendous community providing QA and support. rAthena is a continuation of the eAthena project.

[Forum](https://rathena.org/board)|[Discord](https://rathena.org/discord)|[Wiki](https://github.com/rathena/rathena/wiki)|[FluxCP](https://github.com/rathena/FluxCP)|[Crowdfunding](https://rathena.org/board/crowdfunding/)|[Fork and Pull Request Q&A](https://rathena.org/board/topic/86913-pull-request-qa/)
--------|--------|--------|--------|--------|--------

### Table of Contents
- [rAthena](#rathena)
    - [Table of Contents](#table-of-contents)
  - [1. Prerequisites](#1-prerequisites)
    - [Hardware](#hardware)
    - [Operating System & Preferred Compiler](#operating-system--preferred-compiler)
    - [Required Applications](#required-applications)
    - [Optional Applications](#optional-applications)
  - [2. Installation](#2-installation)
    - [Full Installation Instructions](#full-installation-instructions)
  - [3. Troubleshooting](#3-troubleshooting)
  - [4. More Documentation](#4-more-documentation)
  - [5. How to Contribute](#5-how-to-contribute)
  - [6. License](#6-license)

## 1. Prerequisites
Before installing rAthena there are certain tools and applications you will need which
differs between the varying operating systems available.

### Hardware
Hardware Type | Minimum | Recommended
------|------|------
CPU | 1 Core | 2 Cores
RAM | 1 GB | 2 GB
Disk Space | 300 MB | 500 MB

### Operating System & Preferred Compiler
Operating System | Compiler
------|------
Linux  | [gcc-5 or newer](https://www.gnu.org/software/gcc/gcc-5/) / [Make](https://www.gnu.org/software/make/)
Windows | [MS Visual Studio 2013, 2015, 2017](https://www.visualstudio.com/downloads/)

### Required Applications
Application | Name
------|------
Database | [MySQL 5 or newer](https://www.mysql.com/downloads/) / [MariaDB 5 or newer](https://downloads.mariadb.org/)
Git | [Windows](https://gitforwindows.org/) / [Linux](https://git-scm.com/download/linux)

### Optional Applications
Application | Name
------|------
Database | [MySQL Workbench 5 or newer](http://www.mysql.com/downloads/workbench/)

## 2. Installation 

### Full Installation Instructions
  * [Windows](https://github.com/rathena/rathena/wiki/Install-on-Windows)
  * [CentOS](https://github.com/rathena/rathena/wiki/Install-on-Centos)
  * [Debian](https://github.com/rathena/rathena/wiki/Install-on-Debian)
  * [FreeBSD](https://github.com/rathena/rathena/wiki/Install-on-FreeBSD)
    
## 3. Troubleshooting

If you're having problems with starting your server, the first thing you should
do is check what's happening on your consoles. More often that not, all support issues
can be solved simply by looking at the error messages given. Check out the [wiki](https://github.com/rathena/rathena/wiki)
or [forums](https://rathena.org/forum) if you need more support on troubleshooting.

## 4. More Documentation
rAthena has a large collection of help files and sample NPC scripts located in the /doc/
directory. These include detailed explanations of NPC script commands, atcommands (@),
group permissions, item bonuses, and packet structures, among many other topics. We
recommend that all users take the time to look over this directory before asking for
assistance elsewhere.

## 5. How to Contribute
Details on how to contribute to rAthena can be found in [CONTRIBUTING.md](https://github.com/rathena/rathena/blob/master/.github/CONTRIBUTING.md)!

## 6. License
Copyright (c) rAthena Development Team - Licensed under [GNU General Public License v3.0](https://github.com/rathena/rathena/blob/master/LICENSE)
