{{/* mlflow server port */}}
{{- define "mlflow.serverPort" -}}
{{- if .Values.containerPort -}}
--port={{ .Values.containerPort }}
{{- end -}}
{{- end -}}

{{/* mlflow server worker */}}
{{- define "mlflow.serverWorkers" -}}
{{- if .Values.workers -}}
--workers={{ .Values.workers }}
{{- end -}}
{{- end -}}

{{/* mlflow server metrics */}}
{{- define "mlflow.serverMetrics" -}}
{{- if .Values.metrics -}}
--expose-prometheus=/metrics
{{- end -}}
{{- end -}}

{{/* mlflow default artifact root */}}
{{- define "mlflow.defaultArtifactRoot" -}}
{{- if .Values.defaultArtifactRoot -}}
--default-artifact-root={{ .Values.defaultArtifactRoot }}
{{- end -}}
{{- end -}}

{{/* mlflow backend store uri */}}
{{- define "mlflow.backendStoreUri" -}}
{{- if .Values.backendStoreUri -}}
{{- if .Values.artifacts.only -}}
{{- fail "cannot set backend store uri when artifacts.only is true" -}}
{{- else -}}
--backend-store-uri={{ .Values.backendStoreUri }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* mlflow disable tracking features */}}
{{- define "mlflow.artifactsOnly" -}}
{{- if .Values.artifacts.only -}}
--artifacts-only
{{- end -}}
{{- end -}}

{{/* mlflow server proxy artifacts */}}
{{- define "mlflow.proxyArtifacts" -}}
{{- if .Values.artifacts.serve -}}
--serve-artifacts
{{- else if .Values.artifacts.only -}}
{{- fail "cannot disable both experiment tracking and artifacts serving" -}}
{{- else -}}
--no-serve-artifacts
{{- end -}}
{{- end -}}

{{/* mlflow artifacts destination */}}
{{- define "mlflow.artifactsDestination" -}}
{{- if .Values.artifacts.destination -}}
--artifacts-destination={{ .Values.artifacts.destination }}
{{- end -}}
{{- end -}}

{{/* mlflow auth */}}
{{- define "mlflow.auth" -}}
{{- if .Values.auth.enabled -}}
--app-name basic-auth
{{- end -}}
{{- end -}}


{{/* mlflow deployment container command for launching the tracking server */}}
{{- define "mlflow.trackingServerArgs" -}}
{{- $args := list (include "mlflow.artifactsOnly" .)
                  (include "mlflow.serverPort" .)
                  (include "mlflow.serverWorkers" .)
                  (include "mlflow.serverMetrics" .)
                  (include "mlflow.defaultArtifactRoot" .)
                  (include "mlflow.backendStoreUri" .)
                  (include "mlflow.proxyArtifacts" .)
                  (include "mlflow.artifactsDestination" .)
                  (include "mlflow.auth" .) -}}
- mlflow
- server
- --host=0.0.0.0
{{- range $args }}
{{- if . }}
- {{ . }}
{{- end }}
{{- end }}
{{- end -}}
