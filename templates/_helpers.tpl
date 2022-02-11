{{/*
Expand the name of the chart.
*/}}
{{- define "cwl-airflow-openshift.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cwl-airflow-openshift.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cwl-airflow-openshift.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cwl-airflow-openshift.labels" -}}
helm.sh/chart: {{ include "cwl-airflow-openshift.chart" . }}
{{ include "cwl-airflow-openshift.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cwl-airflow-openshift.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cwl-airflow-openshift.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cwl-airflow-openshift.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cwl-airflow-openshift.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "postgresql.existingSecret" -}}
  {{ include "cwl-airflow-openshift.secrets" . }}
{{- end -}}

{{- define "cwl-airflow-openshift.secrets" -}}
  {{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Returns the available value for certain key in an existing secret (if it exists),
otherwise it generates a random value.
*/}}
{{- define "getSecret" }}
{{- $obj := (lookup "v1" "Secret" .Namespace .Name).data -}}
{{- if $obj }}
{{- index $obj .Key | b64dec -}}
{{- else -}}
{{- printf "%s" $obj -}}
{{- end -}}
{{- end }}

{{- define "cwl-airflow-openshift.postgresql.password" -}}
{{/*
  {{- include "getSecret" (dict "Namespace" .Release.Namespace "Name" (include "cwl-airflow-openshift.secrets" .) "Key" "postgresql-password") -}}
  {{- printf "%s" (dict "Namespace" .Release.Namespace "Name" (include "cwl-airflow-openshift.secrets" .) "Key" "postgresql-password")  -}}
*/}}
  {{- .Values.postgresql.postgresqlPassword -}}
{{- end -}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "cwl-airflow-openshift.postgresql.fullname" -}}
{{- include "common.names.dependency.fullname" (dict "chartName" "postgresql" "chartValues" .Values.postgresql "context" $) -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "cwl-airflow-openshift.database.host" -}}
{{- include "cwl-airflow-openshift.postgresql.fullname" . -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "cwl-airflow-openshift.database.user" -}}
{{- .Values.postgresql.postgresqlUsername -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "cwl-airflow-openshift.database.name" -}}
{{- .Values.postgresql.postgresqlDatabase -}}
{{- end -}}

{{/*
Get the configmap name
*/}}
{{- define "cwl-airflow-openshift.dbconn" -}}
  {{- printf "postgresql+psycopg2://%s:%s@%s/%s" (include "cwl-airflow-openshift.database.user" .) (include "cwl-airflow-openshift.postgresql.password" .) (include "cwl-airflow-openshift.database.host" .) (include "cwl-airflow-openshift.database.name" .) | quote -}}
{{- end -}}