FROM docker.io/node:latest

ENV NUXT_PUBLIC_KC_REALM_NAME=""
ENV NUXT_PUBLIC_KC_SERVER_URL=""
ENV NUXT_PUBLIC_KC_CLIENT_ID=""
ENV NUXT_PUBLIC_DOMAIN_URL=""
ENV NUXT_PUBLIC_BACKEND_URL=""

WORKDIR /home
COPY app.vue app.vue
COPY components/ components/
COPY nuxt.config.ts nuxt.config.ts
COPY package.json package.json
COPY pages/ pages/
COPY public/ public/
COPY tailwind.config.js tailwind.config.js

RUN npm install
RUN npm run build

EXPOSE 3000/tcp
ENV PORT=3000
CMD ["node",".output/server/index.mjs"]

