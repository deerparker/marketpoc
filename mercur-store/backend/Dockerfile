FROM node:20-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache python3 make g++ git

# Copy package files
COPY package.json yarn.lock .yarnrc.yml ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy project files
COPY . .

# Build the application
RUN yarn build

# Expose port
EXPOSE 9000

# Run migrations and start (ignore user creation error if exists)
CMD ["sh", "-c", "yarn medusa db:migrate && (yarn medusa user -e admin@mercur.com -p admin || true) && yarn start"]
