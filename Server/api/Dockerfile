FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Expose port (Railway will set PORT env var, we use it dynamically)
# EXPOSE is just documentation, actual port comes from PORT env var
EXPOSE 8080

# Start the application
CMD ["npm", "start"]

