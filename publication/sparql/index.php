<?php echo '<?xml version="1.0" encoding="UTF-8" ?>'; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html version="-//W3C//DTD XHTML 1.1//EN"
    xmlns="http://www.w3.org/1999/xhtml"
    xml:lang="en"
>
<head>
    <title>Virtuoso SPARQL Query Editor</title>
    <meta name="Copyright" content="Copyright &copy; 2014 OpenLink Software" />
    <meta name="Keywords" content="OpenLink Virtuoso Sparql" />
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />


<style type="text/css">
/*<![CDATA[*/
html { padding: 0; }
body {
padding: 0;
margin: 0;
font-family:Gill Sans, Arial, Helvetica, sans-serif;
font-size: 9pt;
color: #333;
background-color: #FDFDFD;
}
#header {
padding: 0;
margin: 0;
background-color: #86B9D9;
color: #FFFFFF;
border-bottom: 1px solid #AAA;
}
#header h1 {
font-size: 16pt;
font-weight: normal;
text-align: left;
vertical-align: middle;
padding: 4px 8px 4px 8px;
margin: 0px 0px 0px 0px;
}
#menu {
margin-left: 8px;
margin-right: 8px;
margin-top: 0px;
clear: right;
float: right;
}
#intro,#main {
margin-left: 8px;
margin-right: 8px;
}
#help {
margin-left: 8px;
margin-right: 8px;
width: 80%
}
#footer {
width: 100%;
float: left;
clear: left;
margin: 2em 0 0;
padding-top: 0.7ex;
border-top: 1px solid #AAA;
font-size: 8pt;
text-align: center;
}
fieldset {
border: 0;
padding: 0;
margin: 0;
}
fieldset label {
font-weight: normal;
white-space: nowrap;
font-size: 11pt;
color: #000;
}
fieldset label.n {
display: block;
vertical-align: bottom;
margin-top:5px;
width: 160px;
float:left;
white-space: nowrap;
}
fieldset label.n:after { content: ":"; }
fieldset label.n1 {
display: block;
vertical-align: bottom;
margin-top:5px;
width: 160px;
float:left;
white-space: nowrap;
}
fieldset label.ckb {
width: 160px;
font-weight: normal;
font-size: 10pt;
}
fieldset label.ckb:after { content: ""; }
fieldset textarea {
width: 99%;
font-family: monospace;
font-size: 10pt;
}
#cxml {
clear: both;
display: block;
}
#savefs {
clear: both;
display: block;
}
span.info {
font-size: 9pt;
white-space: nowrap;
height: 2em;
}
br { clear: both; }
/*]]>*/
</style>

    <script type="text/javascript">
    /*<![CDATA[*/
	var last_format = 0;
	function format_select(query_obg)
	{
		var query = query_obg.value; 
		var format = query_obg.form.format;

		if ((query.match(/\bconstruct\b/i) || query.match(/\bdescribe\b/i)) && last_format != 2) {
			for(var i = format.options.length; i > 0; i--)
				format.options[i] = null;
			format.options[1] = new Option('Turtle','text/turtle');
			format.options[2] = new Option('Pretty-printed Turtle (slow!)','application/x-nice-turtle');
			format.options[3] = new Option('RDF/JSON','application/rdf+json');
			format.options[4] = new Option('RDF/XML','application/rdf+xml');
			format.options[5] = new Option('N-Triples','text/plain');
			format.options[6] = new Option('XHTML+RDFa','application/xhtml+xml');
			format.options[7] = new Option('ATOM+XML','application/atom+xml');
			format.options[8] = new Option('ODATA/JSON','application/odata+json');
			format.options[9] = new Option('JSON-LD','application/x-json+ld');
			format.options[10] = new Option('HTML (list)','text/x-html+ul');
			format.options[11] = new Option('HTML (table)','text/x-html+tr');
			format.options[12] = new Option('HTML+Microdata (inconvenient)','text/html');
			format.options[13] = new Option('HTML+Microdata (pretty-printed table)','application/x-nice-microdata');
			format.options[14] = new Option('Turtle-style HTML (for browsing, not for export)','text/x-html-nice-turtle');
			format.options[15] = new Option('Microdata/JSON','application/microdata+json');
			format.options[16] = new Option('CSV','text/csv');
			format.options[17] = new Option('TSV','text/tab-separated-values');
			format.options[18] = new Option('TriG','application/x-trig');
			format.selectedIndex = 1;
			last_format = 2;
		}

		if (!(query.match(/\bconstruct\b/i) || query.match(/\bdescribe\b/i)) && last_format != 1) {
			for(var i = format.options.length; i > 0; i--)
				format.options[i] = null;
			format.options[1] = new Option('HTML','text/html');
			format.options[2] = new Option('Spreadsheet','application/vnd.ms-excel');
			format.options[3] = new Option('XML','application/sparql-results+xml');
			format.options[4] = new Option('JSON','application/sparql-results+json');
			format.options[5] = new Option('Javascript','application/javascript');
			format.options[6] = new Option('Turtle','text/turtle');
			format.options[7] = new Option('RDF/XML','application/rdf+xml');
			format.options[8] = new Option('N-Triples','text/plain');
			format.options[9] = new Option('CSV','text/csv');
			format.options[10] = new Option('TSV','text/tab-separated-values');
			format.selectedIndex = 1;
			last_format = 1;
		}
	}

