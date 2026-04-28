# -------- Stage 1: Build Flutter Web --------
FROM ubuntu:22.04 AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Set Flutter path
ENV FLUTTER_HOME=/opt/flutter

# Clone Flutter (choose stable or pinned version)
RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME
# ✅ SET PATH BEFORE USING FLUTTER
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:${PATH}"
# Verify Flutter works (optional but useful)
RUN flutter doctor

# Enable web
RUN flutter config --enable-web

# Pre-cache
RUN flutter precache

# App setup
WORKDIR /app
COPY . .

# Install dependencies
RUN flutter pub get

# Build web
RUN flutter build web --release --no-wasm-dry-run
ARG CACHE_BUST=1
RUN echo "Cache bust: $CACHE_BUST"

# -------- Stage 2: Serve with Nginx --------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/build/web /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
