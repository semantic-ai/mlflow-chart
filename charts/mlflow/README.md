# MLflow Helm Chart

MLflow is an open source platform for managing end-to-end machine learning lifecycle.

## Introduction

This chart can be used to deploy an MLflow tracking server to a kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.4.0+

## Installing the Chart

To install the chart with release name `my-mlflow`:

```bash
helm install my-mlflow .
```

You could port-forward the service to access the web UI at `127.0.0.1:5000`:

```bash
kubectl port-forward svc/my-mlflow 5000:80
```

## Uninstalling the Chart

To uninstall the `my-mlflow` release:

```bash
helm delete my-mlflow
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

See `values.yaml` for all the helm chart parameters and descriptions

While installing the chart, specify each parameter using `--set key=value[,key=value]` arguments,
or provide a YAML file that specifies the values to override specific parameters, like so:

```bash
helm install my-mlflow /path/to/chart --values my-mlflow-values.yaml
```

## Supplying Credentials and Access

If you need to give the MLflow server access to, say, an S3 bucket for artifacts storage, you have 3 choices:

- Setup [an IAM role for the service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) used by the chart (see `serviceAccount` in `values.yaml`)
  - The IAM role should have read/write access to the bucket
  - Add appropriate annotations to `serviceAccount.annotations` in your values file
- Pass IAM user credentials as environment variables
  - Create an IAM user with read/write access to the bucket
  - Create a Kubernetes secret that contains the user's credentials stored in keys `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
  - Refer to that secret from `envSecrets` in your values file
- Pass IAM user credentials through `~/.aws/credentials` file
  - Create an IAM user with appropriate permissions
  - Create a Kubernetes secret with the credential file contents stored in `credentials` key. Example:

    ```
    kubectl create secret generic aws-creds --from-file=credentials=/path/to/credentials
    ```

  - Use `volumes` and `volumeMounts` in your values file [to mount this secret](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/) to path `/root/.aws`:

    ```yaml
    volumes:
      - name: aws-creds-volume
        secret: aws-creds
    volumeMounts:
      - name: aws-creds-volume
        mountPath: /root/.aws
        readOnly: true
    ```

These 3 techniques are generally applicable, and can be used to pass various credentials and other secrets as needed to MLflow server.
