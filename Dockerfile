# @Author: wang xue
# @Description:

# ------------------------- step 1: build dist folder -------------------------

# FROM: 指定基础镜像
FROM node:10.16.0-alpine as build
# ARG 构建参数
ARG ENV=''
# WORKDIR 指定工作目录
WORKDIR /usr/src/app
# COPY 复制文件
COPY ["package.json", "/usr/src/app/"]
# RUN 执行命令
RUN npm install --silent
# COPY . . 指镜像中工作目录从当前目录拷贝
COPY . .
# RUN 执行命令
RUN npm run build-${ENV}




# ------------------------- step 2: copy static files to nginx image -------------------------

# FROM 指定基础镜像
FROM nginx:alpine
# ARG 构建参数
ARG ENV=''
# EXPOSE 声明端口
EXPOSE 80
# COPY 复制文件
COPY nginx/gzip.conf /etc/nginx/conf.d/gzip.conf
COPY nginx/default-${ENV}.conf /etc/nginx/conf.d/default.conf
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
