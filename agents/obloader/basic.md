# 命令行选项
OBLOADER/OBDUMPER（简称导数工具）是一款为 OceanBase 数据库量身打造的数据导入导出工具。

OBLOADER 参数设计采用 Unix 和 GNU 两种风格方式。

Unix 风格的参数前加单破折线，选项为单字符，例如 ps -e。该风格的选项和参数之间可以不加空格，例如 -p******。

GNU 风格的长参数前加双破折线，选项为单字符或者字符串，例如 ps --version。要求选项和参数之间有空格，例如 --table 'test'。

## 连接选项（必要）

* -h(--host)：连接 ODP 或 OceanBase 物理节点的主机地址。
* -P(--port)：连接 ODP 或 OceanBase 物理节点的主机端口。
* -u(--user)：连接目标数据库的用户名、租户名和集群名，格式为 `<user>@<tenant>#<cluster>`。
* -f(--file-path)：数据文件所在的目录，支持本地路径、S3、HDFS 等。示例：
  * 本地路径：`-f /home/admin/test`。
  * S3: `-f 's3://bucket/path?region={region}&access-key={accessKey}&secret-key={secretKey}'`
  * HDFS: `-f 'hdfs://***.*.*.*:9000/chang/parquet?hdfs-site-file=/data/0/zeyang/hdfs-site.xml&core-site-file=/data/0/zeyang/core-site.xml`

* -D(--database)：数据导入的目标数据库名称。
* -p(--password)：连接目标数据库的密码。

## 可选参数

### 文件格式

* --csv：导入 CSV 格式的文件。
  * --skip-header：跳过 CSV/CUT 文件的第一行数据，如果 CSV 文件首行是标题时使用。
  * --column-delimiter：指定字符串定界符，默认双引号，用于包裹列字段。
  * --line-separator：指定 CSV/CUT/SQL 文件的行分隔符。
  * --escape-character：指定 CSV/CUT 文件的转义字符（仅支持单字符）。
  * --column-separator：指定 CSV 文件的列分隔字符串。
  * --with-trim：删除 CSV/CUT 数据左右的空格字符。
  * --ignore-unhex：忽略对 CSV/CUT/SQL/Parquet/ORC/DDL 文件的十六进制字符串进行编码（仅适用于二进制数据类型）。
  * --character-set：指定 CSV/CUT/SQL/MIX/Parquet/ORC/DDL 文件中，创建数据库连接时的字符集。
  * --null-string：将 CSV/CUT/SQL 文件中的指定字符做为 NULL 处理。
  * --empty-string：将 CSV/CUT 文件中的指定字符做为空字符处理。
  * --file-suffix：指定 CSV/CUT/SQL/MIX/Parquet/ORC/AVRO/DDL 文件的后缀名。
  * --file-encoding：读取 CSV/CUT/SQL/MIX/Parquet/ORC/DDL 文件时使用的文件编码。
* --cut：导入 CUT 格式的文件。
  * --skip-footer：导入 CUT 文件时跳过文件的最后一行数据。
  * --column-splitter：指定 CUT 文件的列分隔字符串。
  * --trail-delimiter：CUT 文件的数据行是否以分隔符结尾。
  * --ignore-escape：导入 CUT 文件时忽略对字符进行转义操作。
* --sql：导入 SQL 格式的文件。
* --orc：导入 ORC 格式的文件。
* --par：导入 Parquet 格式的文件。
* --mix：导入 MIX 文件。
  * --compat-mode：兼容性导入 MySQL 表结构定义。
* --pos：导入 POS 格式的文件。
* --avro：导入 Avro 格式的文件。
* --ddl：导入 DDL 文件。

### 其他选项

* --truncate-table：导入数据前对目标库中存在数据文件的表进行 Truncate 操作（谨慎使用）。
* --delete-from-table：导入数据前对目标库中存在数据文件的表进行 Delete 操作（谨慎使用）。
* --yes：跳过 `--truncate-table` 或 `--delete-from-table` 参数的二次确认。
* --auto-column-mapping：列名自动映射，支持根据 CSV/Parquet/ORC 源文件的列名和目标表列名进行对应导入，在源文件与目标表列不一致时使用。不可与选项 `--ctl-path` 共同使用。
* --log-path：指定 OBLOADER 运行日志的输出目录。
* --batch：标识批量写入的事务大小，默认值为 200。
* --thread：标识导入任务的并发数，小规格租户应当设为 1。
* --block-size：用于标识文件块的切分阈值，支持的 LONG 数据类型。例如，--block-size 64 表示单个文件大小不超过 64MB。

### 文件匹配规则

* --file-regular-expression <正则表达式>：导入单库单表或单库多表文件时，根据指定的正则表达式导入指定的文件。

OBLOADER 查找需要导入的数据文件的默认规则为 `${table_name}.${seq}.${file_type}`，其中 \${seq} 为可选项。例如：指定 `--csv --table 'table1'`，OBLOADER 将递归查找符合 `table1.${seq}.csv` 规则的文件。又如 `--csv --table '*'`，OBLoader 将查找所有符合 `*.csv` 规则的文件，并将文件名中 `${table_name}` 作为表名导入。

如果需要导入的文件的文件名与表名无关，则应搭配 `--file-regular-expression` 选项指定文件匹配规则，且 `--table` 参数的值必须为具体的表名不能为 '*'。例如，文件名为 `part****.c000.snappy.orc`，可以通过 `--orc --table 'table2' --file-regular-expression '.*.orc'` 命令匹配到以 '.orc' 结尾的所有文件，将其导入至指定的表 table2 中。

### 旁路导入

* --direct：开启旁路导入模式，与 `--direct`, `--parallel` 搭配使用。
* --rpc-port <number>：连接 OBServer RPC 端口, 默认 2885。
* --parallel <number>：旁路导入时加载数据的并行度,一般不用配置。

### 导入经 OBDUMPER 压缩导出的文件

* --compress：是否为经 OBDUMPER 压缩导出的文件。
* --compression-algo：OBDUMPER 压缩导出时的压缩算法。
* --compression-level：OBDUMPER 压缩导出时的压缩等级。

### 数据库对象类型

* --all：导入所有已支持的数据库对象定义和表数据。
* --table：导入表定义或表数据。
* --table-group：导入表组定义。
* --view：导入视图定义。
* --trigger：导入触发器定义。
* --sequence：导入序列定义（仅适用于 OceanBase 数据库 Oracle 兼容模式）。
* --synonym：导入同义词定义（仅适用于 OceanBase 数据库 Oracle 兼容模式）。
* --type：导入类型定义（仅适用于 OceanBase 数据库 Oracle 兼容模式）。
* --type-body：导入类型体定义（仅适用于 OceanBase 数据库 Oracle 兼容模式）。
* --package：导入程序包定义（仅适用于 OceanBase 数据库 Oracle 兼容模式）。
* --package-body：导入程序包包体定义（仅适用于 OceanBase 数据库 Oracle 兼容模式）。
* --function：导入函数定义。
* --procedure：导入存储过程定义。
* --source-type hive：从 Hive 存储路径中识别分区信息进行导入。