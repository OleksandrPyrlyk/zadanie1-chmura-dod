# Zadanie 1 — część nieobowiązkowa dodatkowa 3

## Autor

Oleksandr Pyrlyk

## Repozytoria

GitHub:

https://github.com/OleksandrPyrlyk/zadanie1-chmura-dod

DockerHub:

https://hub.docker.com/r/oleksandrpyrlyk/zadanie1-weather-dod

---

## Zakres wykonania

W ramach części dodatkowej wykonano obraz kontenera zgodny z OCI dla dwóch platform sprzętowych:

- linux/amd64
- linux/arm64

Do budowania wykorzystano builder oparty na sterowniku docker-container oraz Docker BuildKit.

W Dockerfile użyto rozszerzonego frontendu BuildKit:

```dockerfile
# syntax=docker/dockerfile:1.7
