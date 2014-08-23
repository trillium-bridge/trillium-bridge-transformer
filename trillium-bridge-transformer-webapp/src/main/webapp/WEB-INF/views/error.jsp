<!DOCTYPE HTML>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Error - Trillium Bridge Transformer</title>

<script type="text/javascript" src="resources/include/jquery-ui-1.8.19.custom/js/jquery-1.7.2.min.js"></script>
<script src="resources/include/bootstrap/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="resources/include/bootstrap/css/bootstrap.min.css">

<link rel="stylesheet" href="resources/style.css">


    <script type="text/javascript">
        $(document).ready(function() {
            $('.carousel').carousel();

            var value = location.hostname;
            $('.qdm2jsonUrl').attr("href", "${qdm2jsonUrl}");
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
    There was an error translating the provided content:
    <br/>
    <br/>
    <b>
    ${message}
    </b>
    <br/>
    <br/>
    </div>

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
