FROM node:20-alpine
COPY . .
RUN npm install && npm run build

FROM nginx:stable-alpine
COPY --from=0 /build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]