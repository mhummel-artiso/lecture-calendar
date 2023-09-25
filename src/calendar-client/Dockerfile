# build environment
FROM node:18.17.1-alpine as install
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm install -g npm && npm config set legacy-peer-deps true && npm ci && npm install react-scripts -g

FROM install as build
ARG VITE_API_HOST="NOT SET"
ARG VITE_API_URL="NOT SET"
ARG VITE_OIDC_URL="NOT SET"
ARG VITE_OIDC_CLIENT_SECRET="NOT SET"
ARG VITE_OIDC_AUTHORITY="NOT SET"
ARG VITE_OIDC_ACCOUNT_URL="NOT SET"
ARG VITE_OIDC_REDIRECT_URL="NOT SET"
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY --from=install /app/node_modules /app/node_modules
COPY . ./
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
RUN mkdir -p /usr/share/nginx/html/health && echo "healthy" > /usr/share/nginx/html/health/index.html
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]