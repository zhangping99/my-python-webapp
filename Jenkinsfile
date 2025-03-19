pipeline {
    agent any  // 使用任何可用的 Jenkins 节点

    stages {
        stage('Checkout') {
            steps {
                // 从 Git 仓库检出代码
                git 'https://github.com/zhangping99/my-python-webapp.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                // 安装依赖
                sh 'python3 -m pip install -r requirements.txt'
            }
        }

        stage('Run Tests') {
            steps {
                // 运行单元测试
                sh 'python3 -m unittest discover -s tests'
            }
        }

        stage('Deploy') {
            steps {
                // 执行部署脚本
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
            }
        }
    }

    post {
        always {
            // 清理工作空间
            cleanWs()
        }
    }
}
