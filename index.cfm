<!--- Please insert your code here --->
<cfset stsearchpoint = "http://localhost">
<cfset stsearchport = "9200">

<cfset stQuery = QueryNew("size,from","integer,integer")>
<cfset QueryAddRow(stQuery, 1)>
<cfset stQuery["size"] = 10> <!--- size of returned results --->
<cfset stQuery["from"] = 1> <!--- start row --->
<cfset QueryAddColumn(StQuery,"query")>
<cfset QueryAddColumn(StQuery,"filtered")>
<cfset QueryAddColumn(StQuery,"match_all")>

<!--- this will return everything --->
<!---<cfset stQuery["query"]["filtered"]["query"]["match_all"] = {}>
--->
<cfset MyCFC = CreateObject("Component", "esui").init(stsearchpoint,stsearchport) />
<cfif isdefined("form.keyword")>
<cfif #len(form.keyword)# neq '0'>
<cfset st_keyword= "#form.keyword#">
<cfelse>
<cfset st_keyword= "">
</cfif>
<cfelse>
<cfset st_keyword= "">
</cfif>
<head>
<style>
	form{
		width:80%;
		margin:40px;
	}
	.keyword
	{
		background-color:yellow;
	}

</style>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
<link rel="signin.css">
</head>
<body>
<h2 id="top">File Search Form </h2>

<form action="index.cfm" method="post" class="form-inline">
  <div class="form-group">
    <label for="exampleInputKeyword">Key Word: </label>
	<cfoutput>
    <input type="text" class="form-control" id="Keyword" name="keyword" aria-describedby="Keyoword" placeholder="Enter keywords" value="#st_keyword#">
    </cfoutput>
    <!---<small id="KeywordHelp" class="form-text text-muted">Multiple Word with one Space: AND conditoin Search</small>--->
  </div>
  <button type="submit" class="btn btn-primary">Search</button>
</form>


<cfif isdefined("form.keyword")>
<cfif #len(form.keyword)# neq '0'>
<!--- this will return everything --->
<cfset st_argument="#st_keyword#">
<cfset index_count = 1>

<!--- this will return everything 
<cfset sQuery["query"]["filtered"]["query"]["match_all"] = {}>--->

<!--- this will return a simple queried result --->
<cfset sQuery["query"]["filtered"]["query"]["query_string"]["query"] = "#st_argument#">

<!--- this will return a specific attribute, for example a product type 
<cfset sQuery["query"]["filtered"]["query"]["match"]["ProductType"] = "Used">  --->


<!--- let's do the search --->
<cfset results = MyCFC.search('docs','doc',sQuery,st_argument) >

<cfset qParts = #arrayOfStructuresToQuery(results.result.hits.hits)#>



<div style="margin:20 50 20 50;">
<!-- Index Start -->
<cfoutput>
<ol>
<cfloop query="qParts">
<!--- Reset --->
<cfset st_virtual = "">
<cfset st_content = "">
<cfset st_filename = "">
<cfset st_last_modified = "">
<cfset st_resourcename = "">

<!--- Read One Record --->
<cfset stru_source= "#_source#">


<cfif StructKeyExists(stru_source, "content")>
	<CFSET STRU_CONTENT = #stru_source['content']#>
	<cfset st_content = #stru_content#>
	<cfset st_content = #ContentColorMark(st_content,st_argument)#>
</cfif>
<cfif StructKeyExists(stru_source, "meta")>
	<CFSET STRU_META= #stru_source['meta']#>
	<cfif StructKeyExists(STRU_META, "resourceName")>
	 <cfset st_resourcename = #STRU_META['resourceName']#>
	 <cfset st_resourcename = #ContentColorMark(st_resourcename,st_argument)#>
	<cfelse>
	 <cfset st_resourcename = "">
	</cfif>
</cfif>
<cfif StructKeyExists(stru_source, "file")>
	<CFSET STRU_FILE= #stru_source['file']#>

	<cfif StructKeyExists(STRU_FILE, "last_modified")>
	 <cfset st_last_modified = #STRU_FILE['last_modified']#>
	<cfelse>
	 <cfset st_last_modified = "">
	</cfif>
	<cfif StructKeyExists(STRU_FILE, "filename")>
	 <cfset st_filename = #STRU_FILE['filename']#>
	 <cfset st_filename = #ContentColorMark(st_filename,st_argument)#>
	<cfelse>
	 <cfset st_filename = "">
	</cfif>


</cfif>
<cfif StructKeyExists(stru_source, "path")>
	<CFSET STRU_PATH= #stru_source['path']#>
	<cfif StructKeyExists(STRU_PATH, "virtual")>
	 <cfset st_virtual = #STRU_PATH['virtual']#>
	 <cfset st_virtual = #replacenocase(st_virtual,'/','\','all')#>
	 <cfset st_virtual = #ContentColorMark(st_virtual,st_argument)#>
	<cfelse>
	 <cfset st_virtual = "">
	</cfif>
