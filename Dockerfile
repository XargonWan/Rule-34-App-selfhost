# Use the official Node.js 22 image as the base image
FROM node:22-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the Nuxt application
RUN npm run build

# Prepare Nuxt for production (needs dev dependencies)
RUN npm run postinstall

# Production stage
FROM node:22-alpine AS production

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install only production dependencies for runtime
RUN npm ci --only=production --ignore-scripts && npm cache clean --force

# Copy built application from builder stage
COPY --from=builder /app/.output ./.output

# Create a non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nuxt -u 1001

# Change ownership of the app directory to the nuxt user
RUN chown -R nuxt:nodejs /app
USER nuxt

# Expose the port that Nuxt will run on (default is 3000)
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
