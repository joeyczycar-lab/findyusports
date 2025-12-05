FROM node:18-alpine

WORKDIR /app

# Copy package files from Server/api
COPY Server/api/package*.json ./
COPY Server/api/tsconfig*.json ./

# Install dependencies
RUN npm ci

# Copy source code from Server/api
COPY Server/api/ .

# Build the application
RUN npm run build

# Expose port
EXPOSE 4000

# Start the application
CMD ["npm", "start"]

