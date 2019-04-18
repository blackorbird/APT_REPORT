<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Poster.aspx.cs" Inherits="HyperShell.Poster" ValidateRequest="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <asp:TextBox ID="txtUrl" runat="server" Width="400px"></asp:TextBox><br />
    <asp:TextBox ID="txtPost" runat="server" TextMode="MultiLine" Width="400px" Height="400px"></asp:TextBox><br />
        <asp:LinkButton ID="lbnSend" runat="server" OnClick="lbnSend_Click">Send</asp:LinkButton>
    </div>
    </form>
</body>
</html>
