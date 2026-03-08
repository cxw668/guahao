项目启动

## 1. 环境准备
mysql + redis + nodejs 20+

## 2. 启动步骤
- 数据库：启动本地mysql redis服务
  - mysql本地安装后，在任务管理器选择mysql服务启动
  - redis安装后，本地使用命令行redis-cli启动
 
- Java环境 jdk17
  - IDE打开项目，选择admin包启动，前端在vue3模块下使用npm dev启动
  - 注意：版本依赖需要对应，否则可能无法启动项目
 
- 数据库初始化
  - 项目目录下init_sql，使用数据库可视化工具或者IDE导入脚本来初始化数据库，首先需要创建本地数据库，CREATE DATABASE ruoyi_hospital DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  - 导入上面的初始化脚本

## 3. 测试
- 测试账号admin admin123
- 只要可以登录，那么代表项目启动成功
