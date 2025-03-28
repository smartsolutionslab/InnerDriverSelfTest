# --- Build Stage ---
FROM node:22-alpine AS build

# Set working directory
WORKDIR /app

# Enable corepack
RUN corepack enable

# Copy package files and installieren von Yarn
COPY package.json yarn.lock .yarnrc.yml ./
RUN yarn install

# Copy the entire project and build it
COPY . .
RUN yarn build

# --- Production Stage ---
FROM nginx:alpine

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: Custom nginx config (if you have one)
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
    
    
    