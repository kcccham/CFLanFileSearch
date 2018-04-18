<cfcomponent output="false" >
  <cffunction name="init" access="public" returntype="any" >
    <!--- this just sets up the CFC with the elasticSearch URL and port --->
    <cfargument name="searchEndPoint" type="string" required="true"/>
    <cfargument name="searchPort" type="string" required="true"/>
       
    <cfset variables.searchEndPoint = arguments.searchEndPoint />
    <cfset variables.searchPort = arguments.searchPort />
    <cfreturn this />   
  </cffunction>
  
  <cffunction name="search" access="public" returntype="Struct" output="true">    
    <cfargument name="collection" type="string" required="true"> <!--- this is your "collection". Think database name --->  
    <cfargument name="type" type="string" required="true">  <!--- this is object type. Think table name --->    
    <cfargument name="sQuery" type="struct" required="true"> <!--- the query struct --->
    <cfargument name="routing" type="string" required="true" default=""> <!--- optional routing - see docs --->
    <cfset var pURL = "#variables.searchEndPoint#/#arguments.collection#/#arguments.type#/_search">
  
    <cfset checked = "&default_operator=AND">
    <cfif arguments.routing neq "">
     <cfset pURL = "#pURL#?q=*#arguments.routing#* #checked#">
    </cfif>
    <cfhttp port="#variables.searchPort#" url="#pURL#" method="GET">
      <cfhttpparam type="header" name="content-type" value="application/json">
 <!---     <cfhttpparam type="body" name="json" value="#SerializeJSON(sQuery)#">--->
    </cfhttp>
   
    <cfset var stResponse = {}>
    <cfif cfhttp.statusCode neq "200 OK">     
      <cfset stResponse.success=false />     
      <cfset stResponse.statusCode=cfhttp.statusCode />    
      <cfset stResponse.result = DeSerializeJSON(cfhttp.fileContent)/>  
      <cfset stResponse.incoming =sQuery>
    <cfelse>          
      <cfset stResponse.success=true />
      <cfset stResponse.result = DeSerializeJSON(cfhttp.fileContent)/>        
    </cfif>      
    <cfreturn stResponse />    
  </cffunction> 
  
  
  
  <cffunction name="delete" access="public" returntype="void">    
    <cfargument name="collection" type="string" required="true">    
    <cfhttp port="#variables.searchPort#" url="#variables.searchEndPoint#/#arguments.collection#" method="DELETE">
  </cffunction>
  
  <cffunction name="addItem" access="public" returntype="any">    
    <cfargument name="collection" type="string" required="true"><!--- this is your "collection" --->    
    <cfargument name="type" type="string" required="true"> <!--- this is your object type --->
    <cfargument name="id" type="string" required="true"> <!--- unique object ID --->    
    <cfargument name="item" type="struct" required="true"> <!--- the json object --->        
    <cfargument name="routing" type="string" required="true" default=""> 
    <cfset var pURL = "#variables.searchEndPoint#/#collection#/#arguments.type#/#arguments.id#">
    <cfif arguments.routing neq "">
     <cfset pURL = "#pURL#?routing=#arguments.routing#">
    </cfif>
    <cfhttp method="POST" port="#variables.searchPort#" url="#pURL#" result="httpRequest" timeout="20"  charset="utf-8"> 
      <cfhttpparam type="header" name="Content-Type" value="application/json; charset=utf-8" /> 
      <cfhttpparam type="body" value="#SerializeJSON(arguments.item)#">  
    </cfhttp> 
    <cfreturn httpRequest>
  </cffunction>
</cfcomponent>