CREATE DATABASE QLNHATRO_PC07859
GO

USE QLNHATRO_PC07859
GO


CREATE TABLE LOAINHA(
	MaLoaiNha VARCHAR(9) NOT NULL,
	LoaiNha NVARCHAR(27) NOT NULL
)
GO

CREATE TABLE NGUOIDUNG(
	MaNguoiDung VARCHAR(9) NOT NULL,
	TenNguoiDung NVARCHAR(27) NOT NULL,
	GioiTinh BIT NOT NULL,
	DienThoai CHAR(10) NOT NULL,
	DiaChi NVARCHAR(81) NOT NULL,
	Quan NVARCHAR(18) NOT NULL,
	Email VARCHAR(27) NOT NULL,
)
GO

CREATE TABLE NHATRO(
	MaNhaTro VARCHAR(9) NOT NULL,
	LoaiHinh VARCHAR(9),
	DienTich FLOAT NOT NULL,
	GiaPhong FLOAT NOT NULL,
	DiaChi NVARCHAR(81) NOT NULL,
	Quan NVARCHAR(18) NOT NULL,
	MoTa NVARCHAR(81) NOT NULL,
	NgayDang DATE NOT NULL DEFAULT GETDATE(),
	NguoiLienHe VARCHAR(9),
)
GO

CREATE TABLE DANHGIA(
	MaDanhGia VARCHAR(9) NOT NULL,
	MaNguoiDanhGia VARCHAR(9) NOT NULL,
	MaNhaTroDanhGia VARCHAR(9) NOT NULL,
	LIKEE BIT NOT NULL,
	NoiDungDanhGia NVARCHAR(81) NOT NULL
)
GO


-- PRIMARY KEY
ALTER TABLE LOAINHA ADD CONSTRAINT PK_LOAINHA PRIMARY KEY(MaLoaiNha)
ALTER TABLE NGUOIDUNG ADD CONSTRAINT PK_NGUOIDUNG PRIMARY KEY(MaNguoiDung)
ALTER TABLE NHATRO ADD CONSTRAINT PK_NHATRO_MANHATRO PRIMARY KEY(MaNhaTro)
ALTER TABLE DANHGIA ADD CONSTRAINT PK_DANHGIA_NGUOIDUNG_NHATRO PRIMARY KEY(MaDanhGia, MaNguoiDanhGia, MaNhaTroDanhGia)

-- FOREIGN KEY
ALTER TABLE NHATRO ADD CONSTRAINT FK_NHATRO_LOAIHINH FOREIGN KEY(LoaiHinh) REFERENCES LOAINHA(MaLoaiNha)
ALTER TABLE NHATRO ADD CONSTRAINT FK_NHATRO_NGUOILIENHE FOREIGN KEY(NguoiLienHe) REFERENCES NGUOIDUNG(MaNguoiDung)
ALTER TABLE DANHGIA ADD CONSTRAINT FK_DANHGIA_MANGUOIDANHGIA FOREIGN KEY(MaNguoiDanhGia) REFERENCES NGUOIDUNG(MaNguoiDung)
ALTER TABLE DANHGIA ADD CONSTRAINT FK_DANHGIA_MANHADANHGIA FOREIGN KEY(MaNhaTroDanhGia) REFERENCES NHATRO(MaNhaTro)

-- CONSTRAINT CHECK
ALTER TABLE NGUOIDUNG ADD CONSTRAINT NGUOIDUNG_CONSTRAINT_EMAIL CHECK(Email LIKE '%@gmail.com')
ALTER TABLE NGUOIDUNG ADD CONSTRAINT NGUOIDUNG_CONSTRAINT_SDT CHECK (
    DienThoai LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND 
    LEN(DienThoai) = 10 AND 
    DienThoai NOT LIKE '%[^0-9]%'
)
ALTER TABLE NHATRO ADD CONSTRAINT NHATRO_CONSTRAINT_DIENTICH CHECK (DienTich > 0)
ALTER TABLE NHATRO ADD CONSTRAINT NHATRO_CONSTRAINT_GIAPHONG CHECK (GiaPhong > 0)

-- THÊM DỮ LIỆU
-- LOAINHA
INSERT INTO LOAINHA (MaLoaiNha, LoaiNha)
VALUES
    ('LN01', N'Nhà riêng'),
    ('LN02', N'Chung cư'),
    ('LN03', N'Biệt thự'),
    ('LN04', N'Căn hộ dịch vụ'),
    ('LN05', N'Nhà trọ'),
    ('LN06', N'Căn hộ chung cư'),
    ('LN07', N'Nhà phố'),
    ('LN08', N'Cửa hàng'),
    ('LN09', N'Văn phòng'),
    ('LN10', N'Kho bãi');


