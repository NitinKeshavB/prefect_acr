FROM prefecthq/prefect:2.11.3-python3.9
COPY requirements.txt /opt/prefect/prefect_acr/requirements.txt
RUN python -m pip install -r /opt/prefect/prefect_acr/requirements.txt
COPY . /opt/prefect/prefect_acr/
WORKDIR /opt/prefect/prefect_acr/
