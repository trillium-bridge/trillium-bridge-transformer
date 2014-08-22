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

## Distribution Package
The ```trillium-bridge-transformer-cli-{version}-bin.{suffix}``` package will contain the following structure (see footnotes below for further information on the various parts):

```
├── bin
│   ├── ccda2epsos             <- (1)
│   ├── ccda2epsos.bat         <- (2)
│   ├── epsos2ccda             <- (3)
│   ├── epsos2ccda.bat         <- (4)
│   ├── tbt-webapp             <- (5)
│   └── tbt-webapp.bat         <- (6)
├── conf
│   ├── nooptransform          <- (7)
│   ├── outputformats          <- (8)
│   │   ├── CDA.xsl
│   │   └── outputformats.json
│   └── xslt                   <- (9)
│       ├── noop.xsl
│       └── xslt.properties
├── doc
│   └── README.txt
├── lib
│   └── *.jar <- Java jar dependencies
└── webapp
    ├── logs
    │   ├── error.log           <- (10)
    │   └── output.log          <- (11)
    └── trillium-bridge-transformer-webapp-{version}.war <- (12)
```
##### Footnotes
__(1)__ ```ccda2epsos``` the Unix launch file for the CCDA to epSOS transformation

__(2)__ ```ccda2epsos.bat``` the Windows launch file for the CCDA to epSOS transformation

__(3)__ ```ccda2epsos``` the Unix launch file for the epSOS to CCDA transformation

__(4)__ ```epsos2ccda.bat``` the Windows launch file for the epSOS to CCDA transformation


All above commands allow the following parameters:

```
(ccda2epsos | epsos2ccda) inputFile
 -f (-format, --format) [xml | html | pdf]  : The output format
 -h (-help, --help)                         : Print this message
 -v (-version, --version)                   : Print the application version
 
example: ccda2epsos -f html ../my/ccda.xml
```
__(5)__ ```tbt-webapp``` the Unix launch file for the web applcation

__(6)__ ```tbt-webapp.bat``` is the Windows launch file for the web applcation

```
Usage: tbt-webapp(.bat) [--help|--version] [ server opts] [[ context opts] context ...]
Server opts:
 --version                           - display version and exit
 --log file                          - request log filename (with optional 'yyyy_mm_dd' wildcard
 --out file                          - info/warn/debug log filename (with optional 'yyyy_mm_dd' wildcard
 --host name|ip                      - interface to listen on (default is all interfaces)
 --port n                            - port to listen on (default 8080)
 --stop-port n                       - port to listen for stop command
 --stop-key n                        - security string for stop command (required if --stop-port is present)
 [--jar file]*n                      - each tuple specifies an extra jar to be added to the classloader
 [--lib dir]*n                       - each tuple specifies an extra directory of jars to be added to the classloader
 [--classes dir]*n                   - each tuple specifies an extra directory of classes to be added to the classloader
 --stats [unsecure|realm.properties] - enable stats gathering servlet context
 [--config file]*n                   - each tuple specifies the name of a jetty xml config file to apply (in the order defined)
Context opts:
 [[--path /path] context]*n          - WAR file, web app dir or context xml file, optionally with a context path
 
example: tbt-webapp --port 5150
 ```


## Testing

From the ```trillium-bridge-transformer``` directory, run ```mvn clean test```

## Contributing changes

1. Fork the repository
2. Send a pull request

## License
All artifacts are licensed under the [Apache License](http://www.apache.org/licenses/LICENSE-2.0.txt).
