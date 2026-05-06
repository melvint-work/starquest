# Step 3 — Understand the broken layer cache

The naive Dockerfile copies everything before installing dependencies:

```dockerfile
COPY . .                            # copies EVERYTHING first
RUN pip install -r requirements.txt # always re-runs if any file changed
```

This means **any change to `app.py`** invalidates the `COPY` layer and forces `pip install` to re-run — even though `requirements.txt` didn't change. On a project with many dependencies this wastes minutes on every rebuild.

## See it in action

Make a small change to `app.py`:

```
sed -i 's/Gift Tracking Service/Gift Tracking Service v2/' /root/gift-tracker/01-naive-build/app.py
```{{exec}}

Rebuild and watch the output carefully — specifically whether pip runs again:

```
cd /root/gift-tracker/01-naive-build && docker build -t gift-tracker:naive .
```{{exec}}

Notice `pip install` runs from scratch even though `requirements.txt` was untouched.

## The fix: copy in the right order

```dockerfile
COPY requirements.txt .             # stable file goes first
RUN pip install --no-cache-dir -r requirements.txt  # this layer is now CACHED
COPY app.py .                       # changing this only invalidates this layer
```

With this order, changing `app.py` only re-runs the cheap `COPY app.py` layer. The slow `pip install` layer stays cached.

## Restore the file before continuing

```
sed -i 's/Gift Tracking Service v2/Gift Tracking Service/' /root/gift-tracker/01-naive-build/app.py
```{{exec}}

---

> **Click "Check" to confirm the file has been restored and you understand the caching issue.**