-- NGUOIDUNG
INSERT INTO NGUOIDUNG (MaNguoiDung,TenNguoiDung, GioiTinh, DienThoai, DiaChi, Quan, Email)
VALUES ('ND01',N'Nguyễn HOàng Khải', 1, '0123456789', N'Bình Minh', N'Vĩnh Long', 'khai.smith@gmail.com'),
       ('ND02',N'Nguyễn trúc thư',0, '0987668392', N'456 Phú hưng', N'Quận 2', 'thu.doe@gmail.com'),
	   ('ND03',N'nguyễn thị khải duy',0, '0987367890', N'Ninh Kiều', N'Ninh Kiều', 'duydoe@gmail.com'),
	   ('ND04',N'Nguyễn thị anh thư',0, '0968054321', N'486 Cần thơ', N'Quận 3', 'thudoe@gmail.com'),
	   ('ND05',N'nguyễn trần văn a', 1, '0987654142', N'Rạch Giá', N'Kiên GIang', 'tom@gmail.com'),
	   ('ND06',N'nguyễn thị Huệ', 0, '0987654583', N'783 Second St', N'Quận 8', 'hueom@gmail.com'),
	   ('ND07',N'Anh thư ', 0, '0237895603', N'Nguyễn văn cừ', N'Cần thơ', 'anhthutom@gmail.com'),
	   ('ND08',N'Nguyễn thùy dương', 0, '0578654789', N'Nguyễn Văn Linh', N'Cần thơ', 'thuyduong@gmail.com'),
	   ('ND09',N'Dương Gia NGhĩa', 1, '0125754683', N'Trà ôn', N'VĨnh Long', 'gianghia@gmail.com'),
	   ('ND10',N'Lâm Thị Duyên',0, '0256805683', N'Châu Thành', N'Kiên Giang', 'thiduyem@gmail.com');


-- NHATRO
INSERT INTO NHATRO (MaNhaTro, LoaiHinh, DienTich, GiaPhong, DiaChi, Quan, MoTa, NgayDang, NguoiLienHe)
VALUES
    ('NT01', 'LN01', 80.5, 2000000, N'123 Đường Nguyễn Văn Cừ', N'Quận 1', N'Nhà đẹp giá rẻ, gần trung tâm', '2023-09-24', 'ND01'),
    ('NT02', 'LN02', 65.2, 1500000, N'456 Đường 3/4', N'Quận 2', N'Chung cư cao cấp, view đẹp', '2023-09-25', 'ND02'),
    ('NT03', 'LN03', 200.0, 5000000, N'789 Đường 1/5', N'Quận 3', N'Biệt thự sang trọng, tiện nghi', '2023-09-26', 'ND03'),
    ('NT04', 'LN01', 75.0, 1800000, N'101 Đường Nguyễn Văn Linh', N'Quận 4', N'Nhà riêng thoáng mát, gần trường học', '2023-09-27', 'ND04'),
    ('NT05', 'LN04', 45.5, 1200000, N'202 Đường 3/4', N'Quận 5', N'Căn hộ dịch vụ tiện nghi', '2023-09-28', 'ND05'),
    ('NT06', 'LN05', 35.0, 800000, N'303 Đường 1/5', N'Quận 6', N'Nhà trọ cho sinh viên, thuận tiện', '2023-09-29', 'ND06'),
    ('NT07', 'LN06', 95.5, 2200000, N'404 Đường Nguyễn Văn Cừ', N'Quận 7', N'Căn hộ chung cư mới xây, hiện đại', '2023-09-30', 'ND07'),
    ('NT08', 'LN01', 60.0, 1600000, N'505 Đường Nguyễn Văn Linh', N'Quận 8', N'Nhà riêng thoáng mát, gần trung tâm', '2023-10-01', 'ND08'),
    ('NT09', 'LN02', 72.8, 1750000, N'606 Đường 3/4', N'Quận 9', N'Chung cư view đẹp, tiện ích', '2023-10-02', 'ND09'),
    ('NT10', 'LN07', 88.4, 2500000, N'707 Đường 1/5', N'Quận 10', N'Nhà phố cổ điển, lịch lãm', '2023-10-03', 'ND10');

-- DANHGIA
INSERT INTO DANHGIA (MaDanhGia, MaNguoiDanhGia, MaNhaTroDanhGia, Likee, NoiDungDanhGia)
VALUES
    ('DG01', 'ND01', 'NT01', 1, N'Nhà rất đẹp và sạch sẽ, gần các tiện ích'),
    ('DG02', 'ND02', 'NT02', 1, N'Chung cư tiện nghi, giao thông thuận lợi, an ninh tốt'),
    ('DG03', 'ND03', 'NT03', 0, N'Biệt thự xa trung tâm, không thuận tiện đi lại'),
    ('DG04', 'ND04', 'NT04', 1, N'Nhà riêng thoáng mát, gần trường học, yên tĩnh'),
    ('DG05', 'ND05', 'NT05', 0, N'Căn hộ dịch vụ không sạch sẽ, cần cải thiện vệ sinh'),
    ('DG06', 'ND06', 'NT06', 1, N'Nhà trọ cho sinh viên rất tiện lợi, giá cả phải chăng'),
    ('DG07', 'ND07', 'NT07', 1, N'Căn hộ chung cư mới xây đẹp, thoáng mát'),
    ('DG08', 'ND08', 'NT08', 0, N'Nhà riêng có vị trí không thuận lợi, cần cải thiện an ninh'),
    ('DG09', 'ND09', 'NT09', 1, N'Chung cư view đẹp, thoáng mát, gần trung tâm'),
    ('DG10', 'ND10', 'NT10', 1, N'Nhà phố cổ điển đẹp, không gian lịch lãm');


-- KIỂM TRA DỮ LIỆU 
SELECT * 
FROM LOAINHA

SELECT *
FROM NGUOIDUNG

SELECT *
FROM NHATRO

SELECT *
FROM DANHGIA


