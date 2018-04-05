# Contributing

By contributing you agree to the [LICENSE](LICENSE) of this repository.


## Development

### Prerequisites

-   [Docker Compose](https://docs.docker.com/compose/)

### Getting Started

See [Slates Markdown Documentation](https://github.com/lord/slate/wiki/Markdown-Syntax) for how to update the source.

### Running Locally

1.  Build the source using [Docker Compose](https://docs.docker.com/compose/)

    ```
    docker-compose up --build
    ```

1.  Open the `./build/index.html` file in you favorite browser


## Deployment

### Automated

1.  Commit to the `master` branch (or merge a Merge Request into the `master` branch) to trigger the build process for the Test environment

1.  Once Test can be promoted to Production, create a **Production Git Tag** to trigger the build and deployment process for the Production environment e.g. `1.0.1`

### Manual

#### Prerequisites

-   [Docker Compose](https://docs.docker.com/compose/)
-   [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)

#### Instructions

1.  Build the source using [Docker Compose](https://docs.docker.com/compose/)

    ```
    docker-compose up --build
    ```

1.  Use the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) to upload files to S3

    Test Environment

    ```
    aws s3 sync ./build s3://docs-test.thingsinmotion.io/ --delete --acl public-read
    ```
    or 

    Production Environment

    ```
    aws s3 sync ./build s3://docs.thingsinmotion.io/ --delete --acl public-read
    ```