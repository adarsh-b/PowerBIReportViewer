<%@ Page Title="Embed Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BIDashboard.aspx.cs" Inherits="BIReports.BIDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="/css/master.css" type="text/css" />
    <script src="scripts/es6-promise.js"></script>
    <script type="text/javascript" src="scripts/powerbi.min.js"></script>

    <script type="text/javascript">

        window.onload = function () {
            var accessToken = document.getElementById('MainContent_accessToken').value;

            if (!accessToken || accessToken == "") {
                return;
            }

            var embedUrl = document.getElementById('MainContent_txtEmbedUrl').value;

            // Embed configuration used to describe the what and how to embed.
            // This object is used when calling powerbi.embed.
            // This also includes settings and options such as filters.
            // You can find more information at https://github.com/Microsoft/PowerBI-JavaScript/wiki/Embed-Configuration-Details.
            var config = {
                type: 'dashboard',
                accessToken: accessToken,
                embedUrl: embedUrl
            };

            // Grab the reference to the div HTML element that will host the report.
            var reportContainer = document.getElementById('reportContainer');

            // Embed the report and display it within the div container.
            var report = powerbi.embed(reportContainer, config);

            // Report.on will add an event handler which prints to Log window.
            report.on("loaded", function () {
                // Report.off removes a given event handler if it exists.
                report.off("loaded");
            });

            // Report.on will add an event handler which prints to Log window.
            report.on("rendered", function () {
                // Report.off removes a given event handler if it exists.
                report.off("rendered");
            });
        };
    </script>
     <asp:HiddenField ID="accessToken" runat="server" />
    <div style="text-align:right"> <a href="http://localhost:13526/">Home</a></div>
    <div>
        <h2 style="border-bottom:solid; border-bottom-color: silver">PowerBI - Dashboard</h2>
    <div class="field">
        <div class="fieldtxt">Dashboard Report Name</div>
        <asp:DropDownList ID="ddlReports" runat="server" Width="750px" OnSelectedIndexChanged="ddlReports_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
    </div>
    </div>
    <div class="field" hidden="hidden">
        <div class="fieldtxt">Report Embed URL</div>
        <asp:Textbox ID="txtEmbedUrl" runat="server" Width="750px"></asp:Textbox>
    </div>
    <div class="error">
        <asp:Label ID="errorLabel" runat="server"></asp:Label>
    </div>
    <div>
        <div ID="reportContainer" style="width: 100%; height: 800px"></div>
    </div>
</asp:Content>
