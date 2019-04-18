using System;
using System.Text;
using System.Web;

namespace Minion.lib
{
    public class UserLogin
    {
        public bool CheckUser()
        {
            bool isLogin = false;
            //if (HttpContext.Current.Session["SessionUser"] != null)
            //{
            //    if (HttpContext.Current.Session["SessionUser"].ToString().ToLower() == "admin")
            //        isLogin = true;
            //}
            //else
            //{
                if (HttpContext.Current.Request.Cookies["SessionUser"] != null)
                {
                    if (HttpContext.Current.Request.Cookies["SessionUser"].Value == "admin")
                    {
                        //HttpContext.Current.Session["SessionUser"] = "admin";
                        isLogin = true;
                    }

                }
            //}
            return isLogin;
        }

        public bool LoginUser(string username, string password)
        {
            bool ret = false;

            if (username.Trim().ToLower() == "admin")
            {
                string salt = "O%tG7Hz57kvWk35$D*)s$1l$pUpLnBw)apHR!xYZWZu7X#^w7$mCArmQMAa&sRBG";
                string hash = "m6m8CCWa/u820mie8bX3HKIx1+WQkB+lbmniyXWKB+8=";

                ret = Convert.ToBase64String(new System.Security.Cryptography.SHA256CryptoServiceProvider().ComputeHash(Encoding.ASCII.GetBytes(password + salt))) == hash;

                if (ret)
                {
                    //HttpContext.Current.Session["SessionUser"] = "admin";

                    HttpCookie cookie = new HttpCookie("SessionUser", "admin");
                    cookie.Expires = DateTime.Now.AddDays(7);
                    HttpContext.Current.Response.SetCookie(cookie);
                } 
            }

            return ret;
        }
    }
}