<%@ Page Title="Nhập điểm" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NhapDiem.aspx.cs" Inherits="SinhVienWeb.NhapDiem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="diem-container">
        <div class="page-header">
            <div class="header-content">
                <div>
                    <h2>Nhập điểm sinh viên</h2>
                    <div class="info-badges">
                        <span class="info-badge">
                            <strong>Môn học:</strong> <asp:Label ID="lblTenMon" runat="server"></asp:Label>
                        </span>
                        <span class="info-badge">
                            <strong>Lớp:</strong> <asp:Label ID="lblTenLop" runat="server"></asp:Label>
                        </span>
                    </div>
                </div>
                <asp:Button ID="btnQuayLai" runat="server" Text="← Quay lại" OnClick="btnQuayLai_Click" CssClass="btn btn-secondary" />
            </div>
        </div>

        <div class="table-container">
            <asp:GridView ID="gvSinhVien" runat="server" 
                AutoGenerateColumns="false"
                CssClass="table table-modern"
                HeaderStyle-CssClass="table-header-modern"
                RowStyle-CssClass="table-row-modern">
                <Columns>
                    <asp:BoundField DataField="MSSV" HeaderText="MSSV" ReadOnly="true" />
                    <asp:BoundField DataField="HoTen" HeaderText="Họ tên" ReadOnly="true" />
                    <asp:TemplateField HeaderText="Điểm thi">
                        <ItemTemplate>
                            <asp:TextBox ID="txtDiem" runat="server" 
                                Text='<%# Bind("DiemThi") %>' 
                                CssClass="input-diem" 
                                placeholder="0.00"></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="action-buttons">
            <asp:Button ID="btnLuu" runat="server" Text="💾 Lưu điểm" OnClick="btnLuu_Click" CssClass="btn btn-primary-gradient" />
            <asp:Label ID="lblThongBao" runat="server" CssClass="message-label"></asp:Label>
        </div>
    </div>
</asp:Content>
