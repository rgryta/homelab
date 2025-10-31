## Prometheus

After creating a config yaml file, put this in contents:

```yaml
global:
 scrape_interval: 1m
 
scrape_configs:
 - job_name: “prometheus”
   scrape_interval: 1m
   static_configs:
   - targets: [“localhost:9090”]
 - job_name: cadvisor
   scrape_interval: 5s
   static_configs:
   - targets:
     - (IP of cAdvisor node):8080
 - job_name: “node”
   static_configs:
   - targets: ["(IP of node exporter node):9100"]
```