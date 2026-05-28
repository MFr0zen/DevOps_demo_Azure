# Build stage
FROM python:3.11-slim AS builder
WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Runtime stage
FROM python:3.11-slim

RUN useradd -m apprunner

WORKDIR /app

COPY --from=builder /install /usr/local
COPY app/ .

RUN chown -R apprunner:apprunner /app
USER apprunner

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
