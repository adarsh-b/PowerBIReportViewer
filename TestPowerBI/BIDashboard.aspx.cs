
using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Collections.Specialized;
using Newtonsoft.Json;
using Microsoft.PowerBI.Api;
using Microsoft.Rest;
using Microsoft.PowerBI.Api.Models;
using System.Collections.Generic;
using System.Configuration;
using System.Threading.Tasks;

namespace BIReports
{
    public partial class BIDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //Test for AuthenticationResult
                if (Session[Utils.authResultString] != null)
                {
                    accessToken.Value = Utils.authResult.AccessToken;
                    GetDashboard();
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
                        GetDashboard();
                    }
                }
            }
        }

        private void GetDashboard()
        {
            IList<Dashboard> dashboards = null;
            var powerBiApiUrl = ConfigurationManager.AppSettings["PowerBiApiUrl"];

            using (var client = new PowerBIClient(new Uri(powerBiApiUrl), new TokenCredentials(Utils.authResult.AccessToken, "Bearer")))
            {
                dashboards = client.Dashboards.GetDashboards().Value.ToList();
            }

            ddlReports.DataSource = dashboards;
            ddlReports.DataValueField = "EmbedUrl";
            ddlReports.DataTextField = "DisplayName";
            ddlReports.DataBind();

            if (ddlReports.Items.Count > 0)
            {
                ddlReports.SelectedIndex = 0;
                txtEmbedUrl.Text = ddlReports.SelectedItem.Value;
            }
        }

        protected void ddlReports_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtEmbedUrl.Text = ddlReports.SelectedItem.Value;
        }
    }
}