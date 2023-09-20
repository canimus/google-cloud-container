import warnings
warnings.simplefilter("ignore")
from pyspark.sql import SparkSession, DataFrame, Row
from pyspark.conf import SparkConf
import pyspark.sql.functions as F
from pyspark.sql import Window as W
import pyspark.sql.types as T


# Create a SparkConf object
conf = (
        SparkConf()
            .setAppName("JupyterLab")
            .setMaster("local[20]")
            .set("spark.driver.memory", "80g")
            .set("spark.driver.extraJavaOptions", "-Dlog4j.configuration=file:///conf/log4j.properties")
            .set("spark.jars", "/libs/spark-bigquery-with-dependencies_2.12-0.32.2.jar,/libs/gcs-connector-hadoop3-2.2.17-shaded.jar,/libs/delta-core_2.12-2.4.0.jar,/libs/delta-storage-2.4.0.jar")
            .set("spark.hadoop.fs.gs.impl", "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem")
            .set("spark.hadoop.fs.gs.project.id", "global-observability-863c")
            .set("spark.hadoop.google.cloud.auth.service.account.enable", "true")
            .set("spark.hadoop.google.cloud.auth.service.account.json.keyfile", "herminio-token.json")
            .set("spark.sql.session.timeZone", "UTC")
            .set("spark.ui.showConsoleProgress", "false")
            .set("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
            .set("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")
)


spark = (
    SparkSession
    .builder
    .config(conf=conf)
    .getOrCreate()
)
