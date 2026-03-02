<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SinhVienWeb.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đăng nhập - Hệ thống quản lý sinh viên</title>
    <link href="~/Content/bootstrap.min.css" rel="stylesheet" />
    <link href="~/Content/Site.css" rel="stylesheet" />
</head>
<body class="login-page">
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-header">
                <h2>Đăng nhập cán bộ</h2>
            </div>

            <div class="form-group">
                <label for="txtMaCB">Mã cán bộ:</label>
                <asp:TextBox ID="txtMaCB" runat="server" CssClass="form-control" placeholder="Nhập mã cán bộ"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtMatKhau">Mật khẩu:</label>
                <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password" CssClass="form-control" placeholder="Nhập mật khẩu"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" OnClick="btnLogin_Click" CssClass="btn-login" />

            <asp:Label ID="lblThongBao" runat="server" CssClass="error-message"></asp:Label>
        </div>
    </form>
</body>
</html>
