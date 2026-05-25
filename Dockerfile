# --- Stage 1: Build Environment ---
FROM node:18-alpine AS build
WORKDIR /app

# Install dependencies separately to leverage Docker layer caching
COPY package*.json ./
RUN npm ci

# Copy remaining source files and build the production assets
COPY . .
RUN npm run build

# --- Stage 2: Production Environment ---
FROM node:18-alpine AS production
WORKDIR /app

# Ensure security by enforcing the production environment variable
ENV NODE_ENV=production

# Create a secure, non-privileged system user and group
RUN addgroup -g 1001 -S nodejs && \
    adduser -u 1001 -S nodeuser -G nodejs

# Copy dependency manifests and install production-only modules
COPY package*.json ./
RUN npm ci --only=production

# Bring over compiled assets from the build stage
COPY --from=build /app/dist ./dist

# Assign directory ownership to the non-root execution user
RUN chown -R nodeuser:nodejs /app
USER nodeuser

EXPOSE 3000

CMD ["node", "dist/server.js"]
