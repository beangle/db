#!/bin/sh
if [ $# -eq 0 ]; then
  echo "Usage:
   transport.sh /path/to/config.xml"
  exit 1
fi

if [ -z "$M2_REMOTE_REPO" ]; then
  export M2_REMOTE_REPO="https://maven.aliyun.com/nexus/content/groups/public"
fi
if [ -z "$M2_REPO" ]; then
  export M2_REPO="$HOME/.m2/repository"
fi

bootpath=""
# download groupId artifactId version
download(){
  local group_id=`echo "$1" | tr . /`
  local URL="$M2_REMOTE_REPO/$group_id/$2/$3/$2-$3.jar"
  local artifact_name="$2-$3.jar"
  local local_file="$M2_REPO/$group_id/$2/$3/$2-$3.jar"
  bootpath+=":"$local_file

  if [ ! -f $local_file ]; then
    if wget --spider $URL 2>/dev/null; then
      echo "fetching $URL"
    else
      echo "$URL not exists,installation aborted."
      exit 1
    fi

    if command -v aria2c >/dev/null 2; then
      aria2c -x 16 $URL
    else
      wget $URL -O $artifact_name.part
      mv $artifact_name.part $artifact_name
    fi
    mkdir -p "$M2_REPO/$group_id/$2/$3"
    mv $artifact_name $local_file
  fi
}

export scala_ver=2.13.3
export beangle_commons_ver=5.2.3
export beangle_template_ver=0.0.31
export slf4j_ver=2.0.0-alpha1
export logback_ver=1.3.0-alpha5
export commons_compress_ver=1.19
export boot_ver=0.0.20
export beangle_db_ver=0.0.9

download org.scala-lang scala-library $scala_ver
download org.scala-lang scala-reflect $scala_ver
download org.beangle.commons beangle-commons-core_2.13  $beangle_commons_ver
download org.beangle.commons beangle-commons-file_2.13  $beangle_commons_ver
download org.apache.commons commons-compress $commons_compress_ver
download org.beangle.boot beangle-boot_2.13 $boot_ver
download org.slf4j slf4j-api $slf4j_ver
download ch.qos.logback logback-core $logback_ver
download ch.qos.logback logback-classic $logback_ver
download org.beangle.db beangle-db-transport  $beangle_db_ver

jarfile="$M2_REPO/org/beangle/db/beangle-db-transport/$beangle_db_ver/beangle-db-transport-$beangle_db_ver.jar"

if [[ -f $jarfile ]];then
  args="$@"
  java -cp "${bootpath:1}" org.beangle.boot.artifact.AppResolver $jarfile $M2_REMOTE_REPO $M2_REPO
  info=`java -cp "${bootpath:1}" org.beangle.boot.launcher.Classpath $jarfile $M2_REPO`
  if [ $? = 0 ]; then
    mainclass="${info%@*}"
    classpath="${info#*@}"
    #echo java -cp "$classpath" $options $mainclass $args
    java -cp "$classpath" $mainclass $args
  else
     echo $info
  fi
else
  echo "Cannot find $jarfile,Transportation aborted."
fi