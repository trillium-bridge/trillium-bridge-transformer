<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Trillium Bridge Transformer</title>

    <script type="text/javascript" src="resources/include/jquery-ui-1.8.19.custom/js/jquery-1.7.2.min.js"></script>
    <script src="resources/include/bootstrap/js/bootstrap.min.js"></script>
    <script src="resources/include/bootstrap-fileupload/bootstrap-fileupload.min.js"></script>
    <script src="resources/include/select2/select2.min.js"></script>
    <script src="resources/include/syntaxhighlighter_3.0.83/scripts/shCore.js"></script>
    <script src="resources/include/syntaxhighlighter_3.0.83/scripts/shBrushJava.js"></script>

    <link rel="stylesheet" href="resources/include/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="resources/include/bootstrap-fileupload/bootstrap-fileupload.min.css">
    <link rel="stylesheet" href="resources/include/select2/select2.css">
    <link rel="stylesheet" href="resources/include/syntaxhighlighter_3.0.83/styles/shCore.css" />
    <link rel="stylesheet" href="resources/include/syntaxhighlighter_3.0.83/styles/shThemeDefault.css" />

    <link rel="stylesheet" href="resources/style.css">

    <style>
        body {
            padding-top: 65px;
        }
    </style>

    <script>
        $(document).ready(function() {
            SyntaxHighlighter.all();
        });
    </script>
</head>
<body>

<div class="navbar navbar-fixed-top">

    <div class="navbar-inner">

        <div class="container">
            <a href="https://github.com/SHARP-HTP/qdm-phenotyping"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png" alt="Fork me on GitHub"></a>

            <a class="brand" href="#">
                Trillium Bridge Transformer
            </a>

            <ul class="nav">
                <li class="divider-vertical"></li>
                <li><a href="."><i class="icon-home"></i> Home</a></li>
                <li class="divider-vertical"></li>
                <li><a href="http://informatics.mayo.edu/maven/content/repositories/releases/edu/mayo/trillium-bridge-transformer-cli/${version}/trillium-bridge-transformer-cli-${version}-bin.zip"><i class="icon-download-alt"></i> Download</a></li>
                <li class="divider-vertical"></li>
                <li><a href="https://github.com/kevinpeterson/trillium-bridge-transformer/blob/master/README.md"> Documentation</a>
                <li class="divider-vertical"></li>
                <li><a href="api"> REST API</a>
                <li class="divider-vertical"></li>
            </ul>

        </div>
    </div>
</div>

<div class="container">

    <div class="alert">
        <b>Important!</b> No data will be retained on the server as a result of the transformation process.
    </div>

    <h2>Convert epSOS to CCDA</h2>
    <p>Convert an XML representation of epSOS to CCDA format</p>
    <div style="border: 1px solid #ccc; padding: 10px">
        <h2>> File Upload</h2>
        <pre><code>POST /epsos2ccda</code></pre>
        <h3>Headers</h3>
        <dl>
            <dt>Content-Type</dt>
            <dd><code>multipart/form-data</code></dd>
        </dl>
        <h3>Parameters</h3>
        <dl>
            <dt>file</dt>
            <dd>The epSOS XML file.</dd>
        </dl>
        <dl>
            <dt>format</dt>
            <dd>The output format.</dd>
            <dd><strong>Allowed Values: </strong><code>xml</code> or <code>html</code> or <code>pdf</code></dd>
            <dd><strong>Default: </strong><code>xml</code></dd>
        </dl>
        <h3>Example</h3>
<pre class="highlight">
curl -X POST -F file=@/path/to/epsos.xml <span class="url"></span>epsos2ccda

curl -X POST -F file=@/path/to/epsos.xml "<span class="url"></span>epsos2ccda?format=html"
</pre>

        <ul class="nav nav-list">
            <li class="divider"></li>
        </ul>

        <h2>> POST XML Body</h2>
        <pre><code>POST /epsos2ccda</code></pre>
        <h3>Headers</h3>
        <dl>
            <dt>Content-Type</dt>
            <dd><code>application/xml</code></dd>
        </dl>
        <h3>Parameters</h3>
        <dl>
            <dt>POST Body</dt>
            <dd>The epSOS XML file.</dd>
        </dl>
        <dl>
            <dt>format</dt>
            <dd>The output format.</dd>
            <dd><strong>Allowed Values: </strong><code>xml</code> or <code>html</code> or <code>pdf</code></dd>
            <dd><strong>Default: </strong><code>xml</code></dd>
        </dl>
        <h3>Examples</h3>
<pre class="highlight">
curl -X POST --header "Content-Type:application/xml" -d@/path/to/epsos.xml <span class="url"></span>epsos2ccda

curl -X POST --header "Content-Type:application/xml" -d@/path/to/epsos.xml "<span class="url"></span>epsos2ccda?format=html"
</pre>
    </div>

    <h2>Convert CCDA to epSOS</h2>
    <p>Convert an XML representation of CCDA to epSOS format</p>
    <div style="border: 1px solid #ccc; padding: 10px">
        <h2>> File Upload</h2>
        <pre><code>POST /ccda2epsos</code></pre>
        <h3>Headers</h3>
        <dl>
            <dt>Content-Type</dt>
            <dd><code>multipart/form-data</code></dd>
        </dl>
        <h3>Parameters</h3>
        <dl>
            <dt>file</dt>
            <dd>The CCDA XML file.</dd>
        </dl>
        <dl>
            <dt>format</dt>
            <dd>The output format.</dd>
            <dd><strong>Allowed Values: </strong><code>xml</code> or <code>html</code> or <code>pdf</code></dd>            <dd><strong>Default: </strong><code>xml</code></dd>
        </dl>
        <h3>Examples</h3>
<pre class="highlight">
curl -X POST -F file=@/path/to/ccda.xml <span class="url"></span>ccda2epsos

curl -X POST -F file=@/path/to/ccda.xml "<span class="url"></span>ccda2epsos?format=html"
</pre>

        <ul class="nav nav-list">
            <li class="divider"></li>
        </ul>

        <h2>> POST XML Body</h2>
        <pre><code>POST /ccda2epsos</code></pre>
        <h3>Headers</h3>
        <dl>
            <dt>Content-Type</dt>
            <dd><code>application/xml</code></dd>
        </dl>
        <h3>Parameters</h3>
        <dl>
            <dt>POST Body</dt>
            <dd>The CCDA XML file.</dd>
        </dl>
        <dl>
            <dt>format</dt>
            <dd>The output format.</dd>
            <dd><strong>Allowed Values: </strong><code>xml</code> or <code>html</code> or <code>pdf</code></dd>
            <dd><strong>Default: </strong><code>xml</code></dd>
        </dl>
        <h3>Example</h3>
<pre class="highlight">
curl -X POST --header "Content-Type:application/xml" -d@/path/to/ccda.xml <span class="url"></span>ccda2epsos

curl -X POST --header "Content-Type:application/xml" -d@/path/to/ccda.xml "<span class="url"></span>ccda2epsos?format=html"
</pre>

    </div>

    <script>
        var value = location.href.substring(0, location.href.lastIndexOf('/') + 1);
        $('.url').html(value)
    </script>

</div>
<footer class="navbar navbar-fixed-bottom">
    <div class="container">
        <p class="muted credit">
            For more information see
            <a href="http://www.trilliumbridge.eu">Trillium Bridge</a>.
        </p>
    </div>
</footer>
</body>
</html>
