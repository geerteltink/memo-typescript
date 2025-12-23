FROM node:18.20.8-alpine As development

WORKDIR /usr/src/app

# Copy dependency config
COPY package*.json ./

# Install development dependencies
RUN npm install --only=development

# Copy source
COPY . .

# Build application
# The dev dependencies are always needed to build, even production
RUN npm run build

FROM node:18.20.8-alpine as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

# Copy dependency config
COPY package*.json ./

# Install production dependencies only
RUN npm install --only=production

# Copy source
COPY . .

# Copy the compiled source
COPY --from=development /usr/src/app/dist ./dist

CMD ["node", "dist/main"]
