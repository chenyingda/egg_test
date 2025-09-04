# 设置基础镜像 (建议根据项目需求选择特定 Node.js 版本，保持环境一致)
FROM node:16.20.2-alpine3.18

# 设置容器内的时区（可选）
RUN apk --update add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# 设置环境变量
ENV NODE_ENV=production \
    EGG_SERVER_ENV=prod \
    TZ=Asia/Shanghai

# 创建应用程序工作目录并设置权限
RUN mkdir -p /usr/src/app && \
    chown -R node:node /usr/src/app
WORKDIR /usr/src/app

# 将 package.json 和 package-lock.json (或 npm-shrinkwrap.json) 复制到工作目录
COPY --chown=node:node package*.json npm-shrinkwrap.json* ./

# 以非 root 用户运行增强安全性
USER node

# 安装生产依赖（可使用国内镜像源加速）
RUN npm install --production --registry=https://registry.npmmirror.com/

# 将应用程序源代码复制到工作目录
COPY --chown=node:node . .

# 暴露应用程序端口（Egg.js 默认是 7001）
EXPOSE 7001

# 启动应用（去除 --daemon 参数，保证容器前台运行）:cite[1]:cite[9]
CMD ["npm", "start"]