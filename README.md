# _Trillium Bridge Transformer_

## Project Setup

1. Install [Git](http://git-scm.com/book/en/Getting-Started-Installing-Git)
2. Install [Maven](http://maven.apache.org/download.cgi)
3. Clone the repository using a Git Clone ```https://github.com/kevinpeterson/trillium-bridge-transformer.git```

## Build/Compile
From the ```trillium-bridge-transformer``` directory, run ```mvn clean install```
This will produce several artifacts, including a ZIP/TAR file will all necessary components. This artifacts will be located in the directory:

    trillium-bridge-transformer/trillium-bridge-transformer-cli/target/dist
and are named:

    trillium-bridge-transformer-cli-{version}-bin.zip
and

    trillium-bridge-transformer-cli-{version}-bin.tar.gz

## Testing

From the ```trillium-bridge-transformer``` directory, run ```mvn clean test```

## Contributing changes

1. Fork the repository
2. Send a pull request

## License
All artifacts are licensed under the [Apache License](http://www.apache.org/licenses/LICENSE-2.0.txt).
