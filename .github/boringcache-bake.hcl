target "builder" {
  context = "infrastructure/docker/services/php"
  target = "builder"
  args = { PHP_VERSION = "8.5" }
  platforms = ["linux/amd64"]
  tags = ["docker-starter-builder:validation"]
  cache-from = []
}

target "frontend" {
  context = "infrastructure/docker/services/php"
  target = "frontend"
  args = { PHP_VERSION = "8.5" }
  platforms = ["linux/amd64"]
  tags = ["docker-starter-frontend:validation"]
  cache-from = []
}
