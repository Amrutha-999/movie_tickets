# Stage 1: Build stage (if needed for future enhancements)
FROM alpine:latest AS builder

# Stage 2: Production stage
FROM nginx:alpine

# Install necessary packages
RUN apk add --no-cache curl

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the index.html file to nginx web directory
COPY index.html /usr/share/nginx/html/

# Copy custom nginx configuration (optional)
COPY nginx.conf /etc/nginx/nginx.conf

# Create a custom 404 page (optional)
RUN echo "<!DOCTYPE html><html><head><title>404 - Page Not Found</title></head><body><h1>404 - Page Not Found</h1><p>The page you're looking for doesn't exist.</p></body></html>" > /usr/share/nginx/html/404.html

# Expose port 80
EXPOSE 80

# Health check to ensure server is running
HEALgTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
