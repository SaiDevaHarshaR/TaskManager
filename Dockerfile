# Use the official Node.js image with tag 14-alpine
FROM node:14-alpine as builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Next.js app
RUN npm run build

# Start a new image to reduce the final image size
FROM node:14-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the previous stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next

# Install production dependencies
RUN npm install --production

# Expose the port Next.js runs on (default is 3000)
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]
