FROM node:13.10.1-slim as builder


COPY package.json .
COPY yarn.lock .
COPY public ./public
COPY src ./src

RUN yarn install
RUN npm run build

FROM nginx AS serve
COPY nginx-heroku.conf /etc/nginx/conf.d/default.conf
COPY --from=builder ./build /etc/nginx/html
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'