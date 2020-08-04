using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace BIReports
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void embedReportButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("/BIReport.aspx");
        }

        protected void embedDashboardButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("/BIDashboard.aspx");
        }

        protected void embedReportButton1_Click(object sender, EventArgs e)
        {
            Response.Redirect("/BIReportRowLevelSecurity.aspx");
        }

        protected void advancedSettingsDemoButton_Click(object sender, EventArgs e)
        {
            Response.Redirect("/AdvancedSettingsDemo.aspx");
        }
    }
}