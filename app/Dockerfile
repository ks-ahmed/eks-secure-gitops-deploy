FROM python:3.11-alpine AS builder

WORKDIR /app

COPY . .

FROM python:3.11-alpine

RUN addgroup -g 1000 appgroup && \
    adduser -D -u 1000 -G appgroup appuser

WORKDIR /app

COPY --from=builder /app /app

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

CMD ["python", "-m", "http.server", "3000"]
