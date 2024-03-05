<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ACHIEVESUMMIT.Models.UpsellImage>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%  
    var image = Model;
    if (!String.IsNullOrEmpty(image.Name))
    {
        string[] imageSizes = string.IsNullOrEmpty(image.Size)
        ? new string[0]
        : image.Size
            .Split(new[] { "x" }, StringSplitOptions.RemoveEmptyEntries)
            .Select(s => s.Trim())
            .Where(s => !string.IsNullOrWhiteSpace(s))
            .ToArray();
        if (imageSizes.Count() == 2)
        { 
%>
            <div class="card__arp" style="--aspect-ratio: <%= imageSizes[1] %>/<%= imageSizes[0] %>; --aspect-ratio-width: <%= imageSizes[0] %>px" data-src-img="<%= image.Src %>" data-src-attr='{ "alt" : "<%= image.Alt %>" }'>
                <noscript>
                    <img src="<%= image.Src %>" alt="<%= image.Alt %>">
                </noscript>
            </div>
<%      
        }
        else
        { 
%>
            <img src="<%= image.Src %>" alt="<%= image.Alt %>">
<%      
        } 
    } 
%>