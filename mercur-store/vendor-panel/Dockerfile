FROM node:20-alpine

WORKDIR /app

COPY package.json ./

RUN npm install

COPY . .

# Expose the standard MercurJS Vendor Panel port
EXPOSE 7002

# Run Vite, listening on all interfaces and specific port
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "7002"]
