USE QLDEAN;

﻿--LAB4P1 25092023
--VD1: Xử lý điều kiện nếu dtb >=5 thì Pass, ngược lại thì Fail
DECLARE @dtb float = 10;

IF @dtb >= 5
	PRINT('Pass')
ELSE 
	PRINT('Faild')
--VD2: Nếu dtb <5 loại Yếu, 
--ngược lại dtb <=6.5 loại Trung bình, 
--ngược lại dtb <8 loại Khá, 
--ngược lại loại Giỏi
DECLARE @dtb2 float = 5

--IF @dtb2 < 5
--	PRINT('YẾU')
--ELSE 
--	BEGIN 
--		IF @dtb2 <= 6.5
--			PRINT('TRUNG BÌNH')
--		ELSE 
--			BEGIN
--				IF @dtb2 < 8
--					PRINT('KHÁ')
--				ELSE
--					PRINT('GIỎI')
--			END
	
--	END


IF @dtb2 < 5 
	PRINT(N'YẾU')
ELSE IF @dtb2 <= 6.5
	PRINT(N'TRUNG BÌNH')
ELSE IF @dtb2 < 8
	PRINT(N'KHÁ')
ELSE 
	PRINT(N'GIỎI')

--VD3: Hiển thị danh sách nhân viên có lương >=80000
--C1
IF(
	SELECT COUNT(*)
	FROM NHANVIEN 
	WHERE LUONG >= 80000) > 0
	BEGIN
		PRINT('NHÂN VIÊN TRÊN LƯƠNG TRÊN 80000')
		SELECT * 
		FROM NHANVIEN 
		WHERE LUONG >= 80000
	END
ELSE 
	PRINT N'KHÔNG CÓ NHÂN VIÊN LƯƠNG >= 80000'




--C2 DÙNG IF EXISTS
IF EXISTS (SELECT * FROM NHANVIEN WHERE LUONG >= 80000)
	BEGIN
		PRINT('NHÂN VIÊN TRÊN LƯƠNG TRÊN 80000')
		SELECT * 
		FROM NHANVIEN 
		WHERE LUONG >= 80000
	END
ELSE 
	PRINT N'KHÔNG CÓ NHÂN VIÊN LƯƠNG >= 80000'


--VD4: Hiển thị danh sách nhân viên phòng 5
--C1
IF (SELECT COUNT(*) FROM NHANVIEN WHERE PHG = 5) > 0
	BEGIN
		PRINT N'NHÂN VIÊN PHÒNG 5'
		SELECT *
		FROM NHANVIEN 
		WHERE PHG = 5 
	END 
ELSE 
	PRINT N'KHÔNG CÓ NHÂN VIÊN PHÒNG 5'

--C2 DÙNG IF EXISTS
IF EXISTS (SELECT COUNT(*) FROM NHANVIEN WHERE PHG = 5) 
	BEGIN
		PRINT N'NHÂN VIÊN PHÒNG 5'
		SELECT *
		FROM NHANVIEN 
		WHERE PHG = 5 
	END 
ELSE 
	PRINT N'KHÔNG CÓ NHÂN VIÊN PHÒNG 5'


--VD5: Hiển thị phòng ban có từ 3 nhân viên trở lên
--c1
IF (
	SELECT COUNT(SONV)
	FROM(
		SELECT COUNT(*) AS SONV
		FROM NHANVIEN A
		INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
		GROUP BY PHG
		HAVING COUNT(*) >= 3
	) AS BANGTAM
) > 0
	BEGIN
		PRINT('PHÒNG BAN CÓ 3 NHÂN VIÊN TRỞ LÊN')
		SELECT B.*
		FROM NHANVIEN A
		INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
		GROUP BY MAPHG, TENPHG, NG_NHANCHUC, TRPHG
		HAVING COUNT(*) >= 3
	END
ELSE
	PRINT('KHÔNG CÓ PHÒNG BAN CÓ TRÊN 3 NHÂN VIÊN')


--C2
IF EXISTS (
	SELECT PHG
	FROM NHANVIEN A
	INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
	GROUP BY PHG
	HAVING COUNT(*) >= 3
) 
	BEGIN
		PRINT('PHÒNG BAN CÓ 3 NHÂN VIÊN TRỞ LÊN')
		SELECT B.* 
		FROM NHANVIEN A
		INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
		GROUP BY MAPHG, TENPHG, NG_NHANCHUC, TRPHG
		HAVING COUNT(*) >= 3
	END
ELSE
	PRINT('KHÔNG CÓ PHÒNG BAN CÓ TRÊN 3 NHÂN VIÊN')


