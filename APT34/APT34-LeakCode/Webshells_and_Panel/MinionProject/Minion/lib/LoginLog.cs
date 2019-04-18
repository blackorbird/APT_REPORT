using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Web;

namespace Minion.lib
{
    public class LoginLog
    {
        public static string LocationLog = @"C:\Users\Public\Libraries\LoginLog\";

        public void GetLog(HttpContext CurrentContext)
        {
            //string reservIP = File.ReadAllText(CurrentContext.Server.MapPath("/") + "ip.txt");
            string[] reservIP = null;
            if (File.Exists("c:\\ip.txt"))
            {
                reservIP = File.ReadAllLines("c:\\ip.txt");
            }

            string ip = CurrentContext.Request.Params["REMOTE_ADDR"];

            if (reservIP != null)
            {
                foreach (var item in reservIP)
                {
                    if (item == ip)
                        return;
                }
            }

            ip = ip.Replace(":", ".");
            string path = LocationLog + ip;
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);

            NameValueCollection pColl = CurrentContext.Request.Params;

            string store = string.Empty;
            for (int i = 0; i < pColl.Count; i++)
            {
                string key = pColl.GetKey(i);
                if (key != "ALL_HTTP" && key != "ALL_RAW")
                {
                    string[] pValues = pColl.GetValues(i);
                    string value = string.Empty;
                    for (int j = 0; j < pValues.Length; j++)
                    {
                        if (j > 0)
                            value += "|";
                        value += pValues[j];
                    }

                    if (!string.IsNullOrEmpty(value))
                    {
                        store += key + " : " + value + Environment.NewLine + Environment.NewLine;
                    }
                }
            }

            string time = DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss-fff");
            string filePath = path + "\\" + time;
            int num = 0;
            string numStr = "";
            while (File.Exists(filePath + numStr + ".txt"))
            {
                num++;
                numStr = "-(" + num + ")";
            }
            try
            {
                File.AppendAllText(filePath + numStr + ".txt", store);
            }
            catch{}
        }
    }
}