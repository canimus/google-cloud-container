FROM python:3.11.3-slim
ENV PIP_ROOT_USER_ACTION=ignore
WORKDIR /usr/src
RUN apt-get update -y
RUN apt-get install openjdk-11-jdk zstd texlive-xetex texlive-fonts-recommended texlive-plain-generic pandoc wget procps -y

RUN python -m venv .venv
RUN pip install --upgrade pip
RUN pip install wheel setuptools
RUN pip install ipython matplotlib seaborn scikit-learn pandas==1.5.3 numpy pyspark==3.4.1 cuallee pyarrow fastparquet deltalake jupyterlab ipywidgets statsmodels delta-spark simple-salesforce imbalanced-learn gcsfs duckdb fpdf2 spark-nlp pychalk sqlglot squarify pywaffle networkx plotly inflection humanize pikepdf adtk
RUN pip install xgboost phonenumbers pendulum duckdb-engine jupysql nbconvert[webpdf] jupyterlab_horizon_theme jupyterlab_templates
RUN rm -rf /home/root/.cache

RUN mkdir -p /worker
RUN mkdir -p /package
RUN mkdir -p /hadoop
VOLUME /worker
VOLUME /package

RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
RUN tar -zxvf hadoop-3.3.6.tar.gz --directory /hadoop

ENV HADOOP_HOME=/hadoop/hadoop-3.3.6
ENV HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop/hadoop=3.3.6/lib/native
ENV LD_LIBRARY_PATH=/hadoop/hadoop-3.3.6/lib/native
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /libs
RUN mkdir -p /conf
RUN mkdir -p /scripts

COPY log4j.properties /conf/log4j.properties
COPY sparker.ipynb /scripts/sparker.ipynb
RUN mkdir -p /root/.jupyter
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN wget https://github.com/GoogleCloudDataproc/spark-bigquery-connector/releases/download/0.32.2/spark-bigquery-with-dependencies_2.12-0.32.2.jar -P /libs
RUN wget https://github.com/GoogleCloudDataproc/hadoop-connectors/releases/download/v2.2.17/gcs-connector-hadoop3-2.2.17-shaded.jar -P /libs
RUN wget https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.4.0/delta-core_2.12-2.4.0.jar -P /libs
RUN wget https://repo1.maven.org/maven2/io/delta/delta-storage/2.4.0/delta-storage-2.4.0.jar -P /libs

EXPOSE 8888

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--allow-root", "--NotebookApp.token=copado"]