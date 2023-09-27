--lab 2 18092023
USE QLDEAN

--VD1: Hiển thị số nhân viên trong công ty. Sử dụng biến lưu kết quả. Truy xuất giá trị biến
DECLARE @sonv INT

SELECT @sonv = COUNT(*) 
FROM NHANVIEN

-- SELECT @SONV

PRINT N'SỐ NHÂN VIÊN TRONG CÔNG TY LÀ: ' + CAST(@SONV AS VARCHAR)

--VD2: Hiển thị tên nhân viên có mã 001. Sử dụng biến lưu kết quả.Truy xuất giá trị biến
DECLARE @TEN NVARCHAR(10)

SELECT @TEN = TENNV
FROM NHANVIEN
WHERE MANV = '001'

SELECT @TEN

PRINT N'TÊN NHÂN VIEN CÓ MÃ 001 LÀ: ' + @TEN

--VD3: Hiển thị số nhân viên từng phòng ban. Sử dụng biến lưu kết quả. Truy xuất giá trị biến
DECLARE @NVPB TABLE(
	TENPHG NVARCHAR(30),
	SONV INT
)

INSERT INTO @NVPB
	SELECT TENPHG, COUNT(*) AS SONV
	FROM NHANVIEN A
	INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
	GROUP BY PHG, TENPHG

SELECT *
FROM @NVPB

--VD4: Hiển thị TENNV,DIACHI,MAPHONG của nhân viên mã 001. 
--Sử dụng biến lưu kết quả. Truy xuất giá trị biến
DECLARE @NV001 TABLE(
	TENNVV NVARCHAR(30),
	DCHI NVARCHAR(30),
	MAPHONG INT
)

INSERT INTO @NV001
	SELECT TENNV, DCHI, PHG
	FROM NHANVIEN
	WHERE MANV = '001'

SELECT * FROM @NV001


--VD5: Hiển thị chu vi hình chữ nhật, khi biết chiều dài là 6, chiều rộng là 5. 
--Sử dụng biến lưu kết quả. Truy xuất giá trị biến
DECLARE @DAI INT, @RONG INT, @CV INT

SET @DAI = 6
SET @RONG = 5
SET @CV = (@DAI + @RONG) * 2

-- SELECT @CV

PRINT N'CHU VI HÌNH CHỮ NHẬT '+ CAST(@CV AS VARCHAR)

--VD6: Hiển thị lương trung bình của các nhân viên.
--Sử dụng biến lưu kết quả. Truy xuất giá trị biến
DECLARE @LTB FLOAT

SELECT @LTB = AVG(LUONG)
FROM NHANVIEN 
GROUP BY MANV

SELECT @LTB

PRINT N'LƯƠNG TRUNG BÌNH CỦA CÁC NHAN VIÊN: ' + CAST(@LTB AS VARCHAR)

--VD7: Hiển thị TENNV,DIACHI,MAPHONG  nhân viên phòng 5. 
--Sử dụng biến NV_P5 lưu kết quả. Truy xuất giá trị biến
DECLARE @NVP5 TABLE(
	TENNV NVARCHAR(30),
	DCHI NVARCHAR(30),
	MAPHG INT
)

INSERT INTO @NVP5
	SELECT TENNV, DCHI, PHG
	FROM NHANVIEN 
	WHERE PHG = 5

SELECT * FROM @NVP5
--Có thể tham chiếu đến biến bảng trong câu lệnh  SELECT, INSERT, UPDATE, DELETE
--VD8: Thêm nhân viên Nhân, ở Nguyễn Văn Linh, Cần Thơ, phòng 5 vào biến bảng NV_P5
-- Thêm nhân viên Nhân vào biến bảng NV_P5
INSERT INTO @NVP5 (TENNV, DCHI, MAPHG)
VALUES (N'Nhân', N'Nguyễn Văn Linh, Cần Thơ', 5)

