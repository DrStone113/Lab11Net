-- Script tạo CSDL SinhVien theo Lab 11
USE SinhVienDB;
GO

-- Xóa tất cả các ràng buộc khóa ngoại
DECLARE @sql NVARCHAR(MAX) = N'';
SELECT @sql += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + 
               QUOTENAME(OBJECT_NAME(parent_object_id)) + 
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @sql;
GO

-- Xóa các bảng nếu đã tồn tại (theo thứ tự ngược lại)
DROP TABLE IF EXISTS Diem;
DROP TABLE IF EXISTS GiangDay;
DROP TABLE IF EXISTS SinhVien;
DROP TABLE IF EXISTS MonHoc;
DROP TABLE IF EXISTS Lop;
DROP TABLE IF EXISTS CanBo;
GO

-- Bảng Cán bộ (Giảng viên)
CREATE TABLE CanBo (
    MaCB VARCHAR(10) PRIMARY KEY,
    TenCB NVARCHAR(100) NOT NULL,
    MatKhau VARCHAR(50) NOT NULL
);

-- Bảng Lớp
CREATE TABLE Lop (
    MaLop VARCHAR(10) PRIMARY KEY,
    TenLop NVARCHAR(100) NOT NULL
);

-- Bảng Môn học
CREATE TABLE MonHoc (
    MaMon VARCHAR(10) PRIMARY KEY,
    TenMon NVARCHAR(100) NOT NULL
);

-- Bảng Sinh viên
CREATE TABLE SinhVien (
    MSSV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    MaLop VARCHAR(10),
    FOREIGN KEY (MaLop) REFERENCES Lop(MaLop)
);

-- Bảng Giảng dạy (Cán bộ dạy môn học cho lớp nào)
CREATE TABLE GiangDay (
    MaCB VARCHAR(10),
    MaMon VARCHAR(10),
    MaLop VARCHAR(10),
    PRIMARY KEY (MaCB, MaMon, MaLop),
    FOREIGN KEY (MaCB) REFERENCES CanBo(MaCB),
    FOREIGN KEY (MaMon) REFERENCES MonHoc(MaMon),
    FOREIGN KEY (MaLop) REFERENCES Lop(MaLop)
);

-- Bảng Điểm
CREATE TABLE Diem (
    MSSV VARCHAR(10),
    MaMon VARCHAR(10),
    DiemThi DECIMAL(4,2),
    PRIMARY KEY (MSSV, MaMon),
    FOREIGN KEY (MSSV) REFERENCES SinhVien(MSSV),
    FOREIGN KEY (MaMon) REFERENCES MonHoc(MaMon)
);
GO

-- Thêm dữ liệu mẫu theo tài liệu Lab 11

-- Thêm cán bộ
INSERT INTO CanBo (MaCB, TenCB, MatKhau) VALUES
('001', N'Nguyễn Văn Cường', '123'),
('002', N'Huỳnh Minh Phương', '123'),
('003', N'Thái Cẩm Nhung', '123');

-- Thêm lớp
INSERT INTO Lop (MaLop, TenLop) VALUES
('K44-01', 'CNPM 01'),
('K44-02', 'CNPM 02'),
('K44-03', 'CNPM 03');

-- Thêm môn học
INSERT INTO MonHoc (MaMon, TenMon) VALUES
('CT101', N'Lập trình căn bản'),
('CT103', N'Cấu trúc dữ liệu'),
('CT251', N'Phát triển ứng dụng trên Windows');

-- Thêm sinh viên
INSERT INTO SinhVien (MSSV, HoTen, MaLop) VALUES
('B18001', N'Phạm Thị Bảo Nhiên', 'K44-01'),
('B18002', N'Nguyễn Văn An', 'K44-01'),
('B18003', N'Lê Hoài Anh', 'K44-01'),
('B18004', N'Nguyễn Lâm Hoàng Anh', 'K44-01'),
('B18005', N'Lê Minh Bằng', 'K44-01'),
('B18006', N'Vương Thừa Chấn', 'K44-02'),
('B18007', N'Cao Công Danh', 'K44-02'),
('B18008', N'Trịnh Lê Long Đức', 'K44-02'),
('B18009', N'Dương Lê Minh Hậu', 'K44-02'),
('B18010', N'Nguyễn Vũ Hoàng', 'K44-02'),
('B18011', N'Nguyễn Hoàng Thái Học', 'K44-03'),
('B18012', N'Nguyễn Quốc Huy', 'K44-03'),
('B18013', N'Võ Đoàn Gia Huy', 'K44-03'),
('B18014', N'Vũ Thị Bích Huyền', 'K44-03'),
('B18015', N'Hồ Việt Hùng', 'K44-03');

-- Thêm phân công giảng dạy
-- Thầy Nguyễn Văn Cường dạy Lập trình căn bản lớp K44-01 và K44-02
INSERT INTO GiangDay (MaCB, MaMon, MaLop) VALUES
('001', 'CT101', 'K44-01'),
('001', 'CT101', 'K44-02');

-- Thầy Nguyễn Văn Cường dạy Cấu trúc dữ liệu lớp K44-01 và K44-03
INSERT INTO GiangDay (MaCB, MaMon, MaLop) VALUES
('001', 'CT103', 'K44-01'),
('001', 'CT103', 'K44-03');

-- Thầy Huỳnh Minh Phương dạy Lập trình căn bản lớp K44-03
INSERT INTO GiangDay (MaCB, MaMon, MaLop) VALUES
('002', 'CT101', 'K44-03');

-- Thầy Huỳnh Minh Phương dạy Cấu trúc dữ liệu lớp K44-02
INSERT INTO GiangDay (MaCB, MaMon, MaLop) VALUES
('002', 'CT103', 'K44-02');

-- Cô Thái Cẩm Nhung dạy Phát triển ứng dụng trên Windows cho cả 3 lớp
INSERT INTO GiangDay (MaCB, MaMon, MaLop) VALUES
('003', 'CT251', 'K44-01'),
('003', 'CT251', 'K44-02'),
('003', 'CT251', 'K44-03');

GO

PRINT 'Tạo CSDL thành công!';
