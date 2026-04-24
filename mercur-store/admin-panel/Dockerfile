FROM node:20-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache python3 make g++ git

# Copy package files
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy project files
COPY . .

# Build the application
RUN yarn build

# Expose port (Vite default is 5173, but we can configure it)
EXPOSE 7001

# Start command
CMD ["yarn", "dev", "--host", "0.0.0.0", "--port", "7001"]
