# TagPipe API Documentation [![Travis CI Status](https://travis-ci.org/thingsinmotion/docs.svg?branch=master)](https://travis-ci.org/thingsinmotion/docs

Source markdown used to create the API usage documentation using [Slate](https://github.com/lord/slate)

## Maintenance

See [Slates Markdown Documentation](https://github.com/lord/slate/wiki/Markdown-Syntax) for how to update the source.

## Running Locally

1.  Build the source using [Docker Compose](https://docs.docker.com/compose/)

    ```
    docker-compose up --build
    ```

1.  Open the `./build/index.html` file in you favourite browser

## Deployment

1.  Build the source using [Docker Compose](https://docs.docker.com/compose/)

    ```
    docker-compose up --build
    ```

1.  Use the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) to upload files to S3

    ```
    aws s3 sync ./build s3://docs.thingsinmotion.io/ --delete --acl public-read
    ```