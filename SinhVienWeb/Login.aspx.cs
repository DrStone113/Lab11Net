using System;
using System.Configuration;
using System.Data.SqlClient;

namespace SinhVienWeb
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["SinhVienDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT TenCB FROM CanBo WHERE MaCB=@MaCB AND MatKhau=@MatKhau";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaCB", txtMaCB.Text.Trim());
                cmd.Parameters.AddWithValue("@MatKhau", txtMatKhau.Text.Trim());

                conn.Open();
                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    Session["MaCB"] = txtMaCB.Text;
                    Session["TenCB"] = result.ToString();
                    Response.Redirect("Default.aspx");
                }
                else
                {
                    lblThongBao.Text = "Sai mã cán bộ hoặc mật khẩu!";
                }
            }
        }
    }
}