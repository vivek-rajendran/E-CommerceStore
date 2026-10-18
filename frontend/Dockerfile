# Stage 1: Build the React application
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

ENV CI=false
ENV DISABLE_ESLINT_PLUGIN=true
RUN npm run build

# Stage 2: Serve the built app using Nginx
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]