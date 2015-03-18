# _Trillium Bridge Transformer_

### _Bridging Patient Summaries across the Atlantic_

> The Trillium Bridge support action extends the European Patient Summaries and Meaningful Use II, Transitions of Care in the United States to establish an interoperability bridge that will benefit EU and US citizens alike, advancing eHealth innovation and contributing to the triple win: quality care, sustainability and economic growth --&nbsp;<cite>http://www.trilliumbridge.eu</cite>

The _Trillium Bridge Transformer_ is a Java API, Command Line Interface, and Web-based Application to translate between epSOS
Patient Summary documents and HL7 C-CDA Continuity of Care Documents (CCD).

**Table of Contents**

- [Trillium Bridge Transformer](#user-content-trillium-bridge-transformer)
	- [Project Setup](#user-content-project-setup)
	- [Build/Compile](#user-content-buildcompile)
	- [Download/Install](#user-content-downloadinstall)
	- [Distribution Package](#user-content-distribution-package)
			- [Components](#user-content-components)
	- [Transformations](#user-content-transformations)
		- [Configuring the CCDA <-> epSOS Transformation](#user-content-configuring-the-ccda---epsos-transformation)
		- [Configuring the Output Format Transformation](#user-content-configuring-the-output-format-transformation)
	- [Web Application Deployment](#user-content-web-application-deployment)
	- [Java API](#user-content-java-api)
	- [Testing](#user-content-testing)
	- [Contributing changes](#user-content-contributing-changes)
	- [License](#user-content-license)
	
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
Download the latest [ZIP](m-bridge-transformer-cli/maven-metadata.xml (387 B at 1.3 KB/sec)
Uploading: http://informatics.mayo.edu/maven/content/repositories/snapshots/edu/mayo/trillium-bridge-transformer-cli/1.0.0.RC5-SNAPSHOT/trillium-bridge-transformer-cli-1.0.0.RC5-20150318.185001-4-bin.zip) or [TAR.GZ](http://informatics.mayo.edu/maven/content/repositories/snapshots/edu/mayo/trillium-bridge-transformer-cli/1.0.0.RC5-SNAPSHOT/trillium-bridge-transformer-cli-1.0.0.RC5-20150318.185001-4-bin.tar.gz) binary distribution. For installation, extract the archive to the desired location on the filesystem.
t the archive to the desired location on the filesystem.


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
│   ├── cts2fileservice        <- (7)
│   │   └── map
│   ├── nooptransform          <- (8)
│   ├── outputformats          <- (9)
│   │   ├── CDA.xsl
│   │   └── outputformats.json
│   ├── schema
│   │   ├── CDA_R2_NormativeWebEdition2010  <- (10)
│   │   └── TBXform.xsd        <- (11)
│   ├── tbxform
│   │   ├── CCDtoEPSOS.xml    <- (12)
│   │   ├── EPSOStoCCD.xml    <- (13)
│   │   └── ValueSetMaps.xml         <- (14)
│   ├── translation            <- (15)
│   │   ├── it-to-en.xml
│   │   └── en-to-es.xml
│   └── xslt
│       ├── CCD.xsl            <- (16)
│       ├── CCD-IT.xsl         <- (17)
│       ├── CTS2Access.xsl     <- (18)
│       ├── TBTransformations.xsl <- (19)
│       ├── TBXform.xsl        <- (20)
│       ├── ccd2epsos.xsl      <- (21)
│       ├── ccda2epsos_options.json   <- (22)
│       ├── epsos2ccd.xsl      <- (23)
│       ├── epsos2ccda_options.json   <- (24)
│       └── xslt.properties    <- (25)
├── doc
│   └── README.txt
├── lib
│   └── *.jar <- Java jar dependencies
└── webapp
    ├── logs
    │   ├── error.log           <- (26)
    │   └── output.log          <- (27)
    └── trillium-bridge-transformer-webapp-{version}.war <- (28)
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

__Local CTS2 Service__
__(7)__ ```cts2fileservice``` - the root directory for the local file-based CTS2 service.  This is the place where you can put maps that aren't available externally as
well as resources that need to be cached locally.  The directory structure matches the CTS2 REST service interface.


__Transformations__

__(8)__ ```nooptransform``` - the implementaion of the no-op direct copy CCDA <-> epSOS transform. This will be deprecated and replaced with a live transform.

__(9)__ ```outputformats``` - specification of output format XSLT transformations. See [here](#configuring-the-output-format-transformation) for more inforamation on output format configuration


__Schema__

__(10)__ ```CDA_R2_NormativeWebEdition2010``` - CDA schema directory for resolving CDA document headers

__(11)__ ```TBXform.xsd``` - the XML Schema that defines the [transformation rules](#xform-rules), [value set maps](#vsmaps) and [language transformation](#langxform) tables


__Transformation Tables__

__(12)__ ```CCDtoEPSOS.xml``` CCD to EPSOS transformation table. The structure is defined by ```TBXform.xsd````

__(13)__ ```EPSOStoCCD.xml``` EPSOS to CCD transformation table. The structure is defined by ```TBXform.xsd````

__(14)__ ```ValueSetMaps.xml``` Value Set Mapping table.  This controls which file(s) or service(s) are used to resolve code and value maps. The structure is defined by ```TBXform.xsd````

__Translation Tables__

__(15)__ ```translations``` - Translation tables. File names are in the form "{from-language}to{to-language}.xml". The structure is defined by ```TBXform.xsd````


__XSLT Files__ specification the main CCDA/epSOS XSLT transformations.

__(16)__ ```CCD.xsl``` - Default client-side html formatter for CCD data

__(17)__ ```CCD_IT.xsl``` -  Italian language html formatter for CCD data (example)

__(18)__ ```CTS2Access.xsl``` - XSLT templates and functions for doing CTS2 based code and value transforms

__(19)__ ```TBTransformations.xsl``` - XSLT function library for transformations

__(20)__ ```TBXform.xsl``` - The main transformation engine that traverses an epSOS or CCD document and applies the rules in the transformation rules table

__(21)__ ```ccd2epsos.xsl``` - The entry point for CCD to EPSOS transforms

__(22)__ ```ccda2epsos_options.json``` - Description of screen options (parameters) for the ccda to epsos transformation

__(23)__ ```epsos2ccd.xsl``` - The entry point for EPSOS to CCD transformations

__(24)__ ```epsos2ccda_options.json``` - Description of screen options (parameters) for the epsos to ccda transformation

__(25)__ ```xslt.properties``` - Transformation configuration file. See [here](#configuring-the-ccda---epsos-transformation) for more information on CCDA/epSOS XSLT configuration.



__Web Application__

__(26)__ ```error.log``` - the standard error log of the web application.

__(27)__ ```output.log``` - the standard output log of the web application.

__(28)__ ```trillium-bridge-transformer-webapp-{version}.war``` - the web application archive. This can be then deployed to an application server such as Tomcat, JBoss, etc.

## Transformations
There are two different transformation phases. The first phase transforms CCDA XML to epSOS XML (or vice versa). The next phase takes that resulting transformed XML and converts it to a desired output format (such as HTML).

### Configuring the CCDA <-> epSOS Transformation
The ```conf/xslt/xslt.properties``` file is the configuration file used to configure the XSLTs used to execute the transformation, and had the following format:

```
xslt.epsos2ccda=TBXform.xsl
xslt.ccda2epsos=TBXform.xsl
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

## Java API
To use the Java API directly, first add the Maven repository to your pom.xml file :

```xml
...
<repository>
  <id>informatics-releases</id>
  <url>http://informatics.mayo.edu/maven/content/repositories/releases</url>
</repository>
...
```
Then, add the Maven dependency:

```xml
<dependency>
    <artifactId>trillium-bridge-transformer-core</artifactId>
    <groupId>edu.mayo</groupId>
    <version>--version-here--</version>
</dependency>
```

To get started using the API, instantiate the transfomer:

```java
TrilliumBridgeTransformer transformer = new XsltTrilliumBridgeTransformer();
```

The interface for the transformer is as follows:

```java
/**
 * Transformation interface for converting XML files to and from CCDA and epSOS format.
 */
public interface TrilliumBridgeTransformer {

    /**
     * Valid output formats
     */
    public enum Format {XML, HTML, PDF}

    /**
     * Convert a CCDA XML document into epSOS format.
     *
     * @param ccdaStream the CCDA document
     * @param epsosStream the output stream
     * @param outputFormat the output format
     */
    public void ccdaToEpsos(InputStream ccdaStream, OutputStream epsosStream, Format outputFormat);

    /**
     * Convert an epSOS XML document into CCDA format
     *
     * @param epsosStream the epSOS document
     * @param ccdaStream the output stream
     * @param outputFormat the output format
     */
    public void epsosToCcda(InputStream epsosStream, OutputStream ccdaStream, Format outputFormat);

}
```

## Testing
From the ```trillium-bridge-transformer``` directory, run ```mvn clean test```

## Contributing changes

1. Fork the repository
2. Send a pull request

## License
All artifacts are licensed under the [Apache License](http://www.apache.org/licenses/LICENSE-2.0.txt).
