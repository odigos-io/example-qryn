# example-qryn

example setup for sending odigos telemetry to qryn destination

## Deployments

For qryn destination, we deploy the following components:

- ClickHouse database - for qryn to store the telemetry data. The example uses one clickhouse pod with no replication or persistent storage. Production deployments should use a more robust setup.
- Qryn - the qryn destination that receives the telemetry data store it in ClickHouse and exposes query APIs.
- Grafana - for running run queries on the data and visualizing it.

## Run the Example

### Kubernetes Cluster

Make sure you have a playground Kubernetes cluster running and kubectl is configured to access it. To spin up a local ephemeral cluster for testing, you can use [kind](https://kind.sigs.k8s.io/): `kind create cluster`.

### Deploy Qryn Backend

Run the following make target to deploy the qryn backend components in the `qryn` namespace:

```sh
make deploy
```

### Run Demo Application

Add an application to the cluster that will be instrumented with odigos and send telemetry to qryn. 

You can use any application you like, or odigos simple-demo:

```sh
kubectl apply -f https://raw.githubusercontent.com/odigos-io/simple-demo/main/kubernetes/deployment.yaml
```

### Install Odigos

Install odigos on the cluster (after odigos cli is installed on your machine):

```sh
odigos install
```

### Instrumentation

Open the odigos ui with:

```
odigos ui
```

- browse to the odigos on-boarding page
- add the sources you want to instrument (or all sources in default ns for the simple-demo)
- add the qryn destination. Give it the name `qryn`. For Api Url, use `http://qryn-qryn-helm.qryn:3100` and keep all other setting as default.

### Generate Traffic

Generate some traffic to the application to see the telemetry data in qryn. If you run the simple-demo application, you can port-forward the service to your local machine and click few buttons on the web page:

```sh
kubectl port-forward svc/frontend 8080:8080
```

