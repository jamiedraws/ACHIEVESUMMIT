<%@ WebHandler Language="C#" Class="GetSeminarOrder" %>

using System;
using System.Net;
using System.Web;
using System.Linq;
using Dtm.Framework.Models.Ecommerce;
using Dtm.Framework.Models.Ecommerce.Repositories;
using Newtonsoft.Json;
using Dtm.Framework.ClientSites.Web;
using ACHIEVESUMMIT.Models;

public class GetSeminarOrder : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        var orderId = context.Request.QueryString["oid"];
        var numericOrderId = 0;
        int.TryParse(orderId, out numericOrderId);
        var dataContext = EcommerceDataContextManager.Current;
        var response = string.Empty;

        try
        {
            var orderRepository = new OrderRepository(dataContext);
            Order order = dataContext.Orders.FirstOrDefault(o => o.OrderID == numericOrderId);

            if (order == null)
            {
                response = "error";
                new SiteExceptionHandler(string.Format("Order does not exist."));
            }
            else
            {
                SeminarOrder seminarOrder = new SeminarOrder()
                {
                    Order = order,
                    OfferCode = order.CampaignOfferVersion.CampaignOffer.OfferCode,
                    VersionNumber = order.CampaignOfferVersion.VersionNumber
                };

                response = JsonConvert.SerializeObject(seminarOrder);
            }
        }
        catch (Exception e)
        {
            response = "error";
            new SiteExceptionHandler(e);
        }


        context.Response.Write(response);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
