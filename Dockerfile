# use 
# docker-compose down && docker-compose rm && docker-compose up --build --force-recreate -d && docker build --network host -t ragzinho .
# docker build --network host -t ragzinho .
# docker run -d --network host ragzinho

FROM ubuntu:20.04

ENV db=127.0.0.1 

WORKDIR /server

COPY . /server/

# install dependencies
RUN apt-get update -y && apt-get install build-essential zlib1g-dev libmysqlclient-dev mysql-client -y

# build sql database files
RUN cd tools && ./convert_sql.pl --i=../db/re/item_db.txt --o=../sql-files/item_db_re.sql -t=re --m=item

# import db files
RUN for F in sql-files/*.sql; do mysql -h$db -uragzinho -pragzinho ragzinho< $F; done

# setup server user and gm account
RUN mysql -h$db -uragzinho -pragzinho ragzinho -e 'update login set userid = "server", user_pass = md5("ragzinho") where account_id = 1;'
RUN mysql -h$db -uragzinho -pragzinho ragzinho -e 'insert into `login` (account_id, userid, user_pass, sex, group_id) values (2000000, "gm", md5("ragzinho"), "M", 99);'

RUN ./configure --enable-packetver=20151029
RUN make clean && make server
RUN chmod a+x login-server && chmod a+x char-server && chmod a+x map-server

EXPOSE 6900
EXPOSE 5121
EXPOSE 6121

# RUN ./athena-start start

ENTRYPOINT "tail" "-f" "/dev/null"