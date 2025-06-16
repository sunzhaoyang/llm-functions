### 存储路径

* --ctl-path：控制文件存放在本地磁盘的绝对路径。请勿同时配置 `--ctl-path` 和 `--auto-column-mapping`。

### 时间戳格式

* --nls-date-format：设置 OceanBase 数据库 Oracle 兼容模式下数据库连接中的日期格式。默认值为 `YYYY-MM-DD HH24:MI:SS`。
* --nls-timestamp-format：设置 OceanBase 数据库 Oracle 兼容模式下数据库连接中的时间戳格式。默认值为 `YYYY-MM-DD HH24:MI:SS:FF9`。
* --nls-timestamp-tz-format：设置 OceanBase 数据库 Oracle 兼容模式下数据库连接中包含时区的时间戳格式。默认值为 `YYYY-MM-DD HH24:MI:SS:FF9 TZR`。

### 黑白名单筛选

* --exclude-table：导入表定义或表数据时，排除指定的表。
* --exclude-data-types：导入数据时，排除指定的数据类型。
* --exclude-column-names：排除导入时指定的列名对应的数据。
   <main id="notice" type='notice'>
   <h4>注意</h4>
   <ul>
   <li>
   <p>指定的列名需要与表结构中的列名大小写保持一致。</p>
   </li>
   <li>
   <p>导入的数据文件中，被排除的列无对应的数据，并且被导入的列顺序与表中列顺序需要保持一致。</p>
   </li>
   </main>

### 错误处理

* --max-discards：指定每一张表的重复数据的最大值，仅在表中包含主键或唯一键且数据出现重复时生效。默认值为 -1。
* --retry：导入任务从中断点进行重试。
* --max-errors：指定导入时，每一张表允许的最多错误次数。默认值为 1000。
* --strict：导入时控制脏数据对进程结束状态的影响。与 `--max-discards` 或 `--max-errors` 搭配使用，表示当重复数据量或错误次数在指定范围内，会跳过错误继续进程。
* --replace-data：替换表中重复的数据，仅适用于有主键或有唯一键（包含非空字段）的表。

### 性能选项

* --rw：标识文件解析线程占总线程数的比例，默认值为 1。
* --slow：标识触发导数工具慢速导入的阈值，默认值为 0.75。
* --pause：标识触发导数工具自动停止导入的阈值，默认值为 0.85。
* --max-tps：标识最大导入的 TPS。
* --max-wait-timeout：指定等待数据库合并的最长超时时间。默认单位为小时，默认值为 3。

### 其他选项

* -H(--help)：查看 OBLOADER 命令行工具的使用帮助。
* -V(--version)：查看 OBLOADER 命令行工具的版本号。

* --replace-object：导入数据库对象定义时替换已存在的数据库对象定义（不推荐使用）。该选项仅与 `--ddl` 或 `--mix` 选项搭配使用，对 `--csv`、`--sql` 等其他数据格式选项不生效。
* --session-config：指定连接配置文件。程序包中已为您提供一份默认的配置文件：`<工具根目录>/conf/session.config.json`，您无需配置即可生效。建议仅当您需要使用同一份程序包加载多份连接配置时指定该选项。