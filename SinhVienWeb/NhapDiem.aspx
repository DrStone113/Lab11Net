<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NhapDiem.aspx.cs" Inherits="SinhVienWeb.NhapDiem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Nhập điểm sinh viên</h2>

        <asp:GridView ID="gvSinhVien" runat="server" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="MSSV" HeaderText="MSSV" />
                <asp:BoundField DataField="HoTen" HeaderText="Họ tên" />
                <asp:TemplateField HeaderText="Điểm">
                    <ItemTemplate>
                        <asp:TextBox ID="txtDiem" runat="server" Text='<%# Bind("Diem") %>' Width="60"></asp:TextBox>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <br />
        <asp:Button ID="btnLuu" runat="server" Text="Lưu điểm" OnClick="btnLuu_Click" />
    </form>
</body>
</html>
