FROM python:3.12-slim

EXPOSE 5000

WORKDIR /usr/src/app

# Apply all available Debian security patches and install the MSSQL driver.
# curl is only needed to fetch the Microsoft repo config and is purged afterwards
# (this also removes libbrotli1 and libgnutls30t64, which only curl pulls in).
RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends unixodbc curl ca-certificates && \
    curl -fsSL -o /tmp/packages-microsoft-prod.deb \
        "https://packages.microsoft.com/config/debian/$(. /etc/os-release && echo $VERSION_ID)/packages-microsoft-prod.deb" && \
    dpkg -i /tmp/packages-microsoft-prod.deb && \
    rm /tmp/packages-microsoft-prod.deb && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 && \
    apt-get purge -y --auto-remove curl && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt

COPY start.sh .

RUN chown -R 1001 . && chown -R 1001 /usr/local/lib/python3.12/site-packages/mlflow

USER 1001

CMD [ "./start.sh" ]
