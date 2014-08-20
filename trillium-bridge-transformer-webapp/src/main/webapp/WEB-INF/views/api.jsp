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
                <li><a href="docs"> Documentation</a>
                <li class="divider-vertical"></li>
                <li><a href="api"> REST API</a>
                <li class="divider-vertical"></li>
            </ul>

        </div>
    </div>
</div>

<div class="container">

    <h2>Convert epSOS to CCDA</h2>
    <p>Convert an XML representation of epSOS to CCDA format</p>
    <div style="border: 1px solid #ccc; padding: 10px">
        <h2>File Upload</h2>
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
            <dd><strong>Allowed Values: </strong><code>??</code> or <code>??</code></dd>
            <dd><strong>Default: </strong><code>xml</code></dd>
        </dl>
        <h3>Example</h3>
<pre class="highlight">
curl -X POST -F file=@/path/to/QDM.xml <span class="url"></span>qdm2json
</pre>
    </div>

    <h2>Convert CCDA to epSOS</h2>
    <p>Convert an XML representation of CCDA to epSOS format</p>
    <div style="border: 1px solid #ccc; padding: 10px">
        <h2>File Upload</h2>
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
            <dd><strong>Allowed Values: </strong><code>??</code> or <code>??</code></dd>
            <dd><strong>Default: </strong><code>xml</code></dd>
        </dl>
        <h3>Example</h3>
<pre class="highlight">
curl -X POST -F file=@/path/to/QDM.xml <span class="url"></span>qdm2json
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
            Powered by the <a href="https://github.com/projectcypress/health-data-standards">hqmf-parser</a>,
            <a href="https://ushik.ahrq.gov/">USHIK</a>,
            and the <a href="https://vsac.nlm.nih.gov/">NLM VSAC</a>,
            For more information see the
            <a href="http://phenotypeportal.org/">Phenotype Portal</a>.
        </p>
    </div>
</footer>
</body>
</html>
