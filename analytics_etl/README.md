# Инструкция по запуску проекта

## Шаги запуска проекта

1. **Запуск контейнеров:**

   ```bash
   docker compose -f ./docker-compose.analytics.yml up -d --build
   ```
2. Создание схемы ClickHouse:
  ```bash
   docker exec -i clickhouse clickhouse-client < ./create_schema.sql
   ```
3. Загрузка тестовых данных:
  ```bash
   python load_test_data.py
   ```
4. Создание витрин (представлений) в ClickHouse:
   ```bash
   docker exec -i clickhouse clickhouse-client < ./create_views.sql
   ```
5. Запуск Spark-задачи:
   ```bash
   docker exec -it spark-master python /app/spark_job.py
    ```
Открытие BI-визуализации:

Перейдите в браузере по адресу:

http://localhost:3000/
