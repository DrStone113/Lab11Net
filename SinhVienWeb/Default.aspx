<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SinhVienWeb._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Trang cá nhân cán bộ</h2>

    <asp:Label ID="lblXinChao" runat="server" Font-Bold="true"></asp:Label>
    <br /><br />

    <asp:GridView ID="gvMonLop" runat="server" AutoGenerateColumns="false">
    <Columns>
        <asp:BoundField DataField="MaMon" HeaderText="Mã môn" />
        <asp:BoundField DataField="TenMon" HeaderText="Tên môn" />
        <asp:BoundField DataField="MaLop" HeaderText="Mã lớp" />
        <asp:BoundField DataField="TenLop" HeaderText="Tên lớp" />
        <asp:HyperLinkField 
            Text="Nhập điểm"
            DataNavigateUrlFields="MaMon,MaLop"
            DataNavigateUrlFormatString="NhapDiem.aspx?MaMon={0}&MaLop={1}" />
    </Columns>
</asp:GridView>

</asp:Content>