SELECT * FROM @NVP5
--So sánh biến bảng và bảng tạm????????????
-- Biến bảng có thời gian tồn tại ngắn hơn và thường được sử dụng cho các tác vụ nhỏ và tạm thời.
-- Bảng tạm tồn tại lâu hơn và thường được sử dụng cho các tác vụ lớn hoặc dữ liệu cần được lưu trữ trong nhiều phiên làm việc.
-- Cả hai đều cho phép bạn lưu trữ và xử lý dữ liệu tạm thời, nhưng biến bảng thường tốn ít tài nguyên hơn trong bộ nhớ.
-- Bảng tạm được lưu trữ trên đĩa và có thể được sử dụng lại trong các phiên làm việc tiếp theo, trong khi biến bảng không có khả năng này.
-- Việc sử dụng biến bảng thường đơn giản hơn và phù hợp cho các tác vụ đơn giản, trong khi bảng tạm phù hợp cho các tác vụ phức tạp hơn hoặc khi cần lưu trữ dữ liệu tạm thời lâu dài.

--Cập nhật địa chỉ thành 3/2,Cần Thơ cho nhân viên Nhân ở phòng 5
UPDATE @NVP5
SET DCHI = N'3/2, Cần Thơ'
WHERE TENNV = N'Nhân' AND MAPHG = 5

SELECT * FROM @NVP5
--Xóa nhân viên Nhân phòng 5 ở Cần Thơ
DELETE FROM @NVP5
WHERE TENNV = N'Nhân' AND MAPHG = 5

SELECT * FROM @NVP5
--VD9: Hiển thị nhân viên ở TP HCM.
--Sử dụng biến lưu kết quả. Truy xuất giá trị biến
DECLARE @nvtphcm TABLE(
	HONV NVARCHAR(15),
	TENLOT NVARCHAR(15),
	TENNV NVARCHAR(15),
	MANV NVARCHAR(9),
	NGSINH DATETIME, 
	DCHI NVARCHAR(30),
	PHAI NVARCHAR(3),
	LUONG FLOAT, 
	MANQL VARCHAR(9),
	PHG INT
)

INSERT INTO @nvtphcm
	SELECT *
	FROM NHANVIEN 
	WHERE DCHI LIKE '%TP HCM%'

SELECT *
FROM @nvtphcm

--VD10: Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) 
--có số thân nhân nhiều hơn số thân nhân của Đinh Quỳnh Như. 
--Sử dụng biến lưu kết quả. Truy xuất giá trị biến
DECLARE @tennv TABLE(
	HONV NVARCHAR(15),
	TENLOT NVARCHAR(15),
	TENNV NVARCHAR(15)
)

INSERT INTO @tennv
SELECT HONV, TENLOT, TENNV
FROM NHANVIEN A
INNER JOIN THANNHAN B ON A.MANV = B.MA_NVIEN
GROUP BY HONV, TENLOT, TENNV, MANV
HAVING COUNT(*) > (
	SELECT COUNT(*)
	FROM NHANVIEN A 
	INNER JOIN THANNHAN B ON A.MANV = B.MA_NVIEN
	WHERE HONV + ' ' + TENLOT + ' ' + TENNV LIKE N'%ĐINH QUỲNH NHƯ%' 
)

SELECT * FROM @tennv

--VD11: Với các công việc trung bình mất trên 20 giờ, liệt kê tên tên công việc 
--và số nhân viên tham gia của từng công việc.Sử dụng biến lưu kết quả. Truy xuất giá trị biến
DECLARE @tencv TABLE(
	TCV NVARCHAR(30),
	SLNVTG INT
)

INSERT INTO @tencv
SELECT TEN_CONG_VIEC, COUNT(*)
FROM CONGVIEC A 
INNER JOIN PHANCONG B ON A.MADA = B.MADA 
GROUP BY TEN_CONG_VIEC, A.MADA, A.STT
HAVING AVG(THOIGIAN) > 20

SELECT * FROM @tencv




