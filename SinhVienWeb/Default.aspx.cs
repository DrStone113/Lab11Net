using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SinhVienWeb
{
    public partial class _Default : System.Web.UI.Page
    {
        private static readonly string[] CardGradients = new string[]
        {
            "linear-gradient(135deg, #5d6d7e 0%, #34495e 100%)",
            "linear-gradient(135deg, #52796f 0%, #354f52 100%)",
            "linear-gradient(135deg, #8b5a7d 0%, #6b4968 100%)",
            "linear-gradient(135deg, #5d7e8b 0%, #3d5a6b 100%)",
            "linear-gradient(135deg, #7d6b5a 0%, #5d4b3a 100%)",
            "linear-gradient(135deg, #6b7d5a 0%, #4b5d3a 100%)",
            "linear-gradient(135deg, #7e5d6d 0%, #5e3d4d 100%)",
            "linear-gradient(135deg, #5a6b7d 0%, #3a4b5d 100%)"
        };

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
                    ORDER BY mh.MaMon, l.MaLop
                ";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaCB", Session["MaCB"].ToString());

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCourses.DataSource = dt;
                rptCourses.DataBind();
            }
        }

        protected string GetCardGradient(int index)
        {
            return CardGradients[index % CardGradients.Length];
        }

        protected void btnDangXuat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}