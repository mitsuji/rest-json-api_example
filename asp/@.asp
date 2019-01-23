<% @CodePage = 65001 %>
<% Option Explicit %>
<% Response.CodePage = 65001 %>
<% Response.ContentType = "application/json" %>
<%
Const constConnStr = "Provider=SQLOLEDB;Server=;Database=;User ID=;Password="

With Server.CreateObject("Nasp")
     .Name = Request.ServerVariables("URL")
     .AddScript Me
     .Process
End With


'' Routing
Function On_StartProcess(oNasp,vParam)
	 Select Case Request.ServerVariables("HTTP_MEDIATED_COMMAND")
	 Case "GetTodoList"  On_GetTodoList oNasp,vParam
	 Case "GetTodo"      On_GetTodo oNasp,vParam
	 Case "PostTodo"     On_PostTodo oNasp,vParam
	 Case "PutTodo"      On_PutTodo oNasp,vParam
	 Case "DeleteTodo"   On_DeleteTodo oNasp,vParam
	 Case Else           On_NotFound oNasp,vParam
	 End Select
End Function


Sub On_GetTodoList(oNasp,vParam)
    Dim oComm
    Set oComm = Server.CreateObject("ADODB.Command")
    oComm.CommandType = 1
    oComm.CommandText = "SELECT * FROM TTest_TodoList"
    oComm.ActiveConnection = constConnStr
    Dim oRS
    Set oRS = oComm.Execute
    
    Response.Write "["
    Dim i: i=0
    Do Until oRS.EOF
       If i <> 0 Then Response.Write ","
       WriteTodo oRS("todoID"), oRS("todoContent"), oRS("todoCreated"), oRS("todoModified")
       i = i+1
       oRS.MoveNext
    Loop
    Response.Write "]"

End Sub

Sub On_GetTodo(oNasp,vParam)
    Dim oComm
    Set oComm = Server.CreateObject("ADODB.Command")
    oComm.CommandType = 1
    oComm.CommandText = "SELECT * FROM TTest_TodoList WHERE todoID = ?"
    oComm.ActiveConnection = constConnStr
    oComm(0) = Request.ServerVariables("HTTP_MEDIATED_PARAM")
    Dim oRS
    Set oRS = oComm.Execute
    
    WriteTodo oRS("todoID"), oRS("todoContent"), oRS("todoCreated"), oRS("todoModified")

End Sub

Sub On_PostTodo(oNasp,vParam)
    Dim oComm
    Set oComm = Server.CreateObject("ADODB.Command")
    oComm.CommandType = 1
    oComm.CommandText = "INSERT INTO TTest_TodoList(todoContent,todoCreated) VALUES(?,GETDATE())"
    oComm.ActiveConnection = constConnStr
    oComm(0) = Request.Form("content")
    oComm.Execute
    WriteStatus True
End Sub

Sub On_PutTodo(oNasp,vParam)
    Dim oComm
    Set oComm = Server.CreateObject("ADODB.Command")
    oComm.CommandType = 1
    oComm.CommandText = "UPDATE TTest_TodoList SET todoContent = ?, todoModified = GETDATE() WHERE todoID = ?"
    oComm.ActiveConnection = constConnStr
    oComm(0) = Request.Form("content")
    oComm(1) = Request.ServerVariables("HTTP_MEDIATED_PARAM")
    Dim oRS
    Set oRS = oComm.Execute
    WriteStatus True
End Sub

Sub On_DeleteTodo(oNasp,vParam)
    Dim oComm
    Set oComm = Server.CreateObject("ADODB.Command")
    oComm.CommandType = 1
    oComm.CommandText = "DELETE FROM TTest_TodoList WHERE todoID = ?"
    oComm.ActiveConnection = constConnStr
    oComm(0) = Request.ServerVariables("HTTP_MEDIATED_PARAM")
    oComm.Execute
    WriteStatus True
End Sub

Sub On_NotFound(oNasp,vParam)
    WriteStatus False
End Sub



Sub WriteTodo (nID,sContent,dCreated,dModified)
    Response.Write "{"
    Response.Write JSEscapeQuote("id") & ":" & nID
    Response.Write "," & JSEscapeQuote("content") & ":" & JSEscapeQuote(sContent)
    Response.Write "," & JSEscapeQuote("created") & ":" & JSEscapeQuote(dCreated)
    If Not IsNull(dModified) Then
      Response.Write "," & JSEscapeQuote("modified") & ":" & JSEscapeQuote(dModified)
    End If
    Response.Write "}"
End Sub


Sub WriteStatus (bStatus)
    Response.Write "{"
    Response.Write JSEscapeQuote("status") & ":"
    If bStatus Then
        Response.Write JSEscapeQuote("ok")
    Else
        Response.Write JSEscapeQuote("ng")
    End If	
    Response.Write "}"
End Sub

Function JSEscape(sStr)
	 Dim sRet
	 sRet = sStr
	 sRet = Replace (sRet,"\","\\")
	 sRet = Replace (sRet,"""","\""")
	 JSEscape = sRet	 
End Function

Function JSEscapeQuote (sStr)
	 Dim sRet
	 sRet = JSEscape(sStr)
	 sRet = """" & sRet & """"
	 JSEscapeQuote = sRet
End Function



%>
