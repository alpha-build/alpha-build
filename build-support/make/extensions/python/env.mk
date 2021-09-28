env-py-airflow-replicate:
	$(eval AIRFLOW_VERSION := 2.1.0)
	$(eval PYTHON_VERSION := $(shell python --version | cut -d " " -f 2 | cut -d "." -f 1-2))
	python -m pip install "apache-airflow[async,postgres,statsd]==$(AIRFLOW_VERSION)" airflow-exporter --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-$(AIRFLOW_VERSION)/constraints-$(PYTHON_VERSION).txt"
