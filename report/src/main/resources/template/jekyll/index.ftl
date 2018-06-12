[#ftl]
[#include "include/head.ftl"/]
[@head/]
[#include "include/module.ftl"/]

#### 目 录

##### 1. 数据库对象列表
  * 1.1 [表格一览](tables.html)
[#if sequences?size>0]
  * 1.2 [序列一览](sequences.html)
[/#if]
[#if report.images?size>0]
  * [#if sequences?size>0]1.3[#else]1.2[/#if] [模块关系图](images.html)
[/#if]

##### 2. 具体模块明细
[#assign idx=1/]
[#list report.modules as m]
[#if m.tables?size>0]
  [@moduleindex "2."+idx,m;prefix,module/]
  [#assign idx=idx+1/]
[/#if]
[/#list]
