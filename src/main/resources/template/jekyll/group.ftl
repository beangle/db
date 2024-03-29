[#ftl]
[#include "include/head.ftl"/]
[@head title=group.title toc=true/]

[#include "include/table.ftl"/]
[#list group.images as img]

### 关系图 ${img_index+1}. ${img.title}
  * 关系图

![${img.title}](${report.imageurl}${img.name}.png)

[#if img.description?? && img.description?length>0]
  * 说明

  ${img.description}
[/#if]
[/#list]

[#list group.tables?sort_by("name") as table]

### 表格 ${table.name.value?lower_case} ${table.comment!}
[@drawtable table/]
[/#list]
