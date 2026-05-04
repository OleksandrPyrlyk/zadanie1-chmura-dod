# Zadanie 1 — część nieobowiązkowa (wersja 3, +80%)

## Autor

Oleksandr Pyrlyk

---

## Repozytoria

GitHub:  
https://github.com/OleksandrPyrlyk/zadanie1-chmura-dod  

DockerHub:  
https://hub.docker.com/r/oleksandrpyrlyk/zadanie1-weather-dod  

---

## Zakres realizacji

W ramach części nieobowiązkowej wykonano obraz kontenera zgodny z OCI dla dwóch platform sprzętowych:

- linux/amd64
- linux/arm64

W procesie budowania wykorzystano:

- builder oparty na sterowniku `docker-container`
- Docker BuildKit
- rozszerzony frontend Dockerfile
- mechanizm `mount secret`
- cache w rejestrze (registry cache)
- tryb cache `mode=max`

---

## Utworzenie buildera

Wykorzystano builder Docker Buildx:

```bash
docker buildx create --name zadanie1-builder --driver docker-container --use
