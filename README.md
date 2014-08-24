# _Trillium Bridge Transformer_


## Project Setup
1. Install [Java SDK 7+](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)
2. * Install [Git](http://git-scm.com/book/en/Getting-Started-Installing-Git)
3. * Install [Maven](http://maven.apache.org/download.cgi)
4. * Clone the repository using a Git Clone ```https://github.com/kevinpeterson/trillium-bridge-transformer.git```

(*) Not necessary unless bulding/compiling. See [downloads](#downloadinstall) for binary distributions. 

## Build/Compile
From the ```trillium-bridge-transformer``` directory, run ```mvn clean install```
This will produce several artifacts, including a ZIP/TAR.GZ file will all necessary components. This artifacts will be located in the directory:

    trillium-bridge-transformer/trillium-bridge-transformer-cli/target/dist
and are named:

    trillium-bridge-transformer-cli-{version}-bin.zip
and

    trillium-bridge-transformer-cli-{version}-bin.tar.gz

## Download/Install
Download the latest [ZIP](http://informatics.mayo.edu/maven/content/repositories/releases/edu/mayo/trillium-bridge-transformer-cli/1.0.0.RC1/trillium-bridge-transformer-cli-1.0.0.RC1-bin.zip) or [TAR.GZ](http://informatics.mayo.edu/maven/content/repositories/releases/edu/mayo/trillium-bridge-transformer-cli/1.0.0.RC1/trillium-bridge-transformer-cli-1.0.0.RC1-bin.tar.gz) binary distribution. For installation, extract the archive to the desired location on the filesystem.

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
#### Components
__Launch Scripts__

__(1)__ ```ccda2epsos``` - the Unix launch file for the CCDA to epSOS transformation

__(2)__ ```ccda2epsos.bat``` - the Windows launch file for the CCDA to epSOS transformation

__(3)__ ```ccda2epsos``` - the Unix launch file for the epSOS to CCDA transformation

__(4)__ ```epsos2ccda.bat``` - the Windows launch file for the epSOS to CCDA transformation


All above commands allow the following parameters:

```
(ccda2epsos | epsos2ccda) inputFile
 -f (-format, --format) [xml | html | pdf]  : The output format
 -h (-help, --help)                         : Print this message
 -v (-version, --version)                   : Print the application version
 
example: ccda2epsos -f html ../my/ccda.xml
```
__(5)__ ```tbt-webapp``` - the Unix launch file for the web applcation

__(6)__ ```tbt-webapp.bat``` - the Windows launch file for the web applcation

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

By default, web app will bind to port ```8080``` and be available at http://localhost:8080/


__Transformations__

__(7)__ ```nooptransform``` - the implementaion of the no-op direct copy CCDA <-> epSOS transform. This will be deprecated and replaced with a live transform.

__(8)__ ```outputformats``` - specification of output format XSLT transformations. See [here](#configuring-the-output-format-transformation) for more inforamation on output format configuration

__(9)__ ```xslt``` - specification the main CCDA/epSOS XSLT transformations. See [here](#configuring-the-ccda---epsos-transformation) for more infomation on CCDA/epSOS XSLT configuration.

__Web Application__

__(10)__ ```error.log``` - the standard error log of the web application.

__(11)__ ```output.log``` - the standard output log of the web application.

__(12)__ ```trillium-bridge-transformer-webapp-{version}.war``` - the web application archive. This can be then deployed to an application server such as Tomcat, JBoss, etc.

## Transformations
There are two different transformation phases. The first phase transforms CCDA XML to epSOS XML (or vice versa). The next phase takes that resulting transformed XML and converts it to a desired output format (such as HTML).

### Configuring the CCDA <-> epSOS Transformation
The ```conf/xslt/xslt.properties``` file is the configuration file used to configure the XSLTs used to execute the transformation, and had the following format:

```
xslt.epsos2ccda=noop.xsl
xslt.ccda2epsos=noop.xsl
```

This file should contain two entries as show -- one for each type of transformation. The value of the ```xslt.epsos2ccda``` and ```xslt.ccda2epsos``` properties should be the relative path to the XSLT used for conversion.

By default, the command line applications and the web application will introspect this file and utilize the specified XSLTs.

### Configuring the Output Format Transformation
The ```conf/outputformats/outputformats.json``` file is the configuration file used to configure available output formats and the XSLTs used to implement them, and has the following format:

```json
[
{
    "name": "CDA XSLT", // the name of the transformation
    "xslt": "CDA.xsl",  // the relative path to the XSLT
    "output": "HTML",   // the type of output (only HTML currently)
    "useFor": "BOTH"    // whether the tranform applies to 'CCDA', 'EPSOS', or 'BOTH'
},
{
//... more transforms
}
]
```
By default, the command line applications and the web application will introspect this file and utilize the specified XSLTs.

## Web Application Deployment
The Trillium Bridge Transformer comes with a built-in [Jetty](http://www.eclipse.org/jetty/) server, which can be started from the ```bin``` directory.

Alternatively, the web application can be deployed to an existing web container. To do this, first ensure the Trillium Bridge Transformer HOME enviroment variable (```TBT_HOME```) is set. This will allow the web application to find the user-specified XSLT configuration files. ```TBT_HOME``` should be set to the root directory of the installation packge:

```
TBT_HOME
    ├── bin 
    ├── conf
    ├── doc
    ├── lib
    └── webapp
```
Once ```TBT_HOME``` has been set, deploy the WAR file located in the ```webapp``` directory to the target web container. 

## Testing

From the ```trillium-bridge-transformer``` directory, run ```mvn clean test```

## Contributing changes

1. Fork the repository
2. Send a pull request

## License
All artifacts are licensed under the [Apache License](http://www.apache.org/licenses/LICENSE-2.0.txt).
