FROM python:3.11-alpine AS builder

WORKDIR /app

COPY . .

FROM python:3.11-alpine

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 3000

CMD ["python", "-m", "http.server", "3000"]
