#!/bin/bash

# 更新系统包索引
sudo apt update

# 安装必要的软件包
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# 添加Docker的官方GPG密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /tmp/docker-archive-keyring.gpg
if [ $? -ne 0 ]; then
  echo "Failed to download and import the Docker GPG key. Please check your internet connection."
  exit 1
fi

# 移动到最终位置
sudo mv /tmp/docker-archive-keyring.gpg /usr/share/keyrings/

# 获取Docker官方公钥ID
DOCKER_OFFICIAL_KEY_ID=$(curl -s https://download.docker.com/linux/ubuntu/gpg | grep "BEGIN PGP PUBLIC KEY BLOCK" | head -n 1 | awk '{print $2}')
# 导入Docker官方公钥
sudo gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys $DOCKER_OFFICIAL_KEY_ID

# 为了提高下载速度，我们也可以添加阿里云的GPG密钥
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo gpg --dearmor -o /tmp/docker-archive-keyring.gpg
if [ $? -ne 0 ]; then
  echo "Failed to download and import the Alibaba Cloud GPG key. Trying with official key only."
else
  # 移动到最终位置
  sudo mv /tmp/docker-archive-keyring.gpg /usr/share/keyrings/

  # 使用阿里云的镜像源
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# 更新包索引
sudo apt update

# 如果出现签名验证失败，重新导入公钥
if [ $? -ne 0 ]; then
  echo "Signature verification failed. Attempting to re-import the key..."
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys $DOCKER_OFFICIAL_KEY_ID
  sudo apt update
fi

# 安装Docker引擎、CLI和containerd
sudo apt install -y docker-ce docker-ce-cli containerd.io

# 启动Docker服务
sudo systemctl start docker

# 检查Docker服务的状态
sudo systemctl status docker

# 开机启动Docker服务
sudo systemctl enable docker

# 获取Docker版本信息
DOCKER_VERSION=$(sudo docker version --format '{{.Server.Version}}')

# 显示安装成功的消息
echo "Docker has been successfully installed!"
echo "Version: $DOCKER_VERSION"
echo "You can now use Docker commands."
