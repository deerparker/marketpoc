FROM node:20-alpine

WORKDIR /app

# Install dependencies needed for native modules (if any)
RUN apk add --no-cache python3 make g++

COPY package.json ./
# We can add yarn.lock or package-lock.json if it existed, but we'll let npm install run.
# Ideally we should use a lockfile. For now we generate it.

RUN npm install --legacy-peer-deps

COPY . .

# Build the project (if using TypeScript)
RUN npm run build

EXPOSE 9000

CMD ["npm", "run", "start"]
