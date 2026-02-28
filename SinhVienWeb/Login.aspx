<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SinhVienWeb.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>Đăng nhập cán bộ</h2>

            Mã cán bộ:
            <asp:TextBox ID="txtMaCB" runat="server"></asp:TextBox>
            <br /><br />

            Mật khẩu:
            <asp:TextBox ID="txtMatKhau" runat="server" TextMode="Password"></asp:TextBox>
            <br /><br />

            <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" OnClick="btnLogin_Click" />
            <br /><br />

            <asp:Label ID="lblThongBao" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </form>
</body>
</html>
