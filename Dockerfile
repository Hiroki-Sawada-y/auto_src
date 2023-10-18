# 使用基础镜像
FROM kalilinux/kali-rolling:latest

# 更新包信息
RUN apt-get update

# 安装渗透测试工具和必要软件
RUN apt-get install -y \
    git \
    wget \
    zsh \
    gobuster \
    nmap \
    nikto \
    dirb \
    sqlmap \
    dirsearch \
    cron \
    vim \
    unzip 

# 安装 Go
RUN wget "https://golang.google.cn/dl/go1.21.3.linux-amd64.tar.gz"
RUN tar -C /usr/local -xzf "go1.21.3.linux-amd64.tar.gz"

# 配置 Go 环境变量
ENV PATH=$PATH:/usr/local/go/bin:/home/go/bin
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/go
RUN echo "export PATH=$PATH:/usr/local/go/bin:/home/go/bin" >> /etc/profile

# 设置 Go 代理
RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct

# 安装 Go 工具
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
RUN go install -v github.com/projectdiscovery/notify/cmd/notify@latest
RUN go install -v github.com/tomnomnom/anew@latest
RUN go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest


# 清理不需要的软件包
RUN apt-get autoremove -y

# 切换为 Zsh shell
RUN chsh -s /bin/zsh root

# 添加非root用户并切换到该用户
# RUN useradd -m -s /bin/zsh pentester
# USER pentester

# 创建工作目录并设置为默认目录
WORKDIR /home/src
RUN mkdir xray && cd xray
RUN wget https://github.com/NHPT/Xray_Cracked/releases/download/v1.9.11/xray_linux_amd64
RUn wget https://github.com/NHPT/Xray_Cracked/releases/download/v1.9.11/xray-license.lic
# 添加定时任务以拉取 GitHub 项目
RUN cd /home/src && git clone https://github.com/Hiroki-Sawada-y/auto_src
RUN (crontab -l ; echo "0 6 * * * cd /home/src/auto_src && git pull https://github.com/Hiroki-Sawada-y/auto_src ") | crontab -



# xscan
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y wine32
RUN mkdir /home/src/xscan
COPY xscan.zip /home/src/xscan
RUN unzip xscan.zip


# 启动 
CMD ["cron", "-f"]

# 启动 Zsh shell
CMD ["zsh"]

