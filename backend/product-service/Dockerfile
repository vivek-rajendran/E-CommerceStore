# Use lightweight Node.js base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application source code (including server.js)
COPY . .

# Expose the port the service runs on (adjust if your backend uses a different default port)
EXPOSE 3002

# Start the Node.js application
CMD ["node", "server.js"]