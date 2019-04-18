==========================================================
ASP.NET Friendly URLs v1.0.1
==========================================================

----------------------------------------------------------
Overview
----------------------------------------------------------
ASP.NET Friendly URLs provides a simple way to remove the
need for file extensions on URLs for registered file
handler types, e.g. .aspx.

For more information see http://go.microsoft.com/fwlink/?LinkID=264514&clcid=0x409

----------------------------------------------------------
Setup
----------------------------------------------------------

If your app didn't have a RouteConfig class before
installing ASP.NET Friendly URLs package:
----------------------------------------------------------
  The package includes a RouteConfig class that contains
  the call required to enable Friendly URLs. This call must
  be made from the Application_Start handler in your app's
  Global.asax file.

  Add the following to your Global.asax.cs file:

	using System.Web.Routing;
	...
    protected void Application_Start(object sender, EventArgs e)
    {
        RouteConfig.RegisterRoutes(RouteTable.Routes);
    }


If your app had a RouteConfig class before installing
ASP.NET Friendly URLs package:
----------------------------------------------------------
  You'll need to update your RouteConfig class to enable
  Friendly URLs.

  Call EnableFriendlyUrls() in your RegisterRoutes method
  *before* any existing route registrations:

    public static void RegisterRoutes(RouteCollection routes)
    {
        routes.EnableFriendlyUrls();

        // Put any additional route registrations here.
    }
