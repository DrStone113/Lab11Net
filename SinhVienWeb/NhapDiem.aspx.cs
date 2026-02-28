using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SinhVienWeb
{
    public partial class NhapDiem : System.Web.UI.Page
    {
        string maMon;
        string maLop;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["MaCB"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            maMon = Request.QueryString["MaMon"];
            maLop = Request.QueryString["MaLop"];

            if (!IsPostBack)
            {
                LoadSinhVien();
            }
        }

        private void LoadSinhVien()
        {
            string connStr = ConfigurationManager.ConnectionStrings["SinhVienDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT sv.MSSV, sv.HoTen,
                           ISNULL(bd.Diem, 0) AS Diem
                    FROM SinhVien sv
                    LEFT JOIN BangDiem bd 
                        ON sv.MSSV = bd.MSSV AND bd.MaMon = @MaMon
                    WHERE sv.MaLop = @MaLop
                ";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaMon", maMon);
                cmd.Parameters.AddWithValue("@MaLop", maLop);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvSinhVien.DataSource = dt;
                gvSinhVien.DataBind();
            }
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            string connStr = ConfigurationManager.ConnectionStrings["SinhVienDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                foreach (System.Web.UI.WebControls.GridViewRow row in gvSinhVien.Rows)
                {
                    string mssv = row.Cells[0].Text;
                    var txt = (System.Web.UI.WebControls.TextBox)row.FindControl("txtDiem");
                    float diem = float.Parse(txt.Text);

                    string sql = @"
                        MERGE BangDiem AS target
                        USING (SELECT @MSSV AS MSSV, @MaMon AS MaMon) AS source
                        ON target.MSSV = source.MSSV AND target.MaMon = source.MaMon
                        WHEN MATCHED THEN
                            UPDATE SET Diem = @Diem
                        WHEN NOT MATCHED THEN
                            INSERT (MSSV, MaMon, Diem)
                            VALUES (@MSSV, @MaMon, @Diem);";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@MSSV", mssv);
                    cmd.Parameters.AddWithValue("@MaMon", maMon);
                    cmd.Parameters.AddWithValue("@Diem", diem);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadSinhVien();
        }
    }
}