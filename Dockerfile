# 基础镜像
FROM debian:bullseye-slim

# 标签
LABEL maintainer="chinring7@gmail.com"

# 设置环境变量
ENV MYSQL_MAJOR=5.7 \
    MYSQL_VERSION=5.7.44 \
    MYSQL_DATADIR=/var/lib/mysql \
    PATH=/usr/local/mysql/bin:$PATH \
    GOSU_VERSION=1.14

# 复制构建所需文件
COPY mysql-arm_5.7.44-1_arm64-slim.deb /tmp/

# 官方启动脚本 docker-entrypoint.sh
# gosu来源 https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-arm64
COPY docker-entrypoint.sh gosu /usr/local/bin/


# 安装依赖
# 创建目录
# 安装deb包并清理不需要的文件减小镜像体积
RUN set -eux && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates wget gnupg dirmngr \
        libaio1 libssl1.1 lsb-release procps tzdata && \
    groupadd -r mysql && useradd -r -g mysql mysql && \
    mkdir -p "$MYSQL_DATADIR" \
        /var/run/mysqld \
        /etc/mysql/conf.d \
        /etc/mysql/mysql.conf.d \
        /var/lib/mysql-files \
        /docker-entrypoint-initdb.d && \
    chown -R mysql:mysql "$MYSQL_DATADIR" \
        /var/run/mysqld \
        /etc/mysql/conf.d \
        /etc/mysql/mysql.conf.d \
        /var/lib/mysql-files \
        /docker-entrypoint-initdb.d && \
    chmod +x /usr/local/bin/gosu && gosu nobody true && \
    apt-get install -y --no-install-recommends ./tmp/mysql-arm_5.7.44-1_arm64-slim.deb && \
    rm -rf \
      /usr/local/mysql/mysql-test \
      /usr/local/mysql/support-files \
      /usr/local/mysql/man \
      /usr/local/mysql/docs \
      /usr/local/mysql/include \
      /usr/local/mysql/lib/libmysqld.a \
      /usr/local/mysql/lib/libmysqlclient.a \
      /usr/local/mysql/lib/libmysqlservices.a \
      /usr/local/mysql/lib/libmysqlclient.so \
      /usr/local/mysql/lib/libmysqlclient.so.20 \
      /usr/local/mysql/lib/libmysqlclient.so.20.* \
      /usr/local/mysql/lib/pkgconfig \
      /usr/local/mysql/share/aclocal \
      /usr/local/mysql/lib/plugin/libtest_* \
      /usr/local/mysql/lib/plugin/ha_example.so \
      /usr/local/mysql/lib/plugin/*.ini \
      /usr/local/mysql/lib/plugin/*example* \
      /usr/local/mysql/lib/plugin/*test* \
      /usr/local/mysql/lib/plugin/*qa_* \
      /tmp/* && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 暴露的端口
EXPOSE 3306 33060

# 启动脚本与启动命令
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld"]
