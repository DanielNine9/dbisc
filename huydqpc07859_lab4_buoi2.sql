﻿--LAB4P2_27092023
--VD1: Hiển thị tên của bạn 50 lần
DECLARE @num INT = 1;
WHILE @num < 50
	BEGIN
		PRINT N'Đinh Quốc Huy'
		set @num += 1
	END


--VD2:Viết chương trình tính tổng các số chẵn từ 1 tới 10.
-- 1 2 3 4 5 6 7 8 9 10 TONG = TONG+1 TONG=TONG+2 TONG =TONG+3 ....
DECLARE @i INT = 1, @tong int = 0
WHILE @i <= 10
	BEGIN
		IF(@i % 2 = 0)
			set @tong += @i
		set @i += 1
	END 
PRINT N'Tổng: '+ CAST(@tong AS VARCHAR)

--VD3: Viết chương trình tính tổng các số chẵn từ 1 tới 10 nhưng bỏ số 4.
DECLARE @i3 INT = 1, @tong3 int = 0
WHILE @i3 <= 10
	BEGIN
		IF(@i3 % 2 = 0)
			BEGIN 
				IF(@i3 != 4) 
					set @tong3 += @i3
			END
		set @i3 += 1
	END 
PRINT N'Tổng: '+ CAST(@tong3 AS VARCHAR)

-- VD4: Tính 5!
DECLARE @i4 INT = 5, @tong4 INT = 1
WHILE @i4 >= 0
	BEGIN 
		IF(@i4 != 0)
			SET @tong4 *= @i4
		ELSE 
			SET @tong4 *= 1
	END 

--VD5: Hiển thị Họ tên + tuổi

--VD6: Thêm dữ liệu vào bảng PHONGBAN

--VD7: Hiển thị kết quả 100/0