Public Class Hello
    Inherits System.Web.UI.Page

    ' Runs on the server every time the page is requested
    Private Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        lblDate.Text = "Server date is " & Date.Now.ToString("dd/MM/yyyy")
        lblTime.Text = "Server time is " & DateTime.Now.ToString("HH:mm:ss")
    End Sub

End Class