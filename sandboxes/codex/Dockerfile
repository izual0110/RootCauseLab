FROM node:alpine

RUN apk add --no-cache ca-certificates python3 py3-pip

RUN npm i -g @openai/codex && npm cache clean --force

WORKDIR /work

ENTRYPOINT ["codex"]