</cfif>




<cfif st_virtual neq "">

<li><a href="###st_virtual#"><strong>#st_virtual#</strong></a></Li>
</cfif>
</cfloop>
</ol>
</cfoutput>
<!-- Index End -->

<cfoutput>
<cfloop query="qParts">
<!--- Reset --->
<cfset st_virtual = "">
<cfset st_content = "">
<cfset st_filename = "">
<cfset st_last_modified = "">
<cfset st_resourcename = "">

<!--- Read One Record --->
<cfset stru_source= "#_source#">


<cfif StructKeyExists(stru_source, "content")>
	<CFSET STRU_CONTENT = #stru_source['content']#>
	<cfset st_content = #stru_content#>
	<cfset st_content = #ContentColorMark(st_content,st_argument)#>
</cfif>
<cfif StructKeyExists(stru_source, "meta")>
	<CFSET STRU_META= #stru_source['meta']#>
	<cfif StructKeyExists(STRU_META, "resourceName")>
	 <cfset st_resourcename = #STRU_META['resourceName']#>
	 <cfset st_resourcename = #ContentColorMark(st_resourcename,st_argument)#>
	<cfelse>
	 <cfset st_resourcename = "">
	</cfif>
</cfif>
<cfif StructKeyExists(stru_source, "file")>
	<CFSET STRU_FILE= #stru_source['file']#>

	<cfif StructKeyExists(STRU_FILE, "last_modified")>
	 <cfset st_last_modified = #STRU_FILE['last_modified']#>
	<cfelse>
	 <cfset st_last_modified = "">
	</cfif>
	<cfif StructKeyExists(STRU_FILE, "filename")>
	 <cfset st_filename = #STRU_FILE['filename']#>
	 <cfset st_filename = #ContentColorMark(st_filename,st_argument)#>
	<cfelse>
	 <cfset st_filename = "">
	</cfif>


</cfif>
<cfif StructKeyExists(stru_source, "path")>
	<CFSET STRU_PATH= #stru_source['path']#>
	<cfif StructKeyExists(STRU_PATH, "virtual")>
	 <cfset st_virtual = #STRU_PATH['virtual']#>
	 <cfset st_virtual = #replacenocase(st_virtual,'/','\','all')#>
	 <cfset st_virtual = #ContentColorMark(st_virtual,st_argument)#>
	<cfelse>
	 <cfset st_virtual = "">
	</cfif>
</cfif>



<button id="#st_virtual#"><a class="button" href="##top">Top</a></button>
<cfif st_filename neq "">
<h3>#st_filename#</h3>
</cfif>
<ul>
<cfif #st_last_modified# neq "">
	<li>Last Modified: #dateformat(st_last_modified,'mm/dd/yyyy')# #timeformat(st_last_modified,'HH:mm')#</li>
</cfif>
<cfif #st_virtual# neq "">
	<li>Location: <strong>K:#st_virtual#</strong></li>
</cfif>

<cfif #st_content# neq "">
	<li>Content: #st_content#</li>
</cfif>
</ul>
<hr>

</cfloop>
</cfoutput>
</div>
</cfif>
</cfif>


</body>

<Cffunction name="ContentColorMark" access="package" output="false" >
	<cfargument name="Cfsource" required="true" default="">
	<cfargument name="CfList1" required="true" default="">
	<Cfset cfresult = "#cfsource#">
	<cfloop list="#cflist1#" index="st_argument_index" delimiters = " ">
		<cfset st_arguemnt_list="#st_argument_index#">
		<cfset st_argument_html_list="<strong class=keyword>#st_argument_index#</strong>">
		<cfset cfresult ="#replacenocase(cfresult,st_arguemnt_list,st_argument_html_list,'all')#" >
</cfloop>
	<Cfreturn cfresult/>
</Cffunction>



<cffunction name="arrayOfStructuresToQuery" access="public">
<cfargument name="theArray" type="array">

<cfscript>
    var colNames = "";
    var theQuery = queryNew("");
    var i=0;
    var j=0;
    if(NOT arrayLen(theArray))
        return theQuery;
    colNames = structKeyArray(theArray[1]);
    theQuery = queryNew(arrayToList(colNames));
    queryAddRow(theQuery, arrayLen(theArray));
    for(i=1; i LTE arrayLen(theArray); i=i+1){
        for(j=1; j LTE arrayLen(colNames); j=j+1){
            querySetCell(theQuery, colNames[j], theArray[i][colNames[j]], i);
        }
    }
    return theQuery;
</cfscript>
</cffunction>
