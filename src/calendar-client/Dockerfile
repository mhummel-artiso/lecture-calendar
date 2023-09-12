# build environment
FROM node:18.17.1-alpine as install
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm install -g npm
RUN npm config set legacy-peer-deps true
RUN npm ci
RUN npm install react-scripts -g

FROM node:18.17.1-alpine as build
ARG VITE_API_URL=""
ARG VITE_OIDC_CLIENT_ID=""
ARG VITE_OIDC_AUTHORITY=""
ARG VITE_OIDC_REDIRECT_URL=""
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY --from=install /app/node_modules /app/node_modules
COPY . ./
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
RUN mkdir -p /usr/share/nginx/html/health
RUN echo "healthy" > /usr/share/nginx/html/health/index.html
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]