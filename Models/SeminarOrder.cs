using System;
using System.Collections.Generic;
using System.Linq;
using Dtm.Framework.Models.Ecommerce;

namespace ACHIEVESUMMIT.Models
{
    public class SeminarOrder
    {
       public Order Order { get; set; }
       public string OfferCode { get; set; }
       public decimal VersionNumber { get; set; }
    }
}