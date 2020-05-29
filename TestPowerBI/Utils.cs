using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using Microsoft.Identity.Client;
using Microsoft.PowerBI.Api.Models;
using System.Configuration;
using System.Threading.Tasks;
using System.Security;

namespace BIReports
{
    public class Utils
    {
        public const string authResultString = "authResult";
        public static string EmbedType {get; set;}

        public static AuthenticationResult authResult { get; set; }

        public static async Task<AuthenticationResult> GetAccessToken()
        {
            string ApplicationId = ConfigurationManager.AppSettings["ApplicationID"];
            string Tenant = ConfigurationManager.AppSettings["TenantId"];
            string AuthorityURL = ConfigurationManager.AppSettings["AADAuthorityUri"].Replace("common", Tenant);
            string[] Scope = ConfigurationManager.AppSettings["scope"].Split(',');
            string Username = ConfigurationManager.AppSettings["pbiUsername"];
            string Password = ConfigurationManager.AppSettings["pbiPassword"];

            IPublicClientApplication clientApp = PublicClientApplicationBuilder
                                                                    .Create(ApplicationId)
                                                                    .WithAuthority(AuthorityURL)
                                                                    .WithTenantId(Tenant)
                                                                    .Build();
            var userAccounts = await clientApp.GetAccountsAsync();

            try
            {
                authResult = await clientApp.AcquireTokenSilent(Scope, userAccounts.FirstOrDefault()).ExecuteAsync();
            }
            catch (MsalUiRequiredException)
            {
                try
                {
                    SecureString password = new SecureString();
                    foreach (var key in Password)
                    {
                        password.AppendChar(key);
                    }
                    authResult = await clientApp.AcquireTokenByUsernamePassword(Scope, Username, password).ExecuteAsync();
                }
                catch (MsalException)
                {
                    throw;
                }
            }

            return authResult;
        }

        public static IList<Report> ReportsList { get; set; }

        public static IList<ReportData> ReportsData { get; set; }
    }

    //Power BI Dashboards used to deserialize the Get Dashboard response.

    public class PBIDashboards
    {
        public PBIDashboard[] value { get; set; }
    }

    public class PBIDashboard
    {
        public string id { get; set; }
        public string displayName { get; set; }
        public string embedUrl { get; set; }
        public bool isReadOnly { get; set; }
    }

    public class ReportData
    {
        public string ID { get; set; }
        public string ReportName { get; set; }
        public string DomainFilterQueryString { get; set; }
    }
}