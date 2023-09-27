USE QLDEAN

--1. Tìm các nhân viên làm việc ở phòng số 4
SELECT * FROM NHANVIEN
WHERE PHG = 4

--2. Tìm các nhân viên có mức lương trên 30000
SELECT * FROM NHANVIEN
WHERE LUONG > 30000

--3. Tìm các nhân viên có mức lương trên 25,000 ở phòng 4 hoặc các nhân
--viên có mức lương trên 30,000 ở phòng 5
SELECT * FROM NHANVIEN
WHERE (LUONG > 25000 AND PHG = 4) OR (LUONG > 30000 AND PHG =5)

--4. Cho biết họ tên đầy đủ của các nhân viên ở TP HCM
SELECT HONV + ' ' + TENLOT + ' ' + TENNV AS N'Họ tên đầy đủ các nhân viên TP HCM'
FROM NHANVIEN
WHERE DCHI LIKE '%TP HCM%'

--5. Cho biết họ tên đầy đủ của các nhân viên có họ bắt đầu bằng ký tự
--'N'
SELECT HONV + ' ' + TENLOT + ' ' + TENNV AS N'Họ tên đầy đủ'
FROM NHANVIEN
WHERE HONV LIKE 'N%'

--6. Cho biết ngày sinh và địa chỉ của nhân viên Dinh Ba Tien.
SELECT NGSINH, DCHI
FROM NHANVIEN
WHERE HONV + TENLOT + TENNV LIKE '%Dinh Ba Tien%'

-- Do trong csdl không có Dinh Ba Tien nên em tìm Đinh  Bá  Tiên ạ
SELECT NGSINH, DCHI
FROM NHANVIEN
WHERE HONV + TENLOT + TENNV LIKE N'%ĐINH BÁ TIÊN%'

﻿--13092023
USE QLDEAN

--VD1: Viết câu truy vấn hiển thị danh sách nhân viên nam ở vũng tàu.
SELECT * 
FROM NHANVIEN 
WHERE PHAI LIKE '%NAM%'
AND DCHI LIKE N'%VŨNG TÀU%'

--VD2: Đếm số nhân viên mỗi phòng ban. Hiển thị Tên phòng, Số NV
SELECT TENPHG,  COUNT(*) AS SONV
FROM NHANVIEN A 
JOIN PHONGBAN B ON A.PHG = B.MAPHG
GROUP BY TENPHG, MAPHG

--VD3: Hiển thị phòng ban từ 4 nhân viên trở lên. Hiển thị Tên phòng, Số NV. Sắp xếp tăng dần
--theo số nhân viên
SELECT TENPHG, COUNT(*) AS SONV
FROM NHANVIEN A
INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
GROUP BY TENPHG
HAVING COUNT(*) >= 4
ORDER BY COUNT(*) 


----VD4: Hiển thị phòng ban từ 4 nhân viên trở lên. Hiển thị Tên phòng, Số NV. Sắp xếp tăng dần
--theo số nhân viên. Chỉ tính nhân viên ở HCM
SELECT TENPHG, COUNT(*) AS SONV
FROM NHANVIEN A 
INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
WHERE DCHI LIKE '%HCM%'
GROUP BY TENPHG
HAVING COUNT(*) >= 4
ORDER BY COUNT(*)


--VD5: Hiển thị phòng ban đông nhân viên nhất
--C1
SELECT TOP 1 WITH TIES TENPHG, MAPHG, NG_NHANCHUC, TRPHG
FROM NHANVIEN A
JOIN PHONGBAN B ON A.PHG = B.MAPHG
GROUP BY TENPHG, MAPHG, NG_NHANCHUC, TRPHG
ORDER BY COUNT(*) DESC

--C2
SELECT TENPHG, MAPHG, NG_NHANCHUC, TRPHG
FROM PHONGBAN A
INNER JOIN NHANVIEN B ON A.MAPHG = B.PHG
GROUP BY TENPHG, MAPHG, NG_NHANCHUC, TRPHG
HAVING COUNT(*) = (
	SELECT TOP 1 COUNT(*)
	FROM NHANVIEN A
	JOIN PHONGBAN B ON A.PHG = B.MAPHG
	GROUP BY TENPHG, MAPHG, NG_NHANCHUC, TRPHG
	ORDER BY COUNT(*) DESC
)

-- C3
SELECT TENPHG, MAPHG, NG_NHANCHUC, TRPHG
FROM PHONGBAN A
INNER JOIN NHANVIEN B ON A.MAPHG = B.PHG 
GROUP BY TENPHG, MAPHG, NG_NHANCHUC, TRPHG
HAVING COUNT(*) = (
	SELECT MAX(SONV)
	FROM (
		SELECT COUNT(*) AS SONV
		FROM NHANVIEN A 
		INNER JOIN PHONGBAN B ON A.PHG = B.MAPHG
		GROUP BY PHG, TENPHG, NG_NHANCHUC, TRPHG
	) AS BANGTAM
)

--LAB1_B4
--4.1 Hiển thị thân nhân của nhân viên Đinh Bá Tiên
SELECT B.* 
FROM NHANVIEN A
INNER JOIN THANNHAN B ON A.MANV = B.MA_NVIEN
WHERE HONV + TENLOT + TENNV LIKE N'%ĐINH BÁ TIÊN%'

--4.2. Hiển thị tên các công việc của đề án Tin học hóa
SELECT TEN_CONG_VIEC
FROM DEAN A 
INNER JOIN CONGVIEC B ON A.MADA = B.MADA
WHERE TENDEAN LIKE N'%TIN HỌC HÓA%'

--4.3. Hiển thị tên phòng ban tham gia nhiều dự án hơn số đề án mà phòng điều hành tham gia
SELECT TENPHG
FROM PHONGBAN A
INNER JOIN DEAN B ON A.MAPHG = B.PHONG
GROUP BY TENPHG 
HAVING COUNT(*) > (
	SELECT COUNT(*)
	FROM PHONGBAN A 
	INNER JOIN DEAN B ON A.MAPHG = B.PHONG 
	WHERE TENPHG LIKE N'%ĐIỀU HÀNH%'
)



















