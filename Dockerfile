# -------- Stage 1: Build Flutter Web --------
FROM ubuntu:22.04 AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Set up Flutter
ENV FLUTTER_HOME=/opt/flutter
RUN git clone https://github.com/flutter/flutter.git -b 3.16.0 /opt/flutter
RUN flutter build web --no-wasm-dry-run
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter channel stable && flutter upgrade
RUN flutter config --enable-web

# Pre-cache
RUN flutter precache

# Copy project
WORKDIR /app
COPY . .

# Get dependencies
RUN flutter pub get

# Build web app
RUN flutter build web --release --no-wasm-dry-run

# -------- Stage 2: Serve with Nginx --------
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built Flutter web files
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx config (optional but recommended)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port (Railway uses 8080 internally)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
