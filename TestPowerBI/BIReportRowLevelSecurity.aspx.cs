using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Collections.Specialized;
using Microsoft.PowerBI.Api;
using Microsoft.PowerBI.Api.Models;
using Microsoft.Rest;
using System.Configuration;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace BIReports
{
    public partial class BIReportNew : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (Session[Utils.authResultString] != null)
                {
                    accessToken.Value = Utils.authResult.AccessToken;
                    GetReport();
                }
                else
                {
                    var result = Task.Run(async () =>
                    {
                        await Utils.GetAccessToken();
                    });

                    result.Wait();

                    if (Utils.authResult.AccessToken != null)
                    {
                        Session[Utils.authResultString] = Utils.authResult;
                        accessToken.Value = Utils.authResult.AccessToken;
                        GetReport();
                    }
                }
            }
        }

        // Gets a report based on the setting's ReportId and WorkspaceId.
        // If reportId or WorkspaceId are empty, it will get the first user's report.
        protected void GetReport()
        {
            List<string> roles = new List<string>();
            roles.Add("af");

            var powerBiApiUrl = ConfigurationManager.AppSettings["PowerBiApiUrl"];

            using (var client = new PowerBIClient(new Uri(powerBiApiUrl), new TokenCredentials(accessToken.Value, "Bearer")))
            {
                Report report = null;
                Utils.ReportsList = client.Reports.GetReports(GetParamGuid(ConfigurationManager.AppSettings["WorkspaceId"])).Value.ToList();

                //var dashboards = client.Dashboards.GetDashboards().Value.ToList();

                ddlReports.DataSource = Utils.ReportsList;
                ddlReports.DataValueField = "Id";
                ddlReports.DataTextField = "Name";
                ddlReports.DataBind();

                if (ddlReports.Items.Count > 0)
                {
                    ddlReports.SelectedIndex = 0;
                    report = Utils.ReportsList.Where(r => r.Id.ToString() == ddlReports.SelectedItem.Value).FirstOrDefault();

                    GenerateTokenRequest generateTokenRequestParameters =
                        new GenerateTokenRequest(accessLevel: "view",
                            identities: new List<EffectiveIdentity> {
                                new EffectiveIdentity(username: "Adarsh",
                                                    datasets: new List<string> { report.DatasetId  },
                                                    roles: roles)
                            });

                    var tokenResponse = client.Reports.GenerateTokenInGroup(GetParamGuid(ConfigurationManager.AppSettings["WorkspaceId"]),
                        report.Id,
                        generateTokenRequestParameters);

                    embedToken.Value = tokenResponse.Token;

                    txtEmbedUrl.Text = report.EmbedUrl;
                    txtReportId.Text = report.Id.ToString();
                }

                AppendErrorIfReportNull(report, "No reports found. Please specify the target report ID and workspace in the applications settings.");
            }
        }

        // Gets the report with the specified ID from the workspace. If report ID is emty it will retrieve the first report from the workspace.
        private Report GetReportFromWorkspace(PowerBIClient client, Guid WorkspaceId, Guid reportId)
        {
            // Gets the workspace by WorkspaceId.
            var workspaces = client.Groups.GetGroups();
            var sourceWorkspace = workspaces.Value.FirstOrDefault(g => g.Id == WorkspaceId);

            // No workspace with the workspace ID was found.
            if (sourceWorkspace == null)
            {
                errorLabel.Text = $"Workspace with id: '{WorkspaceId}' not found. Please validate the provided workspace ID.";
                return null;
            }

            Report report = null;
            if (reportId == Guid.Empty)
            {
                // Get the first report in the workspace.
                report = client.Reports.GetReportsInGroup(sourceWorkspace.Id).Value.FirstOrDefault();
                AppendErrorIfReportNull(report, "Workspace doesn't contain any reports.");
            }

            else
            {
                try
                {
                    // retrieve a report by the workspace ID and report ID.
                    report = client.Reports.GetReportInGroup(WorkspaceId, reportId);
                }

                catch (HttpOperationException)
                {
                    errorLabel.Text = $"Report with ID: '{reportId}' not found in the workspace with ID: '{WorkspaceId}', Please check the report ID.";

                }
            }

            return report;
        }

        private void AppendErrorIfReportNull(Report report, string errorMessage)
        {
            if (report == null)
            {
                errorLabel.Text = errorMessage;
            }
        }

        private static Guid GetParamGuid(string param)
        {
            Guid paramGuid = Guid.Empty;
            Guid.TryParse(param, out paramGuid);
            return paramGuid;
        }

        protected void ddlReports_SelectedIndexChanged(object sender, EventArgs e)
        {
            var report = Utils.ReportsList.Where(r => r.Id.ToString() == ddlReports.SelectedItem.Value).FirstOrDefault();

            txtEmbedUrl.Text = report.EmbedUrl;
            txtReportId.Text = report.Id.ToString();
        }
    }
}