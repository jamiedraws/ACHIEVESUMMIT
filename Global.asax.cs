using System.Web.Mvc;
using System.Web.Routing;
using Dtm.Framework.ClientSites.Web;

namespace ACHIEVESUMMIT
{
    public class MvcApplication : ClientSiteApplication
    {
        protected override void ConfigureAdditionalRoutes(RouteCollection routes)
        {
            routes.MapRoute("GetView", "GetPartial", new { controller = "GetPartial", action = "GetPartialView" });

            base.ConfigureAdditionalRoutes(routes);
        }
    }
}