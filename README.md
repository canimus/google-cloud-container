# Jupyter Lab container
This repository creates a `docker` container for local development, using `pyspark`, `google-cloud-storage` and `bigquery`

## Build
```
docker build -t sciencelab .
```

## Run
```
# Run
docker run --name lab --rm -p 8888:8888 sciencelab 
```
