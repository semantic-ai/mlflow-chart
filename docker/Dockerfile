FROM python:3.11-slim

EXPOSE 5000

WORKDIR /usr/src/app

# Install MSSQL driver
RUN apt-get update && \
    apt-get install -y unixodbc curl gnupg && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg && \
    curl https://packages.microsoft.com/config/debian/12/prod.list | tee /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql18 && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

COPY start.sh .

RUN chown -R 1001 . && chown -R 1001 /usr/local/lib/python3.11/site-packages/mlflow

USER 1001

CMD [ "./start.sh" ]