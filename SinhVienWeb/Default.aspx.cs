using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SinhVienWeb
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MaCB"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblXinChao.Text = "Xin chào: " + Session["TenCB"].ToString();
                LoadMonLop();
            }
        }

        private void LoadMonLop()
        {
            string connStr = ConfigurationManager.ConnectionStrings["SinhVienDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT mh.MaMon, mh.TenMon, l.MaLop, l.TenLop
                    FROM GiangDay gd
                    JOIN MonHoc mh ON gd.MaMon = mh.MaMon
                    JOIN Lop l ON gd.MaLop = l.MaLop
                    WHERE gd.MaCB = @MaCB
                ";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaCB", Session["MaCB"].ToString());

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMonLop.DataSource = dt;
                gvMonLop.DataBind();
            }
        }
    }
}