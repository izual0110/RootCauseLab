FROM node:alpine

RUN apk add --no-cache ca-certificates

RUN npm i -g @openai/codex && npm cache clean --force

WORKDIR /work

ENTRYPOINT ["codex"]
