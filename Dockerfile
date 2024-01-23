FROM python:3.12
ENV PIP_ROOT_USER_ACTION=ignore
WORKDIR /usr/src
RUN apt-get update -y
RUN apt-get install gcc python3-dev openjdk-17-jdk zstd texlive-xetex texlive-fonts-recommended texlive-plain-generic pandoc wget procps libgdal-dev -y

RUN python -m venv .venv
RUN pip install --upgrade pip
RUN pip install wheel setuptools
RUN pip install ipython matplotlib seaborn scikit-learn pandas polars numpy pyspark cuallee pyarrow fastparquet deltalake jupyterlab ipywidgets statsmodels delta-spark simple-salesforce imbalanced-learn gcsfs fpdf2 spark-nlp pychalk sqlglot squarify pywaffle networkx plotly inflection humanize pikepdf adtk
RUN pip install xgboost phonenumbers pendulum jupysql nbconvert[webpdf] jupyterlab_horizon_theme jupyterlab_templates catppuccin-jupyterlab toml nltk rustworkx geopy folium svgutils pycairo geopandas geodatasets
RUN pip install qrcode folium geopy svgutils fastavro avro
RUN pip install duckdb --pre
RUN pip install duckdb-engine
RUN rm -rf /home/root/.cache

RUN mkdir -p /worker
RUN mkdir -p /package
RUN mkdir -p /hadoop
VOLUME /worker
VOLUME /package

RUN mkdir -p /libs
RUN wget https://github.com/GoogleCloudDataproc/spark-bigquery-connector/releases/download/0.35.1/spark-bigquery-with-dependencies_2.12-0.35.1.jar -P /libs
RUN wget https://github.com/GoogleCloudDataproc/hadoop-connectors/releases/download/v2.2.19/gcs-connector-hadoop3-2.2.19-shaded.jar -P /libs
RUN wget https://repo1.maven.org/maven2/io/delta/delta-spark_2.12/3.0.0/delta-spark_2.12-3.0.0.jar -P /libs
RUN wget https://repo1.maven.org/maven2/io/delta/delta-storage/3.0.0/delta-storage-3.0.0.jar -P /libs
RUN wget https://repo1.maven.org/maven2/org/apache/spark/spark-avro_2.12/3.5.0/spark-avro_2.12-3.5.0.jar -P /libs

RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
RUN tar -zxvf hadoop-3.3.6.tar.gz --directory /hadoop

ENV HADOOP_HOME=/hadoop/hadoop-3.3.6
ENV HADOOP_COMMON_LIB_NATIVE_DIR=/hadoop/hadoop-3.3.6/lib/native
ENV LD_LIBRARY_PATH=/hadoop/hadoop-3.3.6/lib/native
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /usr/src/*

RUN mkdir -p /conf
COPY log4j.properties /conf/log4j.properties

RUN mkdir -p /root/.jupyter/templates/notebooks
RUN rm -rf /usr/local/share/jupyter/notebook/jupyterlab_templates/*.ipynb
RUN rm -rf /usr/local/lib/python3.12/site-packages/jupyterlab_templates/extension/notebook_templates/jupyterlab_templates/*.ipynb
RUN rm -rf /usr/local/lib/python3.12/site-packages/jupyterlab_templates/templates/jupyterlab_templates/*.ipynb
COPY sparker.ipynb /usr/local/lib/python3.12/site-packages/jupyterlab_templates/extension/notebook_templates/jupyterlab_templates/sparker.ipynb
COPY sparker.ipynb /usr/local/lib/python3.12/site-packages/jupyterlab_templates/templates/jupyterlab_templates/sparker.ipynb
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py


EXPOSE 8888

CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--allow-root", "--NotebookApp.token=password"]
