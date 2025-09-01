# Use the official Node.js 22 image as the base image
FROM node:22-alpine

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

# Install only production dependencies for runtime
RUN npm ci --only=production && npm cache clean --force

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