function format_change(e)
{
var format = e.value;
var cxml = document.getElementById("cxml");
if (!cxml) return;
if ((format.match (/\bCXML\b/i)))
{
cxml.style.display="block";
} else {
cxml.style.display="none";
}
}
function savedav_change(e)
{
var savefs = document.getElementById("savefs");
if (!savefs) return;
if (e.checked)
{
savefs.style.display = "block";
}
else
{
savefs.style.display = "none";
}
}
function sparql_endpoint_init()
{
var cxml = document.getElementById("cxml");
if (cxml) cxml.style.display="none";
var savefs = document.getElementById("savefs");
if (savefs) savefs.style.display="none";
}
    /*]]>*/
    </script>
</head>
<body onload="sparql_endpoint_init()">
    <div id="header">
	<h1>Virtuoso SPARQL Query Editor</h1>
    </div>

    <div id="menu">
	  <a href="/sparql?help=intro">About</a>
	| <a href="/sparql?nsdecl">Namespace Prefixes</a>
	| <a href="/sparql?rdfinf">Inference rules</a>
    </div>

    <div id="main">
    <br />
	<form action="http://<?php echo $_SERVER['SERVER_NAME']?>:8890/sparql" method="get">
	<fieldset>
		<label for="default-graph-uri">Default Data Set Name (Graph IRI)</label><br />
		<input type="text" name="default-graph-uri" id="default-graph-uri" value="<?php echo $_GET["prefilled-graph"]; ?>" size="80"/>
		<br /><br />
		<label for="query">Query Text</label><br />
		<textarea rows="18" cols="80" name="query" id="query" onchange="format_select(this)" onkeyup="format_select(this)">select distinct ?Concept where {[] a ?Concept} LIMIT 100</textarea>
		<br /><br />
		<span class="info"><i>(Security restrictions of this server do not allow you to retrieve remote RDF data, see <a href="/sparql?help=enable_sponge">details</a>.)</i></span>
		<br />
		<label for="format" class="n">Results Format</label>
		<select name="format" id="format" onchange="format_change(this)">
			<option value="auto" >Auto</option>
			<option value="text/html" selected="selected">HTML</option>
			<option value="application/vnd.ms-excel" >Spreadsheet</option>
			<option value="application/sparql-results+xml" >XML</option>
			<option value="application/sparql-results+json" >JSON</option>
			<option value="application/javascript" >Javascript</option>
			<option value="text/turtle" >Turtle</option>
			<option value="application/rdf+xml" >RDF/XML</option>
			<option value="text/plain" >N-Triples</option>
			<option value="text/csv" >CSV</option>
			<option value="text/tab-separated-values" >TSV</option>
		</select>
		<br />
		<label for="timeout" class="n">Execution timeout</label>
		<input name="timeout" id="timeout" type="text" value="0" /> milliseconds
		<span class="info"><i>(values less than 1000 are ignored)</i></span>		<br />
		<label class="n" for="options">Options</label>
		<fieldset id="options">
		<input name="debug" id="debug" type="checkbox" checked="checked"/>
		<label for="debug" class="ckb">Strict checking of void variables</label>
		</fieldset>
		<br />
		<span class="info"><i>(The result can only be sent back to browser, not saved on the server, see <a href="/sparql?help=enable_det">details</a>)</i></span>
		<br />
		<br />
		<input type="submit" value="Run Query"/>
		<input type="reset" value="Reset"/>
	</fieldset>
	</form>
    </div>

    <div id="footer">
	Copyright &copy; 2014 <a href="http://www.openlinksw.com/virtuoso">OpenLink Software</a><br />Virtuoso version 07.10.3211 on Linux (x86_64-unknown-linux-gnu), Single Server Edition
    </div>
    <div xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
         xmlns="http://www.w3.org/1999/xhtml"
         xmlns:sd="http://www.w3.org/ns/sparql-service-description#"
         xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
         style="display:none">
       <div class="description" about="" typeof="sd:Service">
          <div rel="sd:endpoint" resource="http://sveto.odn.in.eea.sk:8890/sparql"/>
          <div rel="sd:feature"
               resource="http://www.w3.org/ns/sparql-service-description#UnionDefaultGraph"/>
          <div rel="sd:feature"
               resource="http://www.w3.org/ns/sparql-service-description#DereferencesURIs"/>
          <div rel="sd:resultFormat" resource="http://www.w3.org/ns/formats/RDF_XML"/>
          <div rel="sd:resultFormat" resource="http://www.w3.org/ns/formats/Turtle"/>
          <div rel="sd:resultFormat"
               resource="http://www.w3.org/ns/formats/SPARQL_Results_CSV"/>
          <div rel="sd:resultFormat" resource="http://www.w3.org/ns/formats/N-Triples"/>
          <div rel="sd:resultFormat" resource="http://www.w3.org/ns/formats/N3"/>
          <div rel="sd:resultFormat"
               resource="http://www.w3.org/ns/formats/SPARQL_Results_JSON"/>
          <div rel="sd:resultFormat" resource="http://www.w3.org/ns/formats/RDFa"/>
          <div rel="sd:resultFormat"
               resource="http://www.w3.org/ns/formats/SPARQL_Results_XML"/>
          <div rel="sd:supportedLanguage"
               resource="http://www.w3.org/ns/sparql-service-description#SPARQL10Query"/>
          <div rel="sd:url" resource="http://sveto.odn.in.eea.sk:8890/sparql"/>
       </div>
    </div>
</body>
</html>

