﻿<%@ Page Title="Row Level Security Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BIReportRowLevelSecurity.aspx.cs" Inherits="BIReports.BIReportNew" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script src="scripts/es6-promise.js"></script>
    <script type="text/javascript" src="scripts/powerbi.min.js"></script>

    <script type="text/javascript">

        window.onload = function () {
            var accessToken = document.getElementById('MainContent_embedToken').value;

            // Get models. models contains enums that can be used.
            var models = window['powerbi-client'].models;

            if (!accessToken || accessToken == "") {
                return;
            }

            var embedUrl = document.getElementById('MainContent_txtEmbedUrl').value;
            var reportId = document.getElementById('MainContent_txtReportId').value;

            // Embed configuration used to describe the what and how to embed.
            // This object is used when calling powerbi.embed.
            // This also includes settings and options such as filters.

            var config = {
                type: 'report',
                id: reportId,
                embedUrl: embedUrl,
                accessToken: accessToken,
                permissions: models.Permissions.All,
                tokenType: models.TokenType.Embed,
                viewMode: models.ViewMode.View,
                settings: {
                    filterPaneEnabled: false,
                    navContentPaneEnabled: true
                }
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
    <asp:HiddenField ID="embedToken" runat="server" />
    <div style="text-align:right"> <a href="http://localhost:13526/">Home</a></div>
    <div>
        <h2 style="border-bottom: solid; border-bottom-color: silver">PowerBI - Paged Reports</h2>
        <div class="field">
            <div class="fieldtxt">Report Name</div>
            <asp:DropDownList ID="ddlReports" runat="server" Width="750px" OnSelectedIndexChanged="ddlReports_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
        </div>
    </div>
    <div class="field" hidden="hidden">
        <div class="fieldtxt">Report Id</div>
        <asp:TextBox ID="txtReportId" runat="server" Width="750px"></asp:TextBox>
    </div>

    <div class="field" hidden="hidden">
        <div class="fieldtxt">Report Embed URL</div>
        <asp:TextBox ID="txtEmbedUrl" runat="server" Width="750px"></asp:TextBox>
    </div>
    <div class="error">
        <asp:Label ID="errorLabel" runat="server"></asp:Label>
    </div>
    <div>
        <div id="reportContainer" style="width: 100%; height: 800px"></div>
    </div>
</asp:Content>
