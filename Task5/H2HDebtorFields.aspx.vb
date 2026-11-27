Imports System.Data
Imports System.Text.RegularExpressions

Partial Class H2HDebtorFields
    Inherits System.Web.UI.Page

    Private Const LogModule As String = "H2hDebtorFields"

    Private Const GridSql As String =
        "SELECT c.CompanyName, p.Display, d.* FROM TblH2HDebtorFields d " &
        "INNER JOIN TblCompany c ON c.CompanyNo = d.CompanyId " &
        "INNER JOIN TblPaymentType p ON p.Id = d.PaymentType"

    Private Const CompanySql As String =
        "SELECT DISTINCT c.CompanyNo, c.CompanyName FROM TblCompany c " &
        "INNER JOIN TblPaymentType p ON p.CompanyNo = c.CompanyNo ORDER BY c.CompanyName"

    Private Shared ReadOnly ResourceKeyCleaner As New Regex("[\s_]", RegexOptions.Compiled)

    Private ReadOnly errorLog As New PayrollErrorLog.PayrollErrorLog
    Private ReadOnly companyApi As New CompanyProcessAPI.companyProcess

    ' Per-request cache: payment type display text -> translated text
    Private ReadOnly paymentTypeTextCache As New Dictionary(Of String, String)

#Region "Field map (one place for every free-text field)"

    Private Class FieldMap
        Public ReadOnly Box As TextBox
        Public ReadOnly Column As String
        Public ReadOnly Label As String

        Public Sub New(box As TextBox, column As String, label As String)
            Me.Box = box
            Me.Column = column
            Me.Label = label
        End Sub
    End Class

    Private _textFields As FieldMap()

    ' Built on first use: page controls do not exist yet when field initializers run.
    Private ReadOnly Property TextFields As FieldMap()
        Get
            If _textFields Is Nothing Then
                _textFields = {
                    New FieldMap(tbAccountName, "AccountName", "Account Name"),
                    New FieldMap(tbAccountNum, "AccountNumber", "Account Number"),
                    New FieldMap(tbiban, "IBAN", "IBAN"),
                    New FieldMap(tbbic, "BIC", "BIC"),
                    New FieldMap(tbbankcode, "BankCode", "Bank Code"),
                    New FieldMap(tbbranchcode, "BranchCode", "Branch Code"),
                    New FieldMap(tbaddress, "Address", "Address"),
                    New FieldMap(tbcity, "City", "City"),
                    New FieldMap(tbpostalcode, "PostCode", "Post Code"),
                    New FieldMap(tbtaxid, "TaxID", "Tax ID"),
                    New FieldMap(tbsponsor, "Sponsor", "Sponsor")
                }
            End If
            Return _textFields
        End Get
    End Property

#End Region

#Region "Page state"

    Private _canEdit As Boolean?

    ''' <summary>PwC Admin / PwC Manager can add and edit. Country Admin is read-only.</summary>
    Protected ReadOnly Property CanEdit As Boolean
        Get
            If Not _canEdit.HasValue Then
                _canEdit = GPP.ACL.hasRole(GPP.ACLTypes.PwcAdmin, GPP.ACLTypes.PwCManager)
            End If
            Return _canEdit.Value
        End Get
    End Property

    ''' <summary>TransNo of the record being edited, 0 when not editing.</summary>
    Private Property EditingId As Integer
        Get
            Dim v As Object = ViewState("EditingId")
            Return If(v Is Nothing, 0, CInt(v))
        End Get
        Set(value As Integer)
            ViewState("EditingId") = value
        End Set
    End Property

    Private _editText As String

    Protected ReadOnly Property EditText As String
        Get
            If _editText Is Nothing Then _editText = Res("Edit", "Edit")
            Return _editText
        End Get
    End Property

#End Region

