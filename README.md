# Description
Docker image for apache and mason.

# Usage
```Docker
docker create \
  --name=mason \
  -e TIMEZONE=<<TIMEZONE|default(UTC)>> \
  -p 80:80 \
  -v path to website:/mnt/site \
  --restart unless-stopped \
  dschinghiskahn/mason
```
