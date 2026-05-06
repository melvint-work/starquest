## Inspect the Dockerfile for naive-build

First, navigate to the working directory, inspect the Dockerfile and build the bad image:

```
cd /root/gift-tracker/01-naive-build
cp -r ../resources ./
docker build -t gift-tracker:naive .
```

## Check the image size
```
docker images gift-tracker:naive
```

<details><summary><b>What did you notice?</b></summary>

```plain
1. Notice the size?
2. What could be the reason that the file is of the size?
```
</details>


## Check what got copied into the image

There is no `.dockerignore` in `01-naive-build/`. The `COPY . .` instruction sends **everything** to the build daemon — including the secret `.env` file from `resources/`:

```
docker run --rm gift-tracker:naive find /app -type f
```

You should see `resources/.env` listed. That file contains `DB_PASSWORD=supersecret123` and has no business being inside a production image.

## Check who the app runs as

```
docker run --rm gift-tracker:naive whoami
```

<details><summary><b>Who & Why is the user?</b></summary>

```plain
The answer will be root.
That is the default when no USER instruction is present.
```
</details>

You can also run the app and check the `user_id` field in the JSON response:

```
docker run -d --name naive-app -p 5000:5000 gift-tracker:naive
sleep 2
curl http://localhost:5000/
docker stop naive-app && docker rm naive-app
```

`user_id: 0` = root. A compromised app running as root has full control of the container.

---

> **Click "Check" to confirm the naive image was built before continuing.**