--VD6: Hiển thị nhân viên, chức vụ nhân viên dựa vào lương.
--Nếu lương <30000 thì là nhân viên
--Ngược lại là trưởng phòng
SELECT IIF(LUONG < 30000, N'NHÂN VIÊN', N'TRƯỞNG PHÒNG')
FROM NHANVIEN

--VD7: Hiển thị nhân viên, TENGOI dựa vào điều kiện sau:
--Nếu phái là Nam thì là Ông +TENNV
--Nếu phái là Nữ thì là Bà +TENNV
-- Ngược lại thì là Ông/Bà +TENNV
SELECT IIF(PHAI LIKE 'NAM', N'ÔNG ', IIF(PHAI LIKE N'NỮ', N'BÀ ', N'ÔNG/BÀ ')) + TENNV AS TENNV
FROM NHANVIEN

--VD8: Làm VD7 sử dụng CASE (SIMPLE, SEARCH)
SELECT TENNV = 
	CASE PHAI
		WHEN 'NAM' THEN N'ÔNG ' + TENNV
		WHEN N'NỮ' THEN N'BÀ ' + TENNV
		ELSE 'FREESEX ' + TENNV
	END
FROM NHANVIEN

SELECT TENNV = CASE
	WHEN PHAI LIKE 'NAM' THEN N'ÔNG ' + TENNV
	WHEN PHAI LIKE N'NỮ' THEN 'BÀ ' + TENNV
	ELSE 'FREESEX ' + TENNV
	END
FROM NHANVIEN

--VD9: Hiển TenNV,LUONG, THUE. Biết rằng THUẾ dựa vào mức lương: 
--LUONG trong khoảng 0 and 25000 thì Thuế= LUONG*0.1, 
--LUONG trong khoảng 25000 and 30000 thì LUONG*0.12, 
--LUONG trong khoảng 30000 and 40000 thì LUONG *0.15, 
--LUONG trong khoảng 40000 and 50000 thì LUONG *0.2, 
--còn lại LUONG*0.25
SELECT TENNV, 
		LUONG,
		THUE = 
		CASE  
			WHEN (LUONG BETWEEN 0 AND 25000) THEN LUONG * 0.1
			WHEN (LUONG BETWEEN 25000 AND 30000) THEN LUONG * 0.12
			WHEN (LUONG BETWEEN 30000 AND 40000) THEN LUONG * 0.15
			WHEN (LUONG BETWEEN 40000 AND 50000) THEN LUONG * 0.2
			ELSE LUONG * 0.25
		END
FROM NHANVIEN

--VD10: Viết câu truy vấn đếm số lượng nhân viên trong từng phòng ban, 
--nếu số lượng nhân viên nhỏ hơn 3 hiển thị “Thiếu nhân viên”, 
--ngược lại <5 hiển thị “Đủ Nhan Vien”, 
--ngược lại hiển thị”Đông nhân viên”
SELECT TENPHG, TRUONGHOP = 
			CASE 
				WHEN COUNT(*) < 3 THEN N'THIẾU NHÂN VIÊN'
				WHEN COUNT(*) < 5 THEN N'ĐỦ NHÂN VIÊN'
				ELSE N'ĐÔNG NHÂN VIÊN'
			END 
FROM NHANVIEN A 
INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
GROUP BY PHG, TENPHG


--VD11:Viết chương trình xem xét có tăng lương cho nhân viên hay không. 
--Hiển thị  TenNV,LUONG,PHG, LUONGTBPHONG, QUYETDINH. Biết rằng QUYETDINH dựa vào đk: 
--“TangLuong” nếu lương <  trung bình lương trong phòng mà nhân viên đó đang làm việc.
--“KhongTangLuong “ nếu lương > trung bình lương trong phòng mà nhân viên đó đang làm việc.
SELECT TENNV, LUONG, A.PHG, TBLUONG, 
		QUYETDINH = 
			CASE
				WHEN LUONG < TBLUONG THEN N'TANGLUONG'
				ELSE N'KHONGTANGLUONG'
			END
FROM NHANVIEN A
INNER JOIN (
	SELECT AVG(LUONG) AS TBLUONG, PHG
	FROM NHANVIEN A 
	INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
	GROUP BY PHG
) AS B ON A.PHG = B.PHG


-- Lab 4 
-- Bai 1
-- Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là
-- TenNV, cột thứ 2 nhận giá trị
-- o “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong
-- phòng mà nhân viên đó đang làm việc.
-- o “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương
-- trong phòng mà nhân viên đó đang làm việc.

-- C1
SELECT TENNV, 
		QUYETDINH = 
			CASE
				WHEN LUONG < TBLUONG THEN 'TangLuong'
				ELSE 'KhongTangLuong'
			END
FROM NHANVIEN A
INNER JOIN (
	SELECT AVG(LUONG) AS TBLUONG, PHG
	FROM NHANVIEN A 
	INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
	GROUP BY PHG
) AS B ON A.PHG = B.PHG
-- C2
DECLARE @tbluong TABLE(
	TBLUONG FLOAT,
	PHG INT
)

