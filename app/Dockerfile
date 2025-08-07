# ---------- Stage 1: Build stage ----------
FROM python:3.11-slim AS builder

# Set working directory
WORKDIR /app

# Copy all files into the build context
COPY . .

# ---------- Stage 2: Runtime stage ----------
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy only the final app files from the builder stage
COPY --from=builder /app /app

# Expose the port for http.server
EXPOSE 3000

# Start the Python HTTP server
CMD ["python", "-m", "http.server", "3000"]
