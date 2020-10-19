# cs527

## http://18.211.73.183:5000/

----

## Data Region
`us-east-1`

## 访问 AWS 上的 RDS

[Connecting to a DB instance running the MySQL database engine](https://docs.amazonaws.cn/en_us/AmazonRDS/latest/UserGuide/USER_ConnectToInstance.html)

>PS. 假如实在连不上去，security group rules那里编辑inbound rules和outbound rules

## 在 AWS 上，S3 数据桶上的数据导入 RDS

> 本来想尝试使用 pipeline，结果可能是因为 S3 在 `us-east-2` 但是 RDS 在 `us-east-1`，总之是一直出现未知错误，显示 `ec2 instance not able to establish a connection to RDS`，目前暂无解决方法
> - [连接方式](https://medium.com/@frantzdyromain/how-to-set-up-aws-data-pipeline-for-the-first-time-a-visual-guide-4b3d16310b90)

所以以下提供两种方法：

1. 针对少量数据

    Python 3 访问 S3 数据（bytes buffer str），decode 得到 str，根据格式拆分成 list 存储，然后使用 SQL 逐行插入到 RDS 上创建好的数据表

    需要 ***创建本地 AWS 凭证文件*** 并依赖 Python 3 `boto3`

    > 参考：\
    [创建本地 AWS 凭证文件](https://www.shuzhiduo.com/A/B0zqKPZQ5v/) 这里需要先在 [IAM](https://console.aws.amazon.com/iam/home?region=us-east-1#/users) 上创建 `Users` 并且配置权限\
    [Python3 boto3 简单 demo](https://www.jianshu.com/p/515439142d73)

    ```txt
    // AWS 凭证示例:
    // ~/.aws/credentials on Linux/Mac OS
    // $Home_Path$/.aws/credentials on Windows

    [default]
    aws_access_key_id = AKIA3VE67DXXXXXXXXXX
    aws_secret_access_key = +SBaSp2Weix8GLELHJOLBnlTIRNXcnXXXXXXXXXX
    ```

2. 针对大量数据

    *Python 3 访问 S3 数据 并使用 SQL 插入* 需要网络请求，导入数据的速度很慢（本地环境 1 秒只能 INSERT 2 条数据），所以：

    创建 `ec 2 instance`，使用 `LOAD` 语句从 `ec 2 instance`服务器上直接导入 *.csv* 文件到 RDS 上

    1. 创建 `public Key Pairs` 并在创建 `ec 2 instance` 实例的时候关联你的 `public Key Pairs`:

        [how to do with ec 2 key pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair)

        > 我的做法\
            1. 打开 [ec 2 home](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Home:)\
            2. 点击左侧菜单栏 `Network & Security` . `Key Pairs` 创建\
            3. 保存到本地 `.pem` 文件
            4. 创建 `ec 2 instance` 的时候关联我的 `public Key Pairs`

    2. `ssh` 连接你的 `ec 2 instance` 并用 `scp` 命令把本地数据传输到服务器上:

        > [连接及传输方式](https://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)\
        [获取 ec 2 实例信息](https://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/connection-prereqs.html#connection-prereqs-get-info-about-instance)

        ```bash
        # 示例
        # connect ec 2
        chmod 400 ~/Downloads/CS527EC2iOS.pem
        ssh -i "~/Downloads/CS527EC2iOS.pem"  ec2-user@ec2-18-211-73-183.compute-1.amazonaws.com 

        # transfer files
        scp -i "~/Downloads/CS527EC2iOS.pem" ~/Downloads/products.csv  ec2-user@ec2-18-211-73-183.compute-1.amazonaws.com :~
        ```

    3. 在 `ec 2 instance` 上安装并启动 **MySQL 客户端**:

        ```bash
        # 示例
        # install MySQL
        sudo yum install mysql-server
        sudo chkconfig mysqld on
        sudo service mysqld start

        # login into RDS
        mysql -u admin -p instacart -h cs527project1group5.cnpt9dsbfddc.us-east-1.rds.amazonaws.com
        mysql -u admin -p abc_retail -h cs527project1group5.cnpt9dsbfddc.us-east-1.rds.amazonaws.com
        ```

    4. 在 `ec 2 instance` 上的 **MySQL 客户端** 创建表并上传 `.csv` 数据:

        ```sql
        # 示例
        # create table
        CREATE TABLE order_products (
            order_id INT NOT NULL,
            product_id INT NOT NULL,
            add_to_cart_order INT NOT NULL,
            reordered INT NOT NULL,
            PRIMARY KEY ( product_id, order_id ),
            CONSTRAINT opd_pidfk_1 FOREIGN KEY (product_id) REFERENCES products(product_id),
            CONSTRAINT opd_oidfk_1 FOREIGN KEY (order_id) REFERENCES orders(order_id)
        );

        # load into RDS
        LOAD DATA LOCAL INFILE '~/order_products.csv' INTO TABLE order_products FIELDS TERMINATED BY ',' ENCLOSED BY '"' IGNORE 1 LINES;
        ```

## 在 AWS 上，S3 数据桶上的数据导入 RedShift 数据仓库

1. 新建一个免费的 `RedShift` CLUSTERS（依照 AWS 的文档配置就好）

2. [Tutorial: Loading data from Amazon S3](https://docs.aws.amazon.com/redshift/latest/dg/tutorial-loading-data.html)
> 数据在 `./S3toRedShift` 里

例子：
```sql
copy abc_retail.raws from 's3://abcretailforcs527/load/ABC_Retail' 
credentials 'aws_access_key_id=AKIA3VE67DXXXXXXXXXX;aws_secret_access_key=+SBaSp2Weix8GLELHJOLBnlTIRNXcnXXXXXXXXXX' 
delimiter ','
DATEFORMAT 'YYYY-MM-DD HH24:MI:SS'
csv;
```

## Flask 程序在 `ec 2 instance` 服务器上的部署

[通过Gunicorn部署flask应用（阿里云服务器：Ubuntu 16.04）](https://juejin.im/post/6844903550342922248)

```bash
# 示例
gunicorn -w 4 -b 172.31.94.236:5000 ~/cs527/app:app
```
- `gunicorn` 添加的是私有 IP，外部访问公有 IP
