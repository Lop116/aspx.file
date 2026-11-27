<%@ Page Title="" Language="VB" MasterPageFile="~/ThreeColumn.master" AutoEventWireup="false" CodeFile="H2HDebtorFields.aspx.vb" Inherits="H2HDebtorFields" %>

<%@ Register Src="~/Component/SideMenu_H2H.ascx" TagPrefix="GPP" TagName="SideH2H" %>
<%@ Register Src="~/Component/Modal_AdminLog.ascx" TagPrefix="GPP" TagName="Modal_AdminLog" %>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder_head" runat="Server">
    <title>GPP | Debtor Fields Setup</title>
    <link rel="stylesheet" href="Version6/PwCAssets/global/vendor/select2/select2.css" />
    <link rel="stylesheet" href="Version6/PwCAssets/global/vendor/datatables.net-bs4/dataTables.bootstrap4.css">
    <link rel="stylesheet" href="Version6/PwCAssets/global/vendor/datatables.net-responsive-bs4/dataTables.responsive.bootstrap4.css">

    <style>
        .modal-open .select2-container {
            z-index: unset !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content101" ContentPlaceHolderID="ContentPlaceHolder_SideMenu" runat="Server">
    <GPP:SideH2H runat="server" ID="SideMenu" />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder_Main" runat="Server">
    <div class="page-header">
        <h1 class="page-title"><asp:Literal runat="server" Text="<%$ Resources:Resource, DebtorFieldsSetup %>" /></h1>

        <nav runat="server" aria-label="<%$ Resources:Resource, Breadcrumb %>">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="FrmMainMenuStaff.aspx"><asp:Literal runat="server" Text="<%$ Resources:Resource, Home %>" /></a></li>
                <li class="breadcrumb-item active"><asp:Literal runat="server" Text="<%$ Resources:Resource, DebtorFieldsSetup %>" /></li>
            </ol>
        </nav>
        <!-- Button topright -->
        <div class="page-header-actions">
            <button runat="server" id="ButtonUpload" type="button" class="btn btn-sm btn-icon btn-primary waves-effect waves-classic" data-bs-toggle="tooltip"
                title="<%$ Resources:Resource,UploadCalendarSetup%>">
                <i class="icon wb-attach-file" aria-hidden="true"></i>
            </button>
            <asp:LinkButton runat="server" ID="ButtonAdd" CausesValidation="false" CssClass="btn btn-sm btn-icon btn-primary waves-effect waves-classic" data-bs-toggle="tooltip"
                title="<%$ Resources:Resource, AddDebtorAccount %>" aria-label="<%$ Resources:Resource, AddDebtorAccount %>">
                <i class="icon md-plus" aria-hidden="true"></i>
            </asp:LinkButton>

            <asp:LinkButton ID="LinkButton_ViewAdminLog" runat="server" CausesValidation="false" title="<%$ Resources:Resource, ViewLog %>" aria-label="<%$ Resources:Resource, ViewLog %>" CssClass="btn btn-sm btn-icon btn-primary waves-effect waves-classic" data-bs-toggle="tooltip">
                <i class="icon wb-list" aria-hidden="true"></i>
            </asp:LinkButton>
        </div>
    </div>
    <%-- dont touch for now
            <div id="multiViewPanel" class="panel panel-default" visible="false" runat="server">
            <div class="d-flex justify-content-between align-items-center px-4 py-2 border-bottom">
                <h4 class="mb-0">
                    <asp:Literal runat="server" Text="ThirdPartyCalendarUpload"></asp:Literal>
                </h4>
            
                <% 
                    Dim perm As New Staff.Staff
                    Dim StaffType As String = perm.getstafftype(Session("username")).ToUpper
                    If StaffType = "PWC ADMIN" Or StaffType = "PWC MANAGER" Then
                %>
                    <asp:LinkButton ID="btnInputFileUploadLog" runat="server" Visible="true" class="btn btn-sm btn-icon btn-primary waves-effect waves-classic" data-bs-toggle="tooltip" title="<%$ Resources:Resource, ViewLogs%>">
                        <i class="icon wb-bookmark" aria-hidden="true"></i>
                    </asp:LinkButton>
                <% End If %>
      </div>

            <div class="panel-body bg-white px-4 py-4">
                <asp:ValidationSummary ID="ValidationSummaryStatutoryUpload" runat="server" ValidationGroup="validateUploadFileStatutory"
                    CssClass="alert alert-warning alert-dismissible mb-40" DisplayMode="BulletList"
                    ShowSummary="true" ShowMessageBox="false" HeaderText="<%$ Resources:Resource, MissingFieldValuesImg %>" />
                <!-- Info Banner -->
                <div class="row mb-4">
                    <div class="col-md-12 d-flex align-items-center fw-bold">
                        <i class="fa fa-info-circle me-2" aria-hidden="true"></i>
                        <asp:Literal ID="moduleInfo" runat="server" Text="ThisModuleAllowsYouToUploadThirdParty" />
                    </div>
                </div>
        
                <!-- Instruction & Upload Cards Side by Side -->
                <div class="row mb-4">
                    <!-- Left Card: Instructions -->
                    <div class="col-md-7">
                        <div class="card shadow-sm" style="border-top: 4px solid #e0301e;">
                            <div class="card-body">
                                <h5 class="card-title fw-bold mb-4">
                                    <i class="fas fa-file-alt me-2" aria-hidden="true"></i>
                                    <asp:Literal ID="litInstructions" runat="server" Text="<%$ Resources:Resource, Instructions%>" />
                                </h5>
        
                                <div class="row">
                                    <!-- Steps 1–3 -->
                                    <div class="col-md-6 d-flex flex-column gap-4">
                                        <!-- Step 1 -->
                                        <div class="d-flex align-items-start">
                                            <div class="me-3">
                                                <span class="badge text-white rounded-circle d-flex justify-content-center align-items-center" style="width: 25px; height: 25px; background-color: #e0301e !important;">1</span>
                                            </div>
                                            <div><asp:Literal runat="server" Text="DownloadTheThirdPartyCalendarReport"></asp:Literal></div>
                                        </div>
        
                                        <!-- Step 2 -->
                                        <div class="d-flex align-items-start">
                                            <div class="me-3">
                                                <span class="badge text-white rounded-circle d-flex justify-content-center align-items-center" style="width: 25px; height: 25px; background-color: #e0301e !important;">2</span>
                                            </div>
                                            <div>
                                                <asp:Literal runat="server" Text="<%$ Resources:Resource, AccessTheReportHere%>"></asp:Literal>
                                                <a class="btn btn-sm btn-outline-primary ms-2" href="frmviewreportpage.aspx?ReportCode=Statutory%20Calendar&type=H2H" target="_blank">
                                                    <i class="fas fa-external-link-alt me-1" aria-hidden="true"></i>
                                                    <asp:Literal runat="server" Text="<%$ Resources:Resource, Template%>"></asp:Literal>
                                                </a>
                                            </div>
                                        </div>
        
                                        <!-- Step 3 -->
                                        <div class="d-flex align-items-start">
                                            <div class="me-3">
                                                <span class="badge text-white rounded-circle d-flex justify-content-center align-items-center" style="width: 25px; height: 25px; background-color: #e0301e !important;">3</span>
                                            </div>
                                            <div><asp:Literal runat="server" Text="<%$ Resources:Resource, SelectAllCountriesAndTheAppropriateYear%>"></asp:Literal></div>
                                        </div>
                                    </div>
        
                                    <!-- Steps 4–6 -->
                                    <div class="col-md-6 d-flex flex-column gap-4">
                                        <!-- Step 4 -->
                                        <div class="d-flex align-items-start">
                                            <div class="me-3">
                                                <span class="badge text-white rounded-circle d-flex justify-content-center align-items-center" style="width: 25px; height: 25px; background-color: #e0301e !important;">4</span>
                                            </div>
                                            <div><asp:Literal runat="server" Text="<%$ Resources:Resource, ExportTheReportInExcelFormat%>"></asp:Literal></div>
                                        </div>
        
                                        <!-- Step 5 -->
                                        <div class="d-flex align-items-start">
                                            <div class="me-3">
                                                <span class="badge text-white rounded-circle d-flex justify-content-center align-items-center" style="width: 25px; height: 25px; background-color: #e0301e !important;">5</span>
                                            </div>
                                            <div><asp:Literal runat="server" Text="<%$ Resources:Resource, UpdateTheSheetImportTemplate%>"></asp:Literal></div>
                                        </div>
        
                                        <!-- Step 6 -->
                                        <div class="d-flex align-items-start">
                                            <div class="me-3">
                                                <span class="badge text-white rounded-circle d-flex justify-content-center align-items-center" style="width: 25px; height: 25px; background-color: #e0301e !important;">6</span>
                                            </div>
                                            <div><asp:Literal runat="server" Text="<%$ Resources:Resource, UploadTheUpdatedReportToApplyChanges%>"></asp:Literal></div>
                                        </div>
                                    </div>
                                </div>
        
                            </div>
                        </div>
                    </div>
        
                    <!-- Right Card: Upload -->
                    <div class="col-md-5">
                        <div class="card h-130 shadow-sm" style="border-top: 4px solid #e0301e;">
                            <div class="card-body d-flex flex-column justify-content-between">
                                <div>
                                    <h5 class="card-title fw-bold mb-4">
                                        <i class="fas fa-upload me-2" aria-hidden="true"></i>
                                        <asp:Literal runat="server" Text="UploadThirdPartyCalendar"></asp:Literal>
                                    </h5>
        
                                    <!-- File Upload Field -->
                                    <div class="mb-3">
                                        <div class="input-group input-group-file">
                                            <input type="text" class="form-control" readonly="readonly" aria-label="<%= System.Web.HttpUtility.HtmlAttributeEncode(Convert.ToString(GetGlobalResourceObject("Resource", "ChooseFileLoad"))) %>" />
                                            <span class="btn btn-primary" style="position: relative; overflow: hidden; cursor: pointer;">
                                                <i class="icon wb-upload" aria-hidden="true"></i>
                                                <asp:FileUpload ID="FileUploadStatutory" runat="server" CssClass="position-absolute top-0 start-0 opacity-0" style="width: 100%; height: 100%; cursor: pointer;" />
                                            </span>
                                        </div>
                                        <asp:RequiredFieldValidator ID="valFileUploadStatutory" runat="server" ControlToValidate="FileUploadStatutory" ForeColor="Red" ValidationGroup="validateUploadFileStatutory" CssClass="validatorLabel" Display="Dynamic"
                                            ErrorMessage="<%$ Resources:Resource, Required%>"
                                            data-field-text="UploadThirdPartyCalendar" data-required-text="<%$ Resources:Resource, IsRequired %>"></asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
        
                    <!-- Submit Buttons -->
                    <div class="text-end d-flex justify-content-end flex-wrap mt-40" style="gap:12px;">
                        <asp:LinkButton ID="btnCancelv1" runat="server" class="btn btn-outline-primary btn-secondary-large waves-effect waves-classic">
                            <asp:Literal runat="server" Text="<%$ Resources:Resource,Cancel%>"></asp:Literal>
                        </asp:LinkButton>
        
                        <asp:Button ID="btnSaveFileStat" runat="server"
                        CausesValidation="true"
                        ValidationGroup="validateUploadFileStatutory"
                        UseSubmitBehavior="false"
                        OnClientClick="if (!PresenceCheck1('validateUploadFileStatutory')) { return false; } this.value='Uploading...'; this.disabled=true;"
                        Text="<%$ Resources:Resource,Upload %>"
                        CssClass="btn btn-primary btn-primary-large waves-effect waves-classic" />
                    </div>
        
                </div>
            </div>
        </div>
        --%>
    <div class="page-content" role="main">
        <%-- Edit trigger: the grid rows post the TransNo through these, so the grid itself needs no per-row server controls or ViewState --%>
        <asp:HiddenField ID="hfEditId" runat="server" />
        <asp:LinkButton ID="lnkEditRow" runat="server" CausesValidation="false" CssClass="d-none" TabIndex="-1" aria-hidden="true" />

        <div class="col-md-12 divWaiting" id="loading" style="display: none;" role="status" aria-live="polite">
            <div class="panel vertical-align text-center" id="top" style="position: fixed; top: 0px; left: 0px; width: 100%; height: 100%; z-index: 4; display: none; background-color: transparent">
                <div style="margin-top: 25%" class="loader vertical-align-middle loader-round-circle"></div>
            </div>
        </div>

        <%-- EnableViewState="false": each message shows for one response only, then hides again on the next postback --%>
        <div class="alert alert-danger alert-dismissible col-12" role="alert" runat="server" id="pnlError" visible="false" enableviewstate="false">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="<%= System.Web.HttpUtility.HtmlAttributeEncode(Convert.ToString(GetGlobalResourceObject("Resource", "Close"))) %>"></button>
            <asp:Label runat="server" ID="lblError" EnableViewState="false"></asp:Label>
        </div>
        <div class="alert alert-success alert-dismissible col-12" role="alert" runat="server" id="pnlSuccess" visible="false" enableviewstate="false">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="<%= System.Web.HttpUtility.HtmlAttributeEncode(Convert.ToString(GetGlobalResourceObject("Resource", "Close"))) %>"></button>
            <asp:Label runat="server" ID="lblSuccess" EnableViewState="false"></asp:Label>
        </div>
        <div class="alert alert-warning alert-dismissible col-12" role="alert" runat="server" id="pnlWarning" visible="false" enableviewstate="false">
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="<%= System.Web.HttpUtility.HtmlAttributeEncode(Convert.ToString(GetGlobalResourceObject("Resource", "Close"))) %>"></button>
            <asp:Label runat="server" ID="lblWarning" EnableViewState="false"></asp:Label>
        </div>

        <div class="panel" id="Add" runat="server" visible="False" role="region" aria-labelledby="headingDebtorFieldsForm">
            <div class="panel-body">
                <h2 id="headingDebtorFieldsForm" class="sr-only"><asp:Literal runat="server" Text="<%$ Resources:Resource, DebtorFieldsSetup %>" /></h2>
                <asp:ValidationSummary ID="valSummaryAdd" runat="server" ValidationGroup="valDebtorFields" CssClass="alert alert-warning alert-dismissible mb-40" HeaderText="<%$ Resources:Resource, MissingFieldValuesImg %>" ShowSummary="true" ShowMessageBox="false" DisplayMode="BulletList" />
                <div class="form-horizontal">
                    <div class="mb-3 row">
                        <asp:Label ID="lblCompanyName" runat="server" AssociatedControlID="ddlCompanyName" CssClass="col-md-2 col-md-offset-1 control-label">
                            <asp:Literal runat="server" Text="<%$ Resources:Resource, CompanyName %>"></asp:Literal>
                            <span aria-hidden="true" style="color: red;">*</span>
                        </asp:Label>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlCompanyName" runat="server" AutoPostBack="true" CausesValidation="false" CssClass="form-control select2" data-plugin="select2" DataValueField="CompanyNo" DataTextField="CompanyName" aria-required="true"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="valCompany" runat="server" ControlToValidate="ddlCompanyName" ForeColor="Red" SetFocusOnError="true" ValidationGroup="valDebtorFields" CssClass="validatorLabel" Display="Dynamic" ErrorMessage="<%$ Resources:Resource, CompanyName %>" data-field-text="<%$ Resources:Resource, CompanyName %>" data-required-text="<%$ Resources:Resource, IsRequired %>"></asp:RequiredFieldValidator>
                        </div>
                        <asp:Label ID="lblPaymentType" runat="server" AssociatedControlID="ddlpaymenttype" CssClass="col-md-2 col-md-offset-1 control-label">
                            <asp:Literal runat="server" Text="<%$ Resources:Resource, PaymentType %>"></asp:Literal>
                            <span aria-hidden="true" style="color: red;">*</span>
                        </asp:Label>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlpaymenttype" runat="server" CssClass="form-control select2" data-plugin="select2" DataValueField="Id" DataTextField="Display" aria-required="true"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="valPaymentType" runat="server" ControlToValidate="ddlpaymenttype" ForeColor="Red" SetFocusOnError="true" ValidationGroup="valDebtorFields" CssClass="validatorLabel" Display="Dynamic" ErrorMessage="<%$ Resources:Resource, PaymentType %>" data-field-text="<%$ Resources:Resource, PaymentType %>" data-required-text="<%$ Resources:Resource, IsRequired %>"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="mb-3 row">
                        <asp:Label ID="lblLevel" runat="server" AssociatedControlID="ddllevel" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, Level %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddllevel" runat="server" CssClass="form-control select2" data-plugin="select2">
                                <asp:ListItem Value=""></asp:ListItem>
                                <asp:ListItem Value="1">1</asp:ListItem>
                                <asp:ListItem Value="2">2</asp:ListItem>
                                <asp:ListItem Value="3">3</asp:ListItem>
                                <asp:ListItem Value="4">4</asp:ListItem>
                                <asp:ListItem Value="5">5</asp:ListItem>
                                <asp:ListItem Value="6">6</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <asp:Label ID="lblAccountName" runat="server" AssociatedControlID="tbAccountName" CssClass="col-md-2 col-md-offset-1 control-label">
                            <asp:Literal runat="server" Text="<%$ Resources:Resource, AccountName %>"></asp:Literal>
                            <span aria-hidden="true" style="color: red;">*</span>
                        </asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbAccountName" runat="server" CssClass="form-control" aria-required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="valAccountName" runat="server" ControlToValidate="tbAccountName" ForeColor="Red" SetFocusOnError="true" ValidationGroup="valDebtorFields" CssClass="validatorLabel" Display="Dynamic" ErrorMessage="<%$ Resources:Resource, AccountName %>" data-field-text="<%$ Resources:Resource, AccountName %>" data-required-text="<%$ Resources:Resource, IsRequired %>"></asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <asp:Label ID="lblAccountNumber" runat="server" AssociatedControlID="tbAccountNum" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, AccountNumber %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbAccountNum" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <asp:Label ID="lblIban" runat="server" AssociatedControlID="tbiban" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, Iban %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbiban" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <asp:Label ID="lblBicSwift" runat="server" AssociatedControlID="tbbic" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, BicSwiftCode %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbbic" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <asp:Label ID="lblBankCode" runat="server" AssociatedControlID="tbbankcode" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, BankCode %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbbankcode" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <asp:Label ID="lblBranchCode" runat="server" AssociatedControlID="tbbranchcode" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, BranchCode %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbbranchcode" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <asp:Label ID="lblAddress" runat="server" AssociatedControlID="tbaddress" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, Address %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbaddress" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <asp:Label ID="lblPostalCode" runat="server" AssociatedControlID="tbpostalcode" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, PostalCode %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbpostalcode" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <asp:Label ID="lblCity" runat="server" AssociatedControlID="tbcity" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, City %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbcity" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3 row">
                        <asp:Label ID="lblTaxId" runat="server" AssociatedControlID="tbtaxid" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, TaxId %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbtaxid" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <asp:Label ID="lblSponsor" runat="server" AssociatedControlID="tbsponsor" CssClass="col-md-2 col-md-offset-1 control-label" Text="<%$ Resources:Resource, Sponsor %>"></asp:Label>
                        <div class="col-md-4">
                            <asp:TextBox ID="tbsponsor" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                    </div>

                    <div class="col-md-12" style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 30px;">
                        <asp:Button ID="BtnUpdate" runat="server" Text="<%$ Resources:Resource, Update %>" CssClass="btn btn-primary btn-primary-large waves-effect waves-classic" ValidationGroup="valDebtorFields" Visible="false" OnClientClick="return PresenceCheck1('valDebtorFields');" />
                        <asp:Button ID="BtnAdd" runat="server" Text="<%$ Resources:Resource, Add %>" CssClass="btn btn-primary btn-primary-large waves-effect waves-classic" ValidationGroup="valDebtorFields" Visible="false" OnClientClick="return PresenceCheck1('valDebtorFields');" />
                        <asp:Button ID="BtnCancel" runat="server" Text="<%$ Resources:Resource, Cancel %>" CssClass="btn btn-outline-primary btn-secondary-large waves-effect waves-classic" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>

        <div class="panel" id="View" runat="server" role="region" aria-labelledby="headingDebtorFieldsTable">
            <div class="panel-body">
                <h2 id="headingDebtorFieldsTable" class="sr-only"><asp:Literal runat="server" Text="<%$ Resources:Resource, DebtorFieldsSetup %>" /></h2>
                <div class="row">
                    <table id="datatableContribution" class="table table-hover dataTable table-striped w-full" style="text-align: center" tabindex="0">
                        <caption><asp:Literal runat="server" Text="<%$ Resources:Resource, DebtorFieldsSetup %>" /></caption>
                        <thead>
                            <tr>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, CompanyName %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, PaymentType %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, Level %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, AccountName %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, AccountNumber %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, Iban %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, Bic %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, BankCode %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, BranchCode %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, Address %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, City %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, PostalCode %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, TaxId %>" /></th>
                                <th scope="col"><asp:Literal runat="server" Text="<%$ Resources:Resource, Sponsor %>" /></th>
                                <th scope="col" id="thEdit" runat="server" class="no-sort"><asp:Literal runat="server" Text="<%$ Resources:Resource, Edit %>" /></th>
                            </tr>
                        </thead>

                        <tbody>
                            <%-- No ViewState, no per-row Labels: plain HTML-encoded text (<%#: %>), bound once per request in PreRender --%>
                            <asp:Repeater ID="debtorfieldsparam" runat="server" EnableViewState="false">
                                <ItemTemplate>
                                    <tr>
                                        <td><%#: Eval("CompanyName") %></td>
                                        <td><%#: PaymentTypeText(Eval("Display")) %></td>
                                        <td><%#: Eval("Level") %></td>
                                        <td><%#: Eval("AccountName") %></td>
                                        <td><%#: Eval("AccountNumber") %></td>
                                        <td><%#: Eval("IBAN") %></td>
                                        <td><%#: Eval("BIC") %></td>
                                        <td><%#: Eval("BankCode") %></td>
                                        <td><%#: Eval("BranchCode") %></td>
                                        <td><%#: Eval("Address") %></td>
                                        <td><%#: Eval("City") %></td>
                                        <td><%#: Eval("PostCode") %></td>
                                        <td><%#: Eval("TaxID") %></td>
                                        <td><%#: Eval("Sponsor") %></td>
                                        <td runat="server" visible='<%# CanEdit %>'>
                                            <a href="#" class="js-edit-row" role="button" data-id='<%#: Eval("TransNo") %>' title='<%#: EditText %>' aria-label='<%#: EditText %>'>
                                                <span style="font-size: 13pt; padding-right: 1em;" class="icon md-edit" aria-hidden="true"></span>
                                            </a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <GPP:Modal_AdminLog runat="server" ID="Component_Modal_AdminLog" />

</asp:Content>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder_footerScript" runat="server">
    <script type="text/javascript" src="Version6/PwCAssets/global/vendor/datatables.net/jquery.dataTables.js" defer></script>
    <script type="text/javascript" src="Version6/PwCAssets/global/vendor/datatables.net-bs4/dataTables.bootstrap4.js" defer></script>
    <script type="text/javascript" src="Version6/PwCAssets/global/vendor/datatables.net-responsive/dataTables.responsive.js" defer></script>
    <script type="text/javascript" src="Version6/PwCAssets/global/vendor/datatables.net-responsive-bs4/responsive.bootstrap4.js" defer></script>
    <script type="text/javascript" src="Version6/PwCAssets/global/vendor/select2/select2.full.min.js"></script>
    <script type="text/javascript" src="Version6/PwCAssets/global/js/Plugin/select2.js"></script>

    <script>
        $(document).ready(function () {
            var $table = $('#datatableContribution');

            $table.DataTable({
                responsive: true,
                "language": {
                    "url": "<%= If(Request.Cookies("Language") IsNot Nothing, GPPUtils.UI.DataTablesJS.getTranslatedLanguageFilePath(Request.Cookies("Language").Value), "") %>"
                },
                "columnDefs": [
                    { "orderable": false, "targets": "no-sort" },
                    { "width": "10px", "targets": 0 },
                    { "width": "40px", "targets": 1 },
                    { "width": "10px", "targets": 2 },
                    { "width": "10px", "targets": 3 },
                    { "width": "10px", "targets": 4 },
                    { "width": "10px", "targets": 5 }
                ]
            });

            // Delegated: also works for rows DataTables paginates or moves into responsive child rows
            $table.on('click', '.js-edit-row', function (e) {
                e.preventDefault();
                $('#<%= hfEditId.ClientID %>').val($(this).data('id'));
                __doPostBack('<%= lnkEditRow.UniqueID %>', '');
            });

            if (typeof SetDropDownListAriaLabelledBy === 'function') {
                SetDropDownListAriaLabelledBy($('#<%= ddlCompanyName.ClientID %>'), '<%= lblCompanyName.ClientID %>');
                SetDropDownListAriaLabelledBy($('#<%= ddlpaymenttype.ClientID %>'), '<%= lblPaymentType.ClientID %>');
                SetDropDownListAriaLabelledBy($('#<%= ddllevel.ClientID %>'), '<%= lblLevel.ClientID %>');
            }
        });
    </script>
</asp:Content>
