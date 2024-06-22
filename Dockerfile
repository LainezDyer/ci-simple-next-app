FROM node:lts-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build  # Esto creará el directorio /.next

FROM node:lts-alpine
WORKDIR /app
COPY --from=builder /app/.next /app/.next
COPY --from=builder /app/package*.json ./
RUN if [ -d /app/public ]; then mkdir -p /app/public && cp -r /app/public /app/public; fi
RUN npm install --only=production
EXPOSE 3000
CMD ["npm", "start"]
