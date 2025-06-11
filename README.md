# mysql-arm

🚀 适用于ARM架构的Docker MySQL

本镜像基于 `debian:bullseye-slim` 构建，打包了官方 MySQL 5.7.44 的 ARM64 `.deb` 安装包。

---

## 📦 镜像获取

你可以直接构建，或者从 Docker Hub 拉取：

```bash
# 构建镜像（推荐在 ARM64 架构上执行）
git clone https://github.com/yourname/mysql-arm.git
cd mysql-arm
docker build -t mysql-arm:5.7.44 .

# 或直接拉取已有镜像
docker pull chinring/mysql-arm:5.7.44
```

---

## Build

🔧 构建准备
1.获取官方 docker-entrypoint.sh

- 使用官方 MySQL 镜像中的启动脚本：

```bash
docker pull mysql:5.7.44
docker run --name copy mysql:5.7.44
docker cp copy:/usr/local/bin/docker-entrypoint.sh .
docker rm -f copy
```

2.获取 GOSU（ARM64）

- gosu 用于以非 root 用户身份启动服务：

```bash
wget -O gosu "https://github.com/tianon/gosu/releases/download/1.14/gosu-arm64"
chmod +x gosu
```

---

🧱 构建信息

基础镜像：debian:bullseye-slim
架构：arm64
MySQL 版本：5.7.44
安装方式：本地 .deb 包 + 官方 entrypoint 脚本
