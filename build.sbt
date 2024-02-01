import org.beangle.parent.Dependencies.*
import org.beangle.parent.Settings.*

ThisBuild / organization := "org.beangle.db"
ThisBuild / version := "0.0.33-SNAPSHOT"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/beangle/db"),
    "scm:git@github.com:beangle/db.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "The Beangle DB Library"
ThisBuild / homepage := Some(url("https://beangle.github.io/db/index.html"))

val beangle_commons_core = "org.beangle.commons" %% "beangle-commons-core" % "5.6.10"
val beangle_data_jdbc = "org.beangle.data" %% "beangle-data-jdbc" % "5.8.0"
val beangle_template_freemarker = "org.beangle.template" %% "beangle-template-freemarker" % "0.1.10"
val commonDeps = Seq(beangle_commons_core, logback_classic, logback_core, beangle_data_jdbc, scalatest, HikariCP, postgresql, h2, jtds, ojdbc11, orai18n, mysql_connector_java, mssql_jdbc)

lazy val root = (project in file("."))
  .settings()
  .aggregate(lint, report, transport, shell)

lazy val lint = (project in file("lint"))
  .settings(
    name := "beangle-db-lint",
    common,
    Compile / mainClass := Some("org.beangle.db.lint.validator.SchemaValidator"),
    libraryDependencies ++= commonDeps
  )

lazy val report = (project in file("report"))
  .settings(
    name := "beangle-db-report",
    common,
    Compile / mainClass := Some("org.beangle.db.report.Reporter"),
    libraryDependencies ++= commonDeps,
    libraryDependencies ++= Seq(beangle_commons_core, beangle_template_freemarker, plantuml)
  )

lazy val transport = (project in file("transport"))
  .settings(
    name := "beangle-db-transport",
    common,
    Compile / mainClass := Some("org.beangle.db.transport.Reactor"),
    libraryDependencies ++= commonDeps
  )

lazy val shell = (project in file("shell"))
  .settings(
    name := "beangle-db-shell",
    common,
    Compile / mainClass := Some("org.beangle.db.shell.Main"),
    libraryDependencies ++= commonDeps,
  ).dependsOn(report, transport, lint)

publish / skip := true
