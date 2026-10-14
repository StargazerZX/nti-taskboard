{{/*
Return the chart's full resource name, keeping it within Kubernetes' name limit.
*/}}
{{- define "mychart.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $fullname := default (printf "%s-%s" .Release.Name $name) .Values.fullnameOverride -}}
{{- $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