#Region "Page lifecycle"

    Private Sub H2HDebtorFields_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not GPP.UserDetails.sessionCheck() Then
            Response.Redirect("frmsessionexpired.aspx")
        End If

        If Not GPP.ACL.hasRole(GPP.ACLTypes.PwcAdmin, GPP.ACLTypes.PwCManager, GPP.ACLTypes.CountryAdmin) Then
            Response.Redirect("frmnoaccess.aspx")
        End If

        ButtonAdd.Visible = CanEdit
        thEdit.Visible = CanEdit

        If Not IsPostBack Then
            BindCompanies()
        End If
    End Sub

    ''' <summary>
    ''' The grid is bound exactly once per request, after all event handlers have run,
    ''' so it always reflects the latest data. Its ViewState is disabled (see markup),
    ''' which keeps the page small.
    ''' </summary>
    Private Sub H2HDebtorFields_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        Try
            debtorfieldsparam.DataSource = companyApi.SQLQueryToDataSet(GridSql)
            debtorfieldsparam.DataBind()
        Catch ex As Exception
            Fail("PreRender", ex)
        End Try
    End Sub

#End Region

#Region "Data binding helpers"

    Private Sub BindCompanies()
        Try
            ddlCompanyName.DataSource = companyApi.SQLQueryToDataSet(CompanySql)
            ddlCompanyName.DataBind()
        Catch ex As Exception
            Fail("BindCompanies", ex)
        End Try
        ddlCompanyName.Items.Insert(0, New ListItem("", ""))
    End Sub

    Private Sub BindPaymentTypes(companyId As String)
        ddlpaymenttype.Items.Clear()

        Dim id As Integer
        If Integer.TryParse(companyId, id) Then
            ddlpaymenttype.DataSource = companyApi.SQLQueryToDataSet(
                "SELECT Id, Display FROM TblPaymentType WHERE CompanyNo = " & id.ToString() & " ORDER BY Display")
            ddlpaymenttype.DataBind()
        End If

        ddlpaymenttype.Items.Insert(0, New ListItem("", ""))
    End Sub

    ''' <summary>Used from the grid template. Translates each distinct value once per request.</summary>
    Protected Function PaymentTypeText(value As Object) As String
        Dim raw As String = AsText(value)
        Dim result As String = Nothing

        If Not paymentTypeTextCache.TryGetValue(raw, result) Then
            result = Res(ResourceKeyCleaner.Replace(raw, ""), raw)
            paymentTypeTextCache(raw) = result
        End If

        Return result
    End Function

    Private Function LoadRecord(transNo As Integer) As DataRow
        Dim ds As DataSet = companyApi.SQLQueryToDataSet(
            "SELECT * FROM TblH2HDebtorFields WHERE TransNo = " & transNo.ToString())

        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
            Return Nothing
        End If
        Return ds.Tables(0).Rows(0)
    End Function

#End Region

#Region "Event handlers"

    Private Sub ButtonAdd_Click(sender As Object, e As EventArgs) Handles ButtonAdd.Click
        If Not CanEdit Then Return

        ResetForm()
        Add.Visible = True
        BtnAdd.Visible = True
    End Sub

    Private Sub ddlCompanyName_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlCompanyName.SelectedIndexChanged
        Try
            BindPaymentTypes(ddlCompanyName.SelectedValue)
        Catch ex As Exception
            Fail("ddlCompanyName_SelectedIndexChanged", ex)
        End Try
    End Sub

    Private Sub lnkEditRow_Click(sender As Object, e As EventArgs) Handles lnkEditRow.Click
        If Not CanEdit Then Return

        Dim transNo As Integer
        If Not Integer.TryParse(hfEditId.Value, transNo) Then Return

        Try
            Dim row As DataRow = LoadRecord(transNo)
            If row Is Nothing Then
                ShowError(Res("RecordNotFound", "Record not found."))
                Return
            End If

            ResetForm()
            EditingId = transNo

            SelectValue(ddlCompanyName, row("CompanyId"))
            BindPaymentTypes(AsText(row("CompanyId")))
            SelectValue(ddlpaymenttype, row("PaymentType"))
            SelectValue(ddllevel, row("Level"))

            For Each f As FieldMap In TextFields
                f.Box.Text = AsText(row(f.Column))
            Next

            ' Key fields cannot change on edit
            ddlCompanyName.Enabled = False
            ddlpaymenttype.Enabled = False
            ddllevel.Enabled = False

            Add.Visible = True
            BtnUpdate.Visible = True
        Catch ex As Exception
            Fail("lnkEditRow_Click", ex)
        End Try
    End Sub

    Private Sub BtnAdd_Click(sender As Object, e As EventArgs) Handles BtnAdd.Click
        If Not CanEdit OrElse Not Page.IsValid Then Return

        Try
            Dim exists As Boolean = DBs.GPP.Query("TblH2HDebtorFields").
                Where("CompanyId", ddlCompanyName.SelectedValue).
                Where("PaymentType", ddlpaymenttype.SelectedValue).
                Where("Level", ddllevel.SelectedValue).
                Exists()

            If exists Then
                ShowWarning(Res("RecordAlreadyExists", "Record already exists."))
                Return
            End If

            DBs.GPP.Query("TblH2HDebtorFields").Insert(New With {Key _
                .CompanyId = ddlCompanyName.SelectedValue,
                .PaymentType = ddlpaymenttype.SelectedValue,
                .Level = ddllevel.SelectedValue,
                .AccountName = tbAccountName.Text,
                .AccountNumber = tbAccountNum.Text,
                .IBAN = tbiban.Text,
                .BIC = tbbic.Text,
                .BankCode = tbbankcode.Text,
                .BranchCode = tbbranchcode.Text,
                .Address = tbaddress.Text,
                .City = tbcity.Text,
                .PostCode = tbpostalcode.Text,
                .TaxID = tbtaxid.Text,
                .Sponsor = tbsponsor.Text
            })

            Dim parts As New List(Of String) From {
                "Company ID: " & ddlCompanyName.SelectedValue,
                "Payment Type: " & ddlpaymenttype.SelectedValue
            }
            If ddllevel.SelectedValue <> "" Then parts.Add("Level: " & ddllevel.SelectedValue)
            For Each f As FieldMap In TextFields
                If f.Box.Text <> "" Then parts.Add(f.Label & ": " & f.Box.Text)
            Next

            GPPUtils.Logs.AdminLog(LogModule, "ADDED - " & String.Join(", ", parts),
                                   Session("username"), "ADD", ddlCompanyName.SelectedValue)

            ResetForm()
            ShowSuccess(Res("RecordSavedSuccessfully", "Record saved successfully."))
        Catch ex As Exception
            Fail("BtnAdd_Click", ex)
        End Try
    End Sub

    Private Sub BtnUpdate_Click(sender As Object, e As EventArgs) Handles BtnUpdate.Click
        If Not CanEdit OrElse Not Page.IsValid OrElse EditingId = 0 Then Return

        Try
            Dim row As DataRow = LoadRecord(EditingId)
            If row Is Nothing Then
                ShowError(Res("RecordNotFound", "Record not found."))
                ResetForm()
                Return
            End If

            Dim changes As New List(Of String)
            For Each f As FieldMap In TextFields
                Dim oldValue As String = AsText(row(f.Column))
                If oldValue <> f.Box.Text Then
                    changes.Add(f.Label & " from: " & oldValue & " to: " & f.Box.Text)
                End If
            Next

            ' Skip the write and the log entry when nothing changed
            If changes.Count > 0 Then
                DBs.GPP.Query("TblH2HDebtorFields").Where("TransNo", EditingId).Update(New With {Key _
                    .AccountName = tbAccountName.Text,
                    .AccountNumber = tbAccountNum.Text,
                    .IBAN = tbiban.Text,
                    .BIC = tbbic.Text,
                    .BankCode = tbbankcode.Text,
                    .BranchCode = tbbranchcode.Text,
                    .Address = tbaddress.Text,
                    .City = tbcity.Text,
                    .PostCode = tbpostalcode.Text,
                    .TaxID = tbtaxid.Text,
                    .Sponsor = tbsponsor.Text
                })

                GPPUtils.Logs.AdminLog(LogModule, "UPDATED - " & String.Join(", ", changes),
                                       Session("username"), "UPDATE", AsText(row("CompanyId")))
            End If

            ResetForm()
            ShowSuccess(Res("RecordSavedSuccessfully", "Record saved successfully."))
        Catch ex As Exception
            Fail("BtnUpdate_Click", ex)
        End Try
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        ResetForm()
    End Sub

    Private Sub LinkButton_ViewAdminLog_Click(sender As Object, e As EventArgs) Handles LinkButton_ViewAdminLog.Click
        Try
            Component_Modal_AdminLog.bindAdminLog(LogModule)
        Catch ex As Exception
            Fail("LinkButton_ViewAdminLog_Click", ex)
        End Try
    End Sub

