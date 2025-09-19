# Multi-stage build for optimized SvelteKit application
FROM node:20-alpine AS builder

# Build arguments for debugging and metadata
ARG CI_COMMIT_SHA
ARG CI_COMMIT_REF_NAME
ARG BUILD_DATE
LABEL commit_sha="${CI_COMMIT_SHA}"
LABEL commit_ref="${CI_COMMIT_REF_NAME}"
LABEL build_date="${BUILD_DATE}"

# Install build dependencies
RUN apk add --no-cache git

# Enable verbose logging
RUN echo "Starting build process..." && \
    echo "Commit SHA: ${CI_COMMIT_SHA}" && \
    echo "Commit Ref: ${CI_COMMIT_REF_NAME}" && \
    echo "Build Date: ${BUILD_DATE}"

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY svelte.config.js ./

# Install dependencies
RUN npm ci

# Fix native module issues for Alpine Linux
RUN npm install @rollup/rollup-linux-x64-musl --save-dev
RUN npm install lightningcss-linux-x64-musl --save-dev
RUN npm install @tailwindcss/oxide-linux-x64-musl --save-dev

# Copy source code
COPY . .

# Generate SvelteKit configuration
RUN npm run prepare

# Build the application
RUN npm run build

# Production stage
FROM node:20-alpine AS runtime

# Install runtime dependencies
RUN apk add --no-cache curl

WORKDIR /app

# Copy package files and install dependencies
COPY --from=builder /app/package*.json ./
RUN npm ci && \
    npm cache clean --force

# Copy built application from builder stage
COPY --from=builder /app/build ./build

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S sveltekit -u 1001

# Change ownership of app directory
RUN chown -R sveltekit:nodejs /app

# Switch to non-root user
USER sveltekit

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Start the application with debugging and error handling
CMD ["sh", "-c", "echo 'Starting SvelteKit application...' && ls -la build/ && echo 'Node version:' && node --version && echo 'NPM version:' && npm --version && echo 'Starting server...' && node build/index.js || (echo 'Server failed, showing error details:' && cat build/index.js | head -20)"]