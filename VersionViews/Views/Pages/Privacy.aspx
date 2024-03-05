<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/MainLayout.master" Inherits="System.Web.Mvc.ViewPage<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<main aria-label="Privacy Policy" class="view">
    <div class="view__anchor" id="main"></div>
    <div class="view__in">
        <div class="group">
            <div class="group__item">
                <div class="copy copy--speaker">
                    <h2><%= Model.UpsellTitle %></h2>
                    <%= Model.UpsellText %>
                </div>
            </div>
        </div>
    </div>
</main>

</asp:Content>
