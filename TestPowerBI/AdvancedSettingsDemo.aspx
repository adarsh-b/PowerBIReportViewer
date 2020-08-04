<%@ Page Title="Advanced Settings Demo" Language="C#"  MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdvancedSettingsDemo.aspx.cs" Inherits="BIReports.AdvancedSettingsDemo" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script src="scripts/es6-promise.js"></script>
    <script type="text/javascript" src="scripts/powerbi.min.js"></script>

    <script type="text/javascript">

        window.onload = function () {
            var accessToken = document.getElementById('MainContent_accessToken').value;

            if (!accessToken || accessToken == "") {
                return;
            }

            var embedUrl = document.getElementById('MainContent_txtEmbedUrl').value;
            var reportId = document.getElementById('MainContent_txtReportId').value;

            // Get models. models contains enums that can be used.
            var models = window['powerbi-client'].models;

            // We give All permissions to demonstrate switching between View and Edit mode and saving report.
            var permissions = models.Permissions.All;

            // Embed configuration used to describe the what and how to embed.
            // This object is used when calling powerbi.embed.
            // This also includes settings and options such as filters.
            // You can find more information at https://github.com/Microsoft/PowerBI-JavaScript/wiki/Embed-Configuration-Details.
            var config = {
                type: 'report',
                accessToken: accessToken,
                embedUrl: embedUrl,
                id: reportId,
                permissions: permissions,
                settings: {
                    filterPaneEnabled: true,
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

            report.on("error", function (event) {
                alert(event.detail);

                report.off("error");
            });


            report.off("saved");
            report.on("saved", function (event) {
                if (event.detail.saveAs) {
                    alert('In order to interact with the new report, create a new token and load the new report');
                }
            });
        };
    </script>

    <asp:HiddenField ID="accessToken" runat="server" Value="H4sIAAAAAAAEACVWtQ7sCBL8l5f6JDOdtIGZmZ15zB4z26v795vVhg1JV3dX1d9_7Ozpp6z4898_aAas7Xie3sn1TCIGZ-NErRnhSpv2USbJtdlMvXMgBo1UUGum2YTdbtYUoclsjOLYUi8Uq4xYyTDjRmRXUMnUXRSBFhoWsrJGHFFQS71byd6IIqYianSEtuf2neCji3Ro6d4OE4cQn_GCy28Na-1qrzk3MXO0OH1DDJgP3AWHIK2Hls2LjySXERo7aj6wmvCHnAx5lMtU9s092QoWHNVM9veafzhBi_upMaYGP63rebuLexb9msaTgIY95KstHkSLQLYHth8IvN2aUVm2bU2nGG5EUgnz9G-qrAZ104k-KCpYS-LT0764TlLCnYnrzpu63CIayUFjUsJjPJrwbNT95Cw8PE61q2GDpm12nFM9hKyXVZwqS87ShQYfPcoztyToyywt_OJEsqKV0DNdXiujacnqsbGkNMMS4gmKNLa_Ys-HMdhLaoLrzO0ENGrU3dk5W5FlfSAOdhElGlGgCVqWtI1FVWu1HscBsK_BQIZu3Nj2vRNyrcSxIhadnhqJQoFRqp0xSdwOENQxgK19QYnSq8CLjilLZ4_WTAJ1YK_fFlaIVi4q-It1-NW75ZaBzoDl3Fpy2XOVL6GLx2haIxOb-_xGrZXbaO_MmTGLAWQXH661TeDh81eZI4zB6VORYfw0VaChBy8XBd6oZDlbY1ePmCw_3gA2VO6rsKbSYsR6lxg8f1jwEzJmAOHEQBTPimAVuaVuSsmI0DH94bkhK81a6t98DXyg3eb1_FL2jikuEqqyeYnWbA2syL1qfFRhEvoYPQtBJLX1PlHmRAvl7VL7AoDxVjKFjfhesM0FogeSnpA7d6nC6St88PL1hi6GP_uu9p8M12NRURE_4APEuJwslLN2VWkvmpxx44XgkmGmxCCEcaR3KVnMWc8aWI_0LdqzUB0yN9or1KX4_q0Dks8YvFWccWt1bDk0ZcCJ4KKz5J7n7cvVh7-1D2JxA5nawWWYdBKL6UVM84jF7YuT_x1PsJK5ZDxviNVbeIgxKeYoOBBmFO-WCiFIEDRRtuvSEXaUCfMms5-EcLB7VDvpGMWjWuwLOXVHbIV3hn0H0FRMLA_i0mHNuxcwYgPmxgHA18MdA4gCdtGzyCIO71V5cpLzGAK2WYr6hTEI7Wi8TU7x7ejEcyT9zNNqzehikD685RwNp7gaHji_fLFX5yCwILSwiYHhIj5YY0cLpmf1UcKxsiUSicT1eP6BQ12w1a9YSntErQPZYxQGHzeAZ4hDAL-p8d0jk3J-P_ekQjZNvydsgEeL1epEi5Yw_v4R_F00Dths-a3IMuD5L5QgkSqvyUbO4nwMIIkbsi8kXoOszGBGRVzA0eugEnfJ_dm6SlnuDnkmc13gnzEjB9A7ZxTNXWcC-SJ9L83SGSb-oLDjaO-MIZ54PEod3hmnujyKdeU-4Az-Bt-XtNUg0Z5rKJrnDQ7xE-McI-aeM6-o1dGtBruKKVxgwADI-JyaYVVi0YqV4kJwYtYbCSS9HQwJK630c56zz92S58tTivAFCEunaRHury7hST1WEzmtPCGdPezT7KCGbBjtsBYlRv0lQZPONJhdsUC5QnBQdZBEYagmM1p3EJZRdmokxKmKVKiZtfemwpb_roLKwHXNHORWkDMNakTe78Xv6raHLDqFE_QuuwjqeXYWEoP5Gwt4Dj8HXQi1k5XCYznX3pH9XhHbdvSI51RYsqkF1YXRklzeM-DQFNYYuznK8Ik13a3v8a1wyfmyFPsxeSMcy4EWCwImTwA1v21mFDPUJJ9JgKRpQw0nFPrUi0s-fvk6jsprzVfYEW7xmFtb5SStimnlzrc2lIcMOD-NSdyGwh419ri2YvbkfYYEDeqsE1RUu7dnYknSqmOxa6PGoA2FEHtN1SVNTU_YYfDXSWo_UqAcD3-1zjfigdtV-XtVWEN-jGC5zJzyQ5s34pBPMejunBtiNNgmeEdtcdJQQOarvBxYSG3goJEb0jurwNQVxA2pRHPuq6BInd886gKqfjH1Yc8U3XVXmoj2GlM5NY2Hx8e2uMP3l_ie1GNQy23VO-vEwFmM1RHjXulxdKAneKF9JuAkZbKy1u0ZPcMfslFYLeug5lIAki1yAqbZ3RSRaHrhlerTYHObxZTSo0mYlWEIeEAHBdO45QCaCSbhA5Mx5I8RzLrj0zdL0rg4CPKXgpQIfFXq0BgF6XhQCXn9Q4PUTtPTaDGLROXLttyih2MTbzK-bXkxA7wVj7b3KDMI2F-PU_ui3-524zagZot6WMEbiFF__vOHW595n7Ty-dmZhA5uJ_1xlBkfDiUGFrHSelQs7VLp90z0nzDAKuEjlTiSa-0FgBdP-z2FlNt5oRtqrk38C5hWiZXBLdOftiwH57kw81x1A8CkTqN1CrIQyW2Jl9pU4CzIN1mzhYgfNkVTFkBd3rfDrXnX9vhJGkwcksCpTz37SsaUckNNiE8WUsezXt2xFxdWH10vrDBMOh1T5VmCacXqKfisAkamx9wWWDJYqJPBxCUBmpFgyDQQ284Vqhphi5d0PEBFwEHB2rDLX6Pp9nXKxU448GrxHW_CH5FclaPhxdTtsyWYktb4ie7ABOHPZNng6q6GhxMLwifpBocI5vmdla6JVym2UENDCzl__fUPzM_clKsS_lBWwuodO9cS5wloqXvz7hxw_-3y2nrM9mMtf20GP3UOSijId5NitliYeMi_2O3vAE9oQsULBsx_K_ynL0cjst_yze3j5nkhMT6fSkCuleT23EiZSvTnTcOsT4Qf6Q4MtC1C741NGfeM82s142fcns1KR_ogIRsSJGhU-ehYeDkkP5hA3nr4CIXvRO9OoFyrLqdYHIeoXvm1gegOb69VwWytwaP6VOlWa_HsfOWjk2bDLWqBQgbeNQInXtmh6GGaaN_vVND6KOE990J3b9jZlNJ4jXJq3r6erOugB-Ot9LImau3RgZ9shrpzjy6IeFbLAKQyknx1dEyHHMsv87WeMLa8ikWj5xvibTCc3RmPxRSn-3dlt34GHfIBtD0s-Ir5wfy__wP_11MzwgsAAA==" />
    <div style="text-align:right"> <a href="http://localhost:13526/">Home</a></div>
    <div class="field" hidden="hidden">
        <div class="fieldtxt">Report Id</div>
        <asp:TextBox ID="txtReportId" runat="server" Width="750px" Text="f6bfd646-b718-44dc-a378-b73e6b528204"></asp:TextBox>
    </div>

    <div class="field" hidden="hidden">
        <div class="fieldtxt">Report Embed URL</div>
        <asp:TextBox ID="txtEmbedUrl" runat="server" Width="750px" Text="https://app.powerbi.com/reportEmbed?reportId=f6bfd646-b718-44dc-a378-b73e6b528204&groupId=be8908da-da25-452e-b220-163f52476cdd&config=eyJjbHVzdGVyVXJsIjoiaHR0cHM6Ly9XQUJJLVVTLU5PUlRILUNFTlRSQUwtcmVkaXJlY3QuYW5hbHlzaXMud2luZG93cy5uZXQiLCJlbWJlZEZlYXR1cmVzIjp7Im1vZGVybkVtYmVkIjp0cnVlfX0%3d"></asp:TextBox>
    </div>
    <div class="error">
        <asp:Label ID="errorLabel" runat="server"></asp:Label>
    </div>
    <div>
        <div id="reportContainer" style="width: 100%; height: 800px"></div>
    </div>
</asp:Content>
