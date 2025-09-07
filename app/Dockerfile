# Stage 1: Build Stage
FROM python:3.11-alpine AS builder

WORKDIR /app

COPY . .

# Stage 2: Final Image
FROM python:3.11-alpine

# Create a non-root user and group
RUN addgroup -g 1000 appgroup && \
    adduser -D -u 1000 -G appgroup appuser

# Set the working directory
WORKDIR /app

# Copy application files from the builder stage
COPY --from=builder /app /app

# Change ownership of the application files to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["python", "-m", "http.server", "3000"]
