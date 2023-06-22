{{/*
Expand the name of the chart.
*/}}
{{- define "echo-app.name" -}}
{{- printf "%s-%s" .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