#End Region

#Region "Small helpers"

    ''' <summary>Puts the form back to its hidden, empty, enabled state.</summary>
    Private Sub ResetForm()
        EditingId = 0
        hfEditId.Value = ""

        Add.Visible = False
        BtnAdd.Visible = False
        BtnUpdate.Visible = False

        ddlCompanyName.Enabled = True
        ddlpaymenttype.Enabled = True
        ddllevel.Enabled = True

        SelectValue(ddlCompanyName, "")
        ddlpaymenttype.Items.Clear()
        SelectValue(ddllevel, "")

        For Each f As FieldMap In TextFields
            f.Box.Text = ""
        Next
    End Sub

    Private Shared Sub SelectValue(ddl As DropDownList, value As Object)
        ddl.ClearSelection()
        Dim item As ListItem = ddl.Items.FindByValue(AsText(value))
        If item IsNot Nothing Then item.Selected = True
    End Sub

    Private Shared Function AsText(value As Object) As String
        If value Is Nothing OrElse IsDBNull(value) Then Return ""
        Return Convert.ToString(value)
    End Function

    Private Function Res(key As String, fallback As String) As String
        Dim text As String = TryCast(GetGlobalResourceObject("Resource", key), String)
        Return If(String.IsNullOrEmpty(text), fallback, text)
    End Function

    Private Sub ShowSuccess(message As String)
        lblSuccess.Text = Server.HtmlEncode(message)
        pnlSuccess.Visible = True
    End Sub

    Private Sub ShowWarning(message As String)
        lblWarning.Text = Server.HtmlEncode(message)
        pnlWarning.Visible = True
    End Sub

    Private Sub ShowError(message As String)
        lblError.Text = Server.HtmlEncode(message)
        pnlError.Visible = True
    End Sub

    Private Sub Fail(where As String, ex As Exception)
        errorLog.create("H2HDebtorFields: " & where, Request.RawUrl & " : " & ex.ToString(), Session("username"), "Error")
        ShowError(Res("ErrorOccurred", "Something went wrong. Please try again or contact support."))
    End Sub

#End Region

End Class
