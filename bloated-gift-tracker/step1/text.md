# Step 1 — Build and inspect the naive image

First, navigate to the working directory and build the bad image:

```
cd /root/gift-tracker/01-naive-build
docker build -t gift-tracker:naive .
```{{exec}}

## Check the image size

```
docker images gift-tracker:naive
```{{exec}}

Note the size — it will be well over 1GB.

## Check what got copied into the image

There is no `.dockerignore` in `01-naive-build/`. The `COPY . .` instruction sends **everything** to the build daemon — including the secret `.env` file from `resources/`:

```
docker run --rm gift-tracker:naive find /app -type f
```{{exec}}

You should see `resources/.env` listed. That file contains `DB_PASSWORD=supersecret123` and has no business being inside a production image.

## Check who the app runs as

```
docker run --rm gift-tracker:naive whoami
```{{exec}}

The answer will be `root`. That is the default when no `USER` instruction is present.

You can also run the app and check the `user_id` field in the JSON response:

```
docker run -d --name naive-app -p 5000:5000 gift-tracker:naive
sleep 2
curl http://localhost:5000/
docker stop naive-app && docker rm naive-app
```{{exec}}

`user_id: 0` = root. A compromised app running as root has full control of the container.

---

> **Click "Check" to confirm the naive image was built before continuing.**
