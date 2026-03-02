using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

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

            if (string.IsNullOrEmpty(maMon) || string.IsNullOrEmpty(maLop))
            {
                Response.Redirect("Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadThongTin();
                LoadSinhVien();
            }
        }

        private void LoadThongTin()
        {
            string connStr = ConfigurationManager.ConnectionStrings["SinhVienDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT mh.TenMon, l.TenLop
                    FROM MonHoc mh, Lop l
                    WHERE mh.MaMon = @MaMon AND l.MaLop = @MaLop
                ";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@MaMon", maMon);
                cmd.Parameters.AddWithValue("@MaLop", maLop);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblTenMon.Text = reader["TenMon"].ToString() + " (" + maMon + ")";
                    lblTenLop.Text = reader["TenLop"].ToString() + " (" + maLop + ")";
                }
                reader.Close();
            }
        }

        private void LoadSinhVien()
        {
            string connStr = ConfigurationManager.ConnectionStrings["SinhVienDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT sv.MSSV, sv.HoTen,
                           ISNULL(d.DiemThi, 0) AS DiemThi
                    FROM SinhVien sv
                    LEFT JOIN Diem d 
                        ON sv.MSSV = d.MSSV AND d.MaMon = @MaMon
                    WHERE sv.MaLop = @MaLop
                    ORDER BY sv.MSSV
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
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["SinhVienDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    foreach (GridViewRow row in gvSinhVien.Rows)
                    {
                        string mssv = row.Cells[0].Text;
                        var txt = (TextBox)row.FindControl("txtDiem");
                        
                        if (!string.IsNullOrEmpty(txt.Text))
                        {
                            decimal diem;
                            if (decimal.TryParse(txt.Text, out diem))
                            {
                                if (diem < 0 || diem > 10)
                                {
                                    lblThongBao.Text = "⚠ Điểm phải từ 0 đến 10!";
                                    lblThongBao.CssClass = "message-label";
                                    lblThongBao.Style["background-color"] = "#fff3cd";
                                    lblThongBao.Style["color"] = "#856404";
                                    lblThongBao.Style["border"] = "1px solid #ffeaa7";
                                    return;
                                }

                                string sql = @"
                                    MERGE Diem AS target
                                    USING (SELECT @MSSV AS MSSV, @MaMon AS MaMon) AS source
                                    ON target.MSSV = source.MSSV AND target.MaMon = source.MaMon
                                    WHEN MATCHED THEN
                                        UPDATE SET DiemThi = @DiemThi
                                    WHEN NOT MATCHED THEN
                                        INSERT (MSSV, MaMon, DiemThi)
                                        VALUES (@MSSV, @MaMon, @DiemThi);";

                                SqlCommand cmd = new SqlCommand(sql, conn);
                                cmd.Parameters.AddWithValue("@MSSV", mssv);
                                cmd.Parameters.AddWithValue("@MaMon", maMon);
                                cmd.Parameters.AddWithValue("@DiemThi", diem);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                lblThongBao.Text = "✓ Lưu điểm thành công!";
                lblThongBao.CssClass = "message-label";
                lblThongBao.Style["background-color"] = "#d4edda";
                lblThongBao.Style["color"] = "#155724";
                lblThongBao.Style["border"] = "1px solid #c3e6cb";
                LoadSinhVien();
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "✗ Lỗi: " + ex.Message;
                lblThongBao.CssClass = "message-label";
                lblThongBao.Style["background-color"] = "#f8d7da";
                lblThongBao.Style["color"] = "#721c24";
                lblThongBao.Style["border"] = "1px solid #f5c6cb";
            }
        }

        protected void btnQuayLai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }
    }
}