INSERT INTO @tbluong
	SELECT AVG(LUONG) AS TBLUONG, PHG 
	FROM NHANVIEN A 
	INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG 
	GROUP BY PHG

SELECT TENNV, 
	QUYETDINH = 
		CASE
			WHEN LUONG < TBLUONG THEN 'TangLuong'
			ELSE 'KhongTangLuong'
		END
FROM NHANVIEN A
INNER JOIN @tbluong B ON A.PHG = B.PHG


-- ➢ Viết chương trình phân loại nhân viên dựa vào mức lương.
-- o Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì
-- xếp loại “nhanvien”, ngược lại xếp loại “truongphong”
-- C1
SELECT TENNV, 
		QUYETDINH = 
			CASE
				WHEN LUONG < TBLUONG THEN 'nhanvien'
				ELSE 'truongphong'
			END
FROM NHANVIEN A
INNER JOIN (
	SELECT AVG(LUONG) AS TBLUONG, PHG
	FROM NHANVIEN A 
	INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
	GROUP BY PHG
) AS B ON A.PHG = B.PHG

-- C2
DECLARE @tbluong2 TABLE(
	TBLUONG FLOAT,
	PHG INT
)

INSERT INTO @tbluong2
	SELECT AVG(LUONG) AS TBLUONG, PHG 
	FROM NHANVIEN A 
	INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG 
	GROUP BY PHG

SELECT TENNV, 
	QUYETDINH = 
		CASE
			WHEN LUONG < TBLUONG THEN 'nhanvien'
			ELSE 'truongphong'
		END
FROM NHANVIEN A
INNER JOIN @tbluong2 B ON A.PHG = B.PHG

-- .Viết chương trình hiển thị TenNV như hình bên dưới, tùy vào cột phái của nhân viên
-- có những ngưỡi người PHAI không rõ nên em cho Mr/Ms. ạ
SELECT IIF(PHAI LIKE 'NAM', 'Mr. ', IIF(PHAI LIKE N'NỮ',  'Ms. ', 'Mr/Ms. ')) + TENNV
FROM NHANVIEN

-- Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
-- o 0<luong<25000 thì đóng 10% tiền lương
-- o 25000<luong<30000 thì đóng 12% tiền lương
-- o 30000<luong<40000 thì đóng 15% tiền lương
-- o 40000<luong<50000 thì đóng 20% tiền lương
-- o Luong>50000 đóng 25% tiền lương
-- Em hiển thị tennv cho dễ xem ạ
-- C1
SELECT TENNV, 
		CASE  
			WHEN (LUONG > 0 AND LUONG < 25000) THEN LUONG * 0.1
			WHEN (LUONG > 25000 AND LUONG < 30000) THEN LUONG * 0.12
			WHEN (LUONG > 30000 AND LUONG < 40000) THEN LUONG * 0.15
			WHEN (LUONG > 40000 AND LUONG < 50000) THEN LUONG * 0.2
			WHEN (LUONG > 50000) THEN LUONG * 0.25
		END AS THUE
FROM NHANVIEN
-- C2
SELECT TENNV, 
		CASE  
			WHEN LUONG BETWEEN 1 AND 24999 THEN LUONG * 0.1
			WHEN LUONG BETWEEN 25001 AND 29999 THEN LUONG * 0.12
			WHEN LUONG BETWEEN 30001 AND 39999 THEN LUONG * 0.15
			WHEN LUONG BETWEEN 40001 AND 49999 THEN LUONG * 0.2
			WHEN LUONG > 50000 THEN LUONG * 0.25
		END AS THUE
FROM NHANVIEN


--Bài 2: (2 điểm)
USE QLDEAN
--Sử dụng cơ sở dữ liệu QLDEAN. Thực hiện các câu truy vấn sau, sử dụng vòng
--lặp
--➢ Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.
DECLARE @max INT = 0
SELECT @max = MAX(CONVERT(INT, NHANVIEN.MANV))
FROM NHANVIEN

DECLARE @id INT = 0
WHILE @id <= @max
	BEGIN 
		IF(@id % 2 = 0)
			BEGIN
				IF EXISTS(SELECT MANV
							FROM NHANVIEN WHERE CONVERT(INT, MANV) = @id )
				BEGIN
					SELECT HONV, TENLOT, TENNV
					FROM NHANVIEN WHERE CONVERT(INT, MANV) = @id
				END
			END
		SET @id += 1
	END
	

--➢ Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng
--không tính nhân viên có MaNV là 4.
DECLARE @max1 INT = 0
DECLARE @id1 INT = 0

