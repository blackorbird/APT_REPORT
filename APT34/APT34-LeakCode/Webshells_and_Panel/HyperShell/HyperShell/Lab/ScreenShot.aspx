<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ScreenShot.aspx.cs" Inherits="HyperShell.Lab.ScreenShot" %>

<!DOCTYPE html>
<%@ Import Namespace="System.Drawing" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <%
        var bmpScreenShot = new Bitmap(Screen)
    %>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
