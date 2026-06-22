FROM python:3.11-slim

WORKDIR /app

# Install dependencies before copying source so this layer is cached
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files (raw data files are excluded via .dockerignore)
COPY . .

# Ensure data directories exist even when raw data is not present at build time
RUN mkdir -p data/raw data/processed

EXPOSE 8888

# Disable token auth for local development.
# To secure for remote access, override via:
#   docker run -e JUPYTER_TOKEN=mysecrettoken ...
#   or set JUPYTER_TOKEN in docker-compose.yml
CMD ["jupyter", "lab", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--allow-root", \
     "--no-browser", \
     "--ServerApp.token=", \
     "--ServerApp.password="]
