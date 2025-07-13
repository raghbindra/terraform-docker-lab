output "nginx_container_ip" {
  value = docker_container.nginx_proxy.network_data[0].ip_address
}

output "redis_container_ip" {
  value = docker_container.redis.network_data[0].ip_address
}

output "app_container_ip" {
    value = docker_container.flask-app.network_data[0].ip_address
}