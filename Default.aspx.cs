using System.Web;
using System.Web.Mvc;
using System.Web.UI;

namespace ACHIEVESUMMIT
{
    public partial class _Default : Page
    {
        #region " Events... "

        //TODO: Add reference to the Dtm.Framework
        //TODO: Add reference to the Framework.Models
        //TODO: Add the directories css, images, and views to project from website. 
        //TODO: Add the file web.config from the website.
        public void Page_Load(object sender, System.EventArgs e)
        {
            // Change the current path so that the Routing handler can correctly interpret
            // the request, then restore the original path so that the OutputCache module
            // can correctly process the response (if caching is enabled).

            string originalPath = Request.Path;
            HttpContext.Current.RewritePath(Request.ApplicationPath, false);
            IHttpHandler httpHandler = new MvcHttpHandler();
            httpHandler.ProcessRequest(HttpContext.Current);
            HttpContext.Current.RewritePath(originalPath, false);
        }
        #endregion
    }
}
