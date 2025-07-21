terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_network" "dev_network" {
  name = "dev_network"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_image" "redis" {
  name = "redis:latest"
}

resource "docker_volume" "redis_data" {
  name = "redis_data"
}

resource "null_resource" "prebuild_flask_image" {
  provisioner "local-exec" {
    command = "docker build -t custom-flask-app:latest ./app"
  }
}


resource "docker_container" "nginx_proxy" {
  name  = "nginx_proxy"
  image = docker_image.nginx.name

  depends_on = [docker_container.flask-app]

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.dev_network.name
  }

  volumes {
    container_path = "/etc/nginx/conf.d/default.conf"
    host_path      = abspath("${path.module}/nginx/default.conf")
    read_only      = true
  }

  volumes {
    container_path = "/etc/nginx/.htpasswd"
    host_path      = abspath("${path.module}/nginx/.htpasswd")
    read_only      = true
  }

  restart = "always"
}

resource "docker_container" "redis" {
  name  = "redis_container"
  image = docker_image.redis.name
  networks_advanced {
    name = docker_network.dev_network.name
  }
  mounts {
    target = "/data"
    source = docker_volume.redis_data.name
    type   = "volume"
  }
}

resource "docker_container" "flask-app" {
  name  = "flask-container"
  image = "custom-flask-app:latest"
  depends_on = [null_resource.prebuild_flask_image]
  ports {
    internal = 5000
    external = 5005
  }
  networks_advanced {
    name = docker_network.dev_network.name
  }
}