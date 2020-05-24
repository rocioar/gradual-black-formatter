FROM python:3.7-alpine3.10

# Install dependencies
RUN apk add --no-cache bash gcc musl-dev python3-dev git
RUN pip install black==19.10b0

# Setup docker entry point
COPY entrypoint.sh /usr/local/bin/

RUN ln -s /usr/local/bin/entrypoint.sh / # backwards compat

ENTRYPOINT ["entrypoint.sh"]
