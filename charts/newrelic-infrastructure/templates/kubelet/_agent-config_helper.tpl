{{- /*
Defaults for kubelet's agent config
*/ -}}
{{- define "nriKubernetes.kubelet.agentConfig.defaults" -}}
http_server_enabled: true
http_server_port: 8003
features:
  docker_enabled: false
{{- if not ( include "common.privileged" . ) }}
is_secure_forward_only: true
overide_host_root: ""  # Typo from here: https://github.com/newrelic/infrastructure-agent/blob/master/pkg/config/config.go#L267
{{- end }}
{{- /*
`enableProcessMetrics` is commented in the values and we want to configure it when it is set to something
either `true` or `false`. So we test if the variable is a boolean and in that case simply use it.
*/}}
{{- if (get .Values "enableProcessMetrics" | kindIs "bool") }}
enable_process_metrics: {{ .Values.enableProcessMetrics }}
{{- end }}
{{- end -}}



{{- define "nriKubernetes.kubelet.agentConfig" -}}
{{- $agentDefaults := fromYaml ( include "common.agentConfig.defaults" . ) -}}
{{- $kubelet := fromYaml ( include "nriKubernetes.kubelet.agentConfig.defaults" . ) -}}
{{- $agentConfig := fromYaml ( include "newrelic.compatibility.agentConfig" . ) -}}

{{- mustMergeOverwrite $agentDefaults $kubelet $agentConfig | toYaml -}}
{{- end -}}
