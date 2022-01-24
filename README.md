<!--- app-name: Apache Airflow -->

# Apache Airflow

[Apache Airflow](https://airflow.apache.org/) is a platform to programmatically author, schedule and monitor workflows.

## TL;DR

```console
$ helm install my-release bitnami/airflow
```

## Introduction

This chart bootstraps an [Apache Airflow](https://github.com/bitnami/bitnami-docker-airflow) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

Bitnami charts can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters. This Helm chart has been tested on top of [Bitnami Kubernetes Production Runtime](https://kubeprod.io/) (BKPR). Deploy BKPR to get automated TLS certificates, logging and monitoring for your applications.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/airflow
```

These commands deploy Airflow on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.
