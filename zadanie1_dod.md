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

* linux/amd64
* linux/arm64

W procesie budowania wykorzystano:

* builder oparty na sterowniku `docker-container`
* Docker BuildKit
* rozszerzony frontend Dockerfile
* mechanizm `mount secret`
* cache w rejestrze (registry cache)
* tryb cache `mode=max`

---

## Utworzenie buildera

```bash
docker buildx create --name zadanie1-builder --driver docker-container --use
docker buildx inspect --bootstrap
```

### Wynik

```text
Driver: docker-container
Platforms: linux/amd64, linux/arm64
```

**Komentarz:**
Potwierdzono użycie wymaganego sterownika `docker-container`.

---

## Budowanie obrazu multi-platform

```bash
docker buildx build --builder zadanie1-builder --platform linux/amd64,linux/arm64 --build-arg GITHUB_REPO=https://github.com/OleksandrPyrlyk/zadanie1-chmura-dod.git --secret id=github_token,src=github_token.txt --cache-from type=registry,ref=oleksandrpyrlyk/zadanie1-weather-dod:buildcache --cache-to type=registry,ref=oleksandrpyrlyk/zadanie1-weather-dod:buildcache,mode=max -t oleksandrpyrlyk/zadanie1-weather-dod:latest --push .
```

**Komentarz:**

* obraz został zbudowany dla dwóch platform sprzętowych
* obraz został przesłany do DockerHub (`--push`)
* wykorzystano cache registry (`cache-from` i `cache-to`)
* zastosowano tryb `mode=max`

---

## Wykorzystanie BuildKit secret

W Dockerfile zastosowano:

```dockerfile
RUN --mount=type=secret,id=github_token
```

Sekret został przekazany podczas budowania:

```bash
--secret id=github_token,src=github_token.txt
```

**Komentarz:**

* mechanizm secret został użyty zgodnie z wymaganiami
* dane wrażliwe nie zostały ujawnione w sprawozdaniu

---

## Potwierdzenie manifestu

```bash
docker buildx imagetools inspect oleksandrpyrlyk/zadanie1-weather-dod:latest
```

### Wynik

```text
Platform: linux/amd64
Platform: linux/arm64
```

**Komentarz:**
Manifest zawiera deklaracje dla obu wymaganych platform sprzętowych.

---

## Potwierdzenie utworzenia cache

```bash
docker buildx imagetools inspect oleksandrpyrlyk/zadanie1-weather-dod:buildcache
```

### Wynik

```text
Name:      docker.io/oleksandrpyrlyk/zadanie1-weather-dod:buildcache
MediaType: application/vnd.oci.image.manifest.v1+json
Digest:    sha256:ce14a98556af98dc4d563f9cfb45c6dce44e4badb687ec2e0abf92a265c4162f
```

**Komentarz:**
Cache obraz został poprawnie zapisany w registry.

---

## Potwierdzenie wykorzystania cache

Ponowne uruchomienie build:

```bash
docker buildx build ...
```

### Wynik

```text
CACHED
```

**Komentarz:**
Widoczne wpisy `CACHED` potwierdzają wykorzystanie danych cache podczas budowania obrazu.

---

## Analiza podatności (CVE)

Analiza może zostać wykonana za pomocą:

```bash
docker scout cves oleksandrpyrlyk/zadanie1-weather-dod:latest
```

lub:

```bash
trivy image oleksandrpyrlyk/zadanie1-weather-dod:latest
```

**Komentarz:**

* obraz nie powinien zawierać podatności CRITICAL i HIGH
* w przypadku ich wystąpienia należy dodać uzasadnienie

---

## Podsumowanie

Zrealizowano wszystkie wymagania dla wersji 3:

* obraz multi-platform (amd64 + arm64)
* użycie BuildKit
* użycie buildera docker-container
* wykorzystanie mount secret
* wykorzystanie cache registry (mode=max)
* potwierdzenie manifestu
* potwierdzenie cache
* brak ujawnienia danych wrażliwych

---

## Informacja końcowa

Plik `zadanie1_dod.md` został umieszczony w repozytorium GitHub zgodnie z wymaganiami zadania.
Obraz kontenera został opublikowany w DockerHub.

Do oceny należy przekazać wyłącznie linki do repozytoriów:

GitHub:
https://github.com/OleksandrPyrlyk/zadanie1-chmura-dod

DockerHub:
https://hub.docker.com/r/oleksandrpyrlyk/zadanie1-weather-dod
