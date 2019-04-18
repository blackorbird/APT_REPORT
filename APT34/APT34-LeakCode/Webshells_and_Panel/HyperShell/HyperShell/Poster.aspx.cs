using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HyperShell
{
    public partial class Poster : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void lbnSend_Click(object sender, EventArgs e)
        {
            
            var cl = new WebClient();
            using (WebClient client = new WebClient())
            {
                NameValueCollection val = new NameValueCollection();
                string[] lines = txtPost.Text.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
                string data = string.Empty;
                foreach (string item in lines)
                {
                    if (!string.IsNullOrEmpty(data))
                        data += "&";
                    string[] temp = item.Split('@');
                    val.Add(temp[0], Convert.ToBase64String(Encoding.UTF8.GetBytes(temp[1])));
                    data += temp[0] + "=" + System.Web.HttpUtility.UrlEncode(Convert.ToBase64String(Encoding.UTF8.GetBytes(temp[1])));
                }

                using (WebClient wc = new WebClient())
                {
                    ServicePointManager.ServerCertificateValidationCallback = (a, b, c, d) => true;
                    wc.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                    wc.UploadString(txtUrl.Text, data);
                }

                //client.UploadValues(txtUrl.Text, val);
            }
        }
    }
}