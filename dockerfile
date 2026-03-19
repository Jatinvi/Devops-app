FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm test

FROM node:18-alpine
RUN addgroup -g 1001 nodejs && adduser -S nextjs -u 1001
USER nextjs
WORKDIR /app
COPY --from=builder /app ./
EXPOSE 3000
HEALTHCHECK CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1
CMD ["node", "app.js"]