SELECT @max1 = MAX(CONVERT(INT, NHANVIEN.MANV))
FROM NHANVIEN

WHILE @id1 <= @max1
	BEGIN 
		IF(@id1 % 2 = 0)
			BEGIN
				IF EXISTS(SELECT MANV FROM NHANVIEN WHERE CONVERT(INT, MANV) = @id1 AND CONVERT(INT, MANV) != 4 )
					BEGIN
						SELECT HONV, TENLOT, TENNV
						FROM NHANVIEN WHERE CONVERT(INT, MANV) = @id1 AND CONVERT(INT, MANV) != 4
					END
			END
		SET @id1 += 1
	END

-- Bài 3: (3 điểm)
--➢ Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước
--o Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
--o Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Them dư lieu that bai”
--từ khối Catch
BEGIN TRY 
	INSERT INTO PHONGBAN(TENPHG, MAPHG, TRPHG, NG_NHANCHUC)
	-- Dữ liệu đúng
	-- VALUES(N'Hành chính', 9, '001',GETDATE())
	-- Dữ liệu sai
	VALUES(N'Hành chính', 'chín', '001',GETDATE())
	PRINT N'Thêm dũ liệu thành công'
END TRY
BEGIN CATCH
	PRINT N'Thêm dữ liệu thất bại'
	-- em in ra cho biết chi tiết lỗi ạ
	PRINT 'ERROR: '+ CONVERT(CHAR(5), ERROR_NUMBER()) + ': ' + ERROR_MESSAGE()
END CATCH

--➢ Viết chương trình khai báo biến @chia, thực hiện phép chia @chia cho số 0 và dùng
--RAISERROR để thông báo lỗi.
DECLARE @chia INT = 9
BEGIN TRY
	SET @chia /= 0
END TRY
BEGIN CATCH
	DECLARE @tbloi NVARCHAR(100), @mucdo INT , @trangthai INT
	SET @tbloi = ERROR_MESSAGE()
	SET @mucdo = CONVERT(INT , ERROR_SEVERITY())
	SET @trangthai = CONVERT(INT, ERROR_STATE())
	RAISERROR(@tbloi, @mucdo, @trangthai)
END CATCH

--qHiển thị tên phòng ban có mã phòng là số lẻ, sử dụng
--WHILE (mỗi vòng lặp chỉ hiển thị 1 phòng)
DECLARE @maxphg INT = 0
DECLARE @phgId INT = 0
SELECT @maxphg = MAX(CONVERT(INT, MAPHG))
FROM PHONGBAN

WHILE @phgId <= @maxphg
	BEGIN 
		IF(@phgId % 2 != 0)
			BEGIN
				IF EXISTS(SELECT MAPHG
							FROM PHONGBAN WHERE CONVERT(INT, MAPHG) = @phgId) 
					SELECT TENPHG
					FROM PHONGBAN WHERE CONVERT(INT, MAPHG) = @phgId
			END
		SET @phgId += 1
	END

--q--Hiển thị tên các công việc của đề án Tin học hóa, sử dụng WHILE,
--(mỗi vòng lặp chỉ hiển thị 1 công việc)
DECLARE @maxcongviec INT = 0
DECLARE @macongviec INT = 0

SELECT @maxcongviec = MAX(CONVERT(INT, MADA))
FROM CONGVIEC

WHILE @macongviec <= @maxcongviec
	BEGIN 
		IF EXISTS(SELECT TEN_CONG_VIEC
					FROM CONGVIEC 
					INNER JOIN DEAN ON DEAN.MADA = CONGVIEC.MADA 
					WHERE STT = 1 AND DEAN.TENDEAN LIKE N'%TIN HỌC HÓA%' AND CONGVIEC.MADA = @macongviec)
				BEGIN 
					SELECT TEN_CONG_VIEC
					FROM CONGVIEC 
					INNER JOIN DEAN ON DEAN.MADA = CONGVIEC.MADA 
					WHERE STT = 1 AND DEAN.TENDEAN LIKE N'%TIN HỌC HÓA%' AND CONGVIEC.MADA = @macongviec
				END

			IF EXISTS(SELECT TEN_CONG_VIEC
						FROM CONGVIEC 
						INNER JOIN DEAN ON DEAN.MADA = CONGVIEC.MADA 
						WHERE STT = 2 AND DEAN.TENDEAN LIKE N'%TIN HỌC HÓA%' AND CONGVIEC.MADA = @macongviec)
				BEGIN
					SELECT TEN_CONG_VIEC
					FROM CONGVIEC
					INNER JOIN DEAN ON DEAN.MADA = CONGVIEC.MADA
					WHERE STT = 2 AND DEAN.TENDEAN LIKE N'%TIN HỌC HÓA%' AND CONGVIEC.MADA = @macongviec
				END


		SET @macongviec += 1
	END




