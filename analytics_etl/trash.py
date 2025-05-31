from pyspark.sql import SparkSession
from pyspark.sql.functions import (
    col, sum as spark_sum, avg as spark_avg, count as spark_count, countDistinct,
    row_number, current_timestamp, when, corr
)
from pyspark.sql.window import Window
from datetime import datetime
from pyspark import SparkConf

def main():
    conf = SparkConf()
    conf.set("spark.jars.ivy", "/tmp/.ivy2")
    conf.set("spark.jars.packages", "")

    spark = SparkSession.builder \
        .appName("Ecommerce Analytics ETL") \
        .master("spark://spark-master:7077") \
        .config(conf=conf) \
        .getOrCreate()

    jdbc_url = "jdbc:clickhouse://clickhouse:8123/default"
    props = {"user": "default", "password": "password", "driver": "ru.yandex.clickhouse.ClickHouseDriver"}
    
    
    spark.stop()

if __name__ == "__main__":
    main()
