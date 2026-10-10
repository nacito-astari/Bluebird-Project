Create DATABASE Bluebird;
Use Bluebird

CREATE TABLE Pelanggan (
IdPelanggan CHAR(6) PRIMARY KEY,
NamaPelanggan VARCHAR(150) NOT NULL,
NomorTelepon VARCHAR(25) NOT NULL,
Email VARCHAR (30) NOT NULL,
Gender CHAR(7) NOT NULL,
DateOfBirth  DATE NOT NULL
CONSTRAINT ck_gender CHECK (Gender IN ('MALE', 'FEMALE'))
);
ALTER TABLE Pelanggan
ADD CONSTRAINT CK_Pelanggan_IdPelanggan
CHECK (
    IdPelanggan LIKE 'PLG[0-9][0-9][0-9]'
);


CREATE TABLE Pemesanan(
IdPemesanan CHAR(6) PRIMARY KEY,
WaktuPesan DATETIME NOT NULL,
LokasiJemput VARCHAR(255) NOT NULL,
LokasiTujuan VARCHAR(255) NOT NULL,
StatusPemesanan CHAR(9) NOT NULL,
IdPelanggan CHAR(6) NOT NULL,
CONSTRAINT fk_Pemesanan_Pelanggan FOREIGN KEY (IdPelanggan) REFERENCES Pelanggan(IdPelanggan),
CONSTRAINT CK_Pemesanan_IdPemesanan CHECK ( IdPemesanan LIKE 'PMN[0-9][0-9][0-9]' ),
CONSTRAINT CK_Pemesanan_StatusPemesnan CHECK (StatusPemesanan IN ('ONGOING','COMPLETED','CLOSED'))
);

CREATE TABLE POOL (
IdPool CHAR(6) PRIMARY KEY,
NamaPool Varchar(50) NOT NULL,
Alamat Varchar (100) NOT NULL,
Kapasitas INT NOT NULL,
CONSTRAINT ck_Pool_IdPool CHECK ( IdPool LIKE 'POOL[0-9][0-9]')
);



CREATE TABLE Armada (
    NomorPolisi CHAR(8) PRIMARY KEY,
    StatusKetersediaan CHAR(11) NOT NULL,
    TahunProduksi INT,
    IdPool CHAR(6), 
    
    CONSTRAINT ck_Armada_StatusKetersediaan CHECK (StatusKetersediaan IN ('AVAILABLE', 'ONTRIP', 'MAINTENANCE')), 
    CONSTRAINT fk_Armada_Pool FOREIGN KEY (IdPool) REFERENCES Pool(IdPool)
);


CREATE TABLE Pengemudi (
    IdPengemudi CHAR(6) PRIMARY KEY,
    IdMentor CHAR(6), -- Points back to IdPengemudi
    Nik VARCHAR(16) NOT NULL UNIQUE, -- NIK should be unique
    NamaPengemudi VARCHAR(150) NOT NULL,
    Rating DECIMAL(2,1),
    StatusKerja CHAR(11),
    CONSTRAINT FK_Pengemudi_Mentor FOREIGN KEY (IdMentor) REFERENCES Pengemudi(IdPengemudi),
    CONSTRAINT ck_Pengemudi_IdPengemudi CHECK (IdPengemudi LIKE 'PGM[0-9][0-9][0-9]'),
    CONSTRAINT ck_SPengemudi_StatusKerja CHECK (StatusKerja IN ('OFFLINE', 'ONLINE', 'ONTRIP', 'BREAK', 'POOLING', 'MAINTANANCE'))
);

CREATE TABLE Penugasan (
    NomorPolisi CHAR(8),
    IdPengemudi CHAR(6),
    TanggalPenugasan DATETIME,
    StatusPenugasan VARCHAR(20),
    -- Composite Primary Key: A driver + car + time defines a unique assignment
    PRIMARY KEY (NomorPolisi, IdPengemudi, TanggalPenugasan),
    CONSTRAINT FK_Penugasan_Armada FOREIGN KEY (NomorPolisi) REFERENCES Armada(NomorPolisi),
    CONSTRAINT FK_Penugasan_Pengemudi FOREIGN KEY (IdPengemudi) REFERENCES Pengemudi(IdPengemudi),
    CONSTRAINT ck_Penugasan_StatusPenugasan CHECK (StatusPenugasan IN ('ONTRIP', 'COMPLETED', 'CANCELLED'))
);

CREATE TABLE Perjalanan (
    IdPerjalanan CHAR(6) PRIMARY KEY,
    IdPemesanan CHAR(6) NOT NULL, -- 1-to-1 with Pemesanan usually
    IdPengemudi CHAR(6) NOT NULL,
    NomorPolisi CHAR(8) NOT NULL,
    JarakTempuh DECIMAL(5,2),
    WaktuMulai DATETIME,
    WaktuSelesai DATETIME,
    CONSTRAINT fk_Perjalanan_Pemesanan FOREIGN KEY (IdPemesanan) REFERENCES Pemesanan(IdPemesanan),
    CONSTRAINT fk_Perjalanan_Pengemudi FOREIGN KEY (IdPengemudi) REFERENCES Pengemudi(IdPengemudi),
    CONSTRAINT fk_Perjalanan_Armada FOREIGN KEY (NomorPolisi) REFERENCES Armada(NomorPolisi),
    CONSTRAINT ck_Perjalanan_IdPerjalanan CHECK (IdPerjalanan LIKE 'PJL[0-9][0-9][0-9]')
);

CREATE TABLE Pembayaran (
    IdPembayaran CHAR(6) PRIMARY KEY,
    IdPerjalanan CHAR(6) NOT NULL,
    JumlahPembayaran DECIMAL(12,2),
    JenisPembayaran VARCHAR(20), -- Cash, Credit, Voucher
    StatusPembayaran VARCHAR(20),
    CONSTRAINT fk_Pembayaran_Perjalanan FOREIGN KEY (IdPerjalanan) REFERENCES Perjalanan(IdPerjalanan),
    CONSTRAINT ck_Pembayaran_IdPembayaran CHECK (IdPembayaran LIKE 'PBR[0-9][0-9][0-9]')
);

ALTER TABLE Pembayaran
ADD CONSTRAINT ck_Pembayara_JenisPembayaran
CHECK ( JenisPembayaran IN ( 'Cash', 'GOPAY', 'DANA', 'TRANSFERBANK') 
);

ALTER TABLE Pembayaran
ADD CONSTRAINT ck_Pembayaran_StatusPembayaran
CHECK ( StatusPembayaran IN ( 'Completed', 'Pending', 'Failed', 'Refunded', 'Cancelled') 
);


CREATE TABLE SilverBirdArmada (
    NomorPolisi CHAR(8) PRIMARY KEY, -- Now this matches Armada!
    Warna VARCHAR(25),
    Tarif INT,
    FasilitasPremium VARCHAR(100),
    CONSTRAINT FK_Silver_Armada FOREIGN KEY (NomorPolisi) REFERENCES Armada(NomorPolisi)
);

CREATE TABLE BlueBirdArmada (
    NomorPolisi CHAR(8) PRIMARY KEY,
    Warna VARCHAR(25),
    Tarif INT,
    TipeLayanan VARCHAR(30),
    MaksPenumpang INT,
    CONSTRAINT FK_Blue_Armada FOREIGN KEY (NomorPolisi) REFERENCES Armada(NomorPolisi)
);

CREATE TABLE BigBirdArmada (
    NomorPolisi CHAR(8) PRIMARY KEY,
    Warna VARCHAR(25),
    TarifHarian INT,
    KapasitasPenumpang INT,
    JenisKendaraan VARCHAR(30),
    CONSTRAINT FK_Big_Armada FOREIGN KEY (NomorPolisi) REFERENCES Armada(NomorPolisi)
);



INSERT INTO Pool (IdPool, NamaPool, Alamat, Kapasitas) VALUES
('POOL01', 'Mampang', 'Jl. Mampang Prpt. Raya No.60, Jakarta Selatan', 120),
('POOL02', 'Cempaka Putih', 'Jl. Letjen Suprapto, Jakarta Pusat', 150),
('POOL03', 'Dago', 'Jl. Ir. H. Juanda, Bandung', 80);

INSERT INTO Armada (NomorPolisi, StatusKetersediaan, TahunProduksi, IdPool) VALUES
('D1007BD', 'AVAILABLE', 2022, 'POOL01'),
('F1014BR', 'AVAILABLE', 2018, 'POOL02'),
('B1021BY', 'AVAILABLE', 2021, 'POOL03'),
('D1028BT', 'AVAILABLE', 2017, 'POOL01'),
('F1035BX', 'AVAILABLE', 2019, 'POOL02'),
('B1042BB', 'AVAILABLE', 2019, 'POOL03'),
('D1049BD', 'AVAILABLE', 2023, 'POOL01'),
('F1056BR', 'AVAILABLE', 2017, 'POOL02'),
('B1063BY', 'AVAILABLE', 2020, 'POOL03'),
('D1070BT', 'AVAILABLE', 2017, 'POOL01'),
('F1077BX', 'AVAILABLE', 2017, 'POOL02'),
('B1084BB', 'AVAILABLE', 2022, 'POOL03');

INSERT INTO Pengemudi (IdPengemudi, Nik, NamaPengemudi, Rating, StatusKerja) VALUES
('PGM001', '1908386379402654', 'Imam Kurniawan', 4.5, 'ONLINE'),
('PGM002', '4648662737450951', 'Hendra Hidayat', 4.0, 'ONLINE'),
('PGM003', '6221355298845357', 'Dedi Setiawan', 4.0, 'ONLINE'),
('PGM004', '3303600367527374', 'Kris Nugroho', 4.7, 'ONLINE'),
('PGM005', '4965184396399232', 'Lukman Gunawan', 4.6, 'ONLINE'),
('PGM006', '4903591241683268', 'Eko Santoso', 4.9, 'ONLINE'),
('PGM007', '4781538900715308', 'Joko Saputra', 4.1, 'ONLINE'),
('PGM008', '6217132078644471', 'Fajar Pratama', 4.8, 'ONLINE'),
('PGM009', '5848931276355796', 'Agus Halim', 4.6, 'ONLINE'),
('PGM010', '1282106420971188', 'Nanda Setiawan', 4.8, 'ONLINE'),
('PGM011', '6122645033393607', 'Lukman Saputra', 4.2, 'ONLINE'),
('PGM012', '1897275906591558', 'Maman Setiawan', 4.0, 'ONLINE'),
('PGM013', '6415296129082184', 'Maman Mahendra', 4.4, 'ONLINE'),
('PGM014', '6121241205294042', 'Oki Mahendra', 4.2, 'ONLINE'),
('PGM015', '5101465095410714', 'Budi Setiawan', 4.0, 'ONLINE');


INSERT INTO Pelanggan (IdPelanggan, NamaPelanggan, NomorTelepon, Email, Gender, DateOfBirth) VALUES
('PLG001', 'Adit Ganteng', '082953835728', 'adit.ganteng@gmail.com', 'Male', '1986-08-08'),
('PLG002', 'Rexi Kawuwung', '083397817545', 'Rexi.Kawuwung@gmail.com', 'Female', '1989-05-26'),
('PLG003', 'Rap Civic', '081176306477', 'civic.Rap@gmail.com', 'Male', '2000-03-24'),
('PLG004', 'Jason Bekasi', '083336749022', 'jason.bekasi41@gmail.com', 'Female', '2003-11-07'),
('PLG005', 'nacito aja', '085768982679', 'nacito.aja98@gmail.com', 'Male', '1995-10-21'),
('PLG006', 'Ayu Permata', '083150011469', 'ayu.permata53@gmail.com', 'Female', '1994-12-12'),
('PLG007', 'Wawan Lestari', '085593354250', 'wawan.lestari52@gmail.com', 'Male', '1994-07-15'),
('PLG008', 'Rizky Kurnia', '085440688937', 'rizky.kurnia96@gmail.com', 'Male', '1988-01-24'),
('PLG009', 'Tania Santoso', '087804015216', 'tania.santoso97@gmail.com', 'Female', '1997-06-19'),
('PLG010', 'Sarah Rahmawati', '088605595229', 'sarah.rahmawati73@gmail.com', 'Female', '1990-08-28'),
('PLG011', 'Niko Permata', '081251973339', 'niko.permata46@gmail.com', 'Male', '1999-06-13'),
('PLG012', 'Maya Kurniawan', '088217490238', 'maya.kurniawan74@gmail.com', 'Female', '1998-09-23'),
('PLG013', 'Andi Permata', '081399741571', 'andi.permata5@gmail.com', 'Male', '1993-06-17'),
('PLG014', 'Intan Wijaya', '085583221215', 'intan.wijaya62@gmail.com', 'Female', '1987-12-23'),
('PLG015', 'Putri Kusuma', '088308271117', 'putri.kusuma83@gmail.com', 'Female', '1987-05-13'),
('PLG016', 'Yusuf Gunawan', '083759605988', 'yusuf.gunawan76@gmail.com', 'Male', '1998-06-09'),
('PLG017', 'Dian Lestari', '081136257280', 'dian.lestari96@gmail.com', 'Female', '2004-01-20'),
('PLG018', 'Bambang Hidayat', '086843400310', 'bambang.hidayat16@gmail.com', 'Male', '1999-10-03'),
('PLG019', 'Umar Setiawan', '081233322511', 'umar.setiawan47@gmail.com', 'Male', '1997-05-20'),
('PLG020', 'Vina Setiawan', '084681545855', 'vina.setiawan25@gmail.com', 'Female', '1997-01-24'),
('PLG021', 'Rafi Rahmawati', '081587620754', 'rafi.rahmawati77@gmail.com', 'Male', '1994-03-14'),
('PLG022', 'Lia Kurnia', '089596935279', 'lia.kurnia44@gmail.com', 'Female', '1993-01-01'),
('PLG023', 'Zahra Pratama', '081656424154', 'zahra.pratama39@gmail.com', 'Female', '1991-11-11'),
('PLG024', 'Farah Gunawan', '083402719233', 'farah.gunawan59@gmail.com', 'Female', '1994-02-05'),
('PLG025', 'Siti Wijaya', '086673170497', 'siti.wijaya54@gmail.com', 'Female', '1994-02-26');



INSERT INTO Pemesanan
(IdPemesanan, WaktuPesan, LokasiJemput, LokasiTujuan, StatusPemesanan, IdPelanggan) VALUES
('PMN001','2025-11-15 15:22:00','Kemang, Jakarta Selatan','Stasiun Gambir, Jakarta','COMPLETED','PLG001'),
('PMN002','2025-11-05 02:14:00','Tebet, Jakarta Selatan','Kota Tua, Jakarta','COMPLETED','PLG015'),
('PMN003','2025-11-29 06:55:00','Senayan, Jakarta Pusat','ITB Ganesha, Bandung','CLOSED','PLG022'),
('PMN004','2025-11-11 18:06:00','Lebak Bulus, Jakarta Selatan','Stasiun Gambir, Jakarta','COMPLETED','PLG020'),
('PMN005','2025-11-18 10:20:00','Menteng, Jakarta Pusat','Depok Town Square, Depok','ONGOING','PLG014'),
('PMN006','2025-11-24 05:45:00','Kelapa Gading, Jakarta Utara','Grand Indonesia, Jakarta','CLOSED','PLG019'),
('PMN007','2025-11-12 08:56:00','Blok M, Jakarta Selatan','Bogor Botanical Garden, Bogor','COMPLETED','PLG011'),
('PMN008','2025-11-23 05:09:00','Gambir, Jakarta Pusat','Soekarno-Hatta Airport, Tangerang','COMPLETED','PLG015'),
('PMN009','2025-11-11 03:35:00','Kuningan, Jakarta Selatan','Depok Town Square, Depok','ONGOING','PLG015'),
('PMN010','2025-11-11 02:44:00','Tebet, Jakarta Selatan','Summarecon Mall Bekasi, Bekasi','CLOSED','PLG021'),
('PMN011','2025-11-18 16:46:00','Sudirman, Jakarta Pusat','Stasiun Gambir, Jakarta','COMPLETED','PLG016'),
('PMN012','2025-11-27 15:42:00','Menteng, Jakarta Pusat','Grand Indonesia, Jakarta','COMPLETED','PLG014'),
('PMN013','2025-11-16 08:55:00','Cilandak, Jakarta Selatan','Halim Perdanakusuma Airport, Jakarta','ONGOING','PLG010'),
('PMN014','2025-11-29 13:46:00','Senayan, Jakarta Pusat','Kota Tua, Jakarta','CLOSED','PLG020'),
('PMN015','2025-11-02 13:46:00','Mangga Dua, Jakarta Utara','Bogor Botanical Garden, Bogor','COMPLETED','PLG007'),
('PMN016','2025-11-07 06:05:00','Gambir, Jakarta Pusat','Depok Town Square, Depok','COMPLETED','PLG021'),
('PMN017','2025-11-11 03:15:00','Menteng, Jakarta Pusat','Grand Indonesia, Jakarta','ONGOING','PLG020'),
('PMN018','2025-11-12 12:26:00','Kelapa Gading, Jakarta Utara','Soekarno-Hatta Airport, Tangerang','CLOSED','PLG003'),
('PMN019','2025-11-25 13:21:00','Sudirman, Jakarta Pusat','Summarecon Mall Bekasi, Bekasi','COMPLETED','PLG022'),
('PMN020','2025-11-17 06:24:00','Cilandak, Jakarta Selatan','BSD City, Tangerang Selatan','COMPLETED','PLG010'),

('PMN021','2025-11-19 04:52:00','Kuningan, Jakarta Selatan','Halim Perdanakusuma Airport, Jakarta','ONGOING','PLG017'),
('PMN022','2025-11-26 09:22:00','Lebak Bulus, Jakarta Selatan','Taman Mini, Jakarta','CLOSED','PLG006'),
('PMN023','2025-11-25 17:22:00','Tebet, Jakarta Selatan','Stasiun Gambir, Jakarta','COMPLETED','PLG002'),
('PMN024','2025-11-03 18:11:00','Senayan, Jakarta Pusat','Depok Town Square, Depok','COMPLETED','PLG007'),
('PMN025','2025-11-02 05:56:00','Lebak Bulus, Jakarta Selatan','Soekarno-Hatta Airport, Tangerang','COMPLETED','PLG023'),
('PMN026','2025-11-12 01:37:00','Kemang, Jakarta Selatan','Grand Indonesia, Jakarta','CLOSED','PLG018'),
('PMN027','2025-11-10 08:58:00','Gambir, Jakarta Pusat','Kota Tua, Jakarta','COMPLETED','PLG001'),
('PMN028','2025-11-15 05:22:00','Senayan, Jakarta Pusat','Stasiun Gambir, Jakarta','COMPLETED','PLG024'),
('PMN029','2025-11-09 23:46:00','Tebet, Jakarta Selatan','Summarecon Mall Bekasi, Bekasi','ONGOING','PLG019'),
('PMN030','2025-11-13 13:02:00','Menteng, Jakarta Pusat','BSD City, Tangerang Selatan','CLOSED','PLG016'),
('PMN031','2025-11-05 13:52:00','Blok M, Jakarta Selatan','Bogor Botanical Garden, Bogor','COMPLETED','PLG016'),
('PMN032','2025-11-12 04:42:00','Sudirman, Jakarta Pusat','Soekarno-Hatta Airport, Tangerang','COMPLETED','PLG008'),
('PMN033','2025-11-20 02:08:00','Menteng, Jakarta Pusat','Kota Tua, Jakarta','COMPLETED','PLG001'),
('PMN034','2025-11-21 21:34:00','Mangga Dua, Jakarta Utara','Grand Indonesia, Jakarta','CLOSED','PLG024'),
('PMN035','2025-11-02 11:25:00','Lebak Bulus, Jakarta Selatan','Taman Mini, Jakarta','COMPLETED','PLG020'),
('PMN036','2025-11-15 06:08:00','Cilandak, Jakarta Selatan','Halim Perdanakusuma Airport, Jakarta','ONGOING','PLG004'),
('PMN037','2025-11-04 18:26:00','Senayan, Jakarta Pusat','Stasiun Gambir, Jakarta','COMPLETED','PLG003'),
('PMN038','2025-11-20 09:42:00','Kuningan, Jakarta Selatan','Bogor Botanical Garden, Bogor','CLOSED','PLG018'),
('PMN039','2025-11-27 17:52:00','Gambir, Jakarta Pusat','Soekarno-Hatta Airport, Tangerang','COMPLETED','PLG019'),
('PMN040','2025-11-20 12:10:00','Menteng, Jakarta Pusat','Taman Mini, Jakarta','COMPLETED','PLG008'),
('PMN041','2025-11-15 22:52:00','Tebet, Jakarta Selatan','Depok Town Square, Depok','ONGOING','PLG021'),
('PMN042','2025-11-07 03:26:00','Kemang, Jakarta Selatan','BSD City, Tangerang Selatan','CLOSED','PLG002'),
('PMN043','2025-11-26 11:58:00','Blok M, Jakarta Selatan','Grand Indonesia, Jakarta','COMPLETED','PLG010'),
('PMN044','2025-11-28 18:45:00','Lebak Bulus, Jakarta Selatan','Summarecon Mall Bekasi, Bekasi','COMPLETED','PLG023'),
('PMN045','2025-11-05 05:19:00','Mangga Dua, Jakarta Utara','Kota Tua, Jakarta','COMPLETED','PLG015'),
('PMN046','2025-11-11 03:08:00','Gambir, Jakarta Pusat','Stasiun Gambir, Jakarta','CLOSED','PLG025'),
('PMN047','2025-11-11 07:20:00','Kuningan, Jakarta Selatan','Soekarno-Hatta Airport, Tangerang','COMPLETED','PLG003'),
('PMN048','2025-11-08 01:01:00','Senayan, Jakarta Pusat','Depok Town Square, Depok','COMPLETED','PLG005'),
('PMN049','2025-11-07 16:50:00','Cilandak, Jakarta Selatan','Bogor Botanical Garden, Bogor','COMPLETED','PLG014'),
('PMN050','2025-11-06 13:37:00','Tebet, Jakarta Selatan','Grand Indonesia, Jakarta','ONGOING','PLG020');

Select * From Pelanggan

INSERT INTO Perjalanan (IdPerjalanan, JarakTempuh, WaktuMulai, WaktuSelesai, IdPemesanan, IdPengemudi, NomorPolisi) VALUES
('PJL001', 29.19, '2025-11-15 15:33:00', '2025-11-15 17:05:00', 'PMN001', 'PGM001', 'D1007BD'),
('PJL002', 28.43, '2025-11-05 02:17:00', '2025-11-05 03:48:00', 'PMN002', 'PGM002', 'F1014BR'),
('PJL003', 25.12, '2025-11-29 06:59:00', '2025-11-29 08:19:00', 'PMN003', 'PGM003', 'B1021BY'),
('PJL004', 20.81, '2025-11-11 18:12:00', '2025-11-11 19:20:00', 'PMN004', 'PGM004', 'D1028BT'),
('PJL005', 10.54, '2025-11-18 10:30:00', '2025-11-18 11:08:00', 'PMN005', 'PGM005', 'F1035BX'),
('PJL006', 13.41, '2025-11-24 05:57:00', '2025-11-24 06:43:00', 'PMN006', 'PGM006', 'B1042BB'),
('PJL007', 24.02, '2025-11-12 09:07:00', '2025-11-12 10:30:00', 'PMN007', 'PGM007', 'D1049BD'),
('PJL008', 29.07, '2025-11-23 05:14:00', '2025-11-23 06:47:00', 'PMN008', 'PGM008', 'F1056BR'),
('PJL009', 19.09, '2025-11-11 03:46:00', '2025-11-11 04:52:00', 'PMN009', 'PGM009', 'B1063BY'),
('PJL010', 27.4, '2025-11-11 02:51:00', '2025-11-11 04:20:00', 'PMN010', 'PGM010', 'D1070BT'),
('PJL011', 33.79, '2025-11-18 16:54:00', '2025-11-18 18:44:00', 'PMN011', 'PGM011', 'F1077BX'),
('PJL012', 6.93, '2025-11-27 15:47:00', '2025-11-27 16:24:00', 'PMN012', 'PGM012', 'B1084BB'),
('PJL013', 34.76, '2025-11-16 09:04:00', '2025-11-16 10:59:00', 'PMN013', 'PGM013', 'D1007BD'),
('PJL014', 25.86, '2025-11-29 13:49:00', '2025-11-29 15:20:00', 'PMN014', 'PGM014', 'F1014BR'),
('PJL015', 30.63, '2025-11-02 13:54:00', '2025-11-02 15:33:00', 'PMN015', 'PGM015', 'B1021BY'),
('PJL016', 29.21, '2025-11-07 06:13:00', '2025-11-07 07:50:00', 'PMN016', 'PGM001', 'D1028BT'),
('PJL017', 27.55, '2025-11-11 03:22:00', '2025-11-11 04:53:00', 'PMN017', 'PGM002', 'F1035BX'),
('PJL018', 29.07, '2025-11-12 12:30:00', '2025-11-12 14:05:00', 'PMN018', 'PGM003', 'B1042BB'),
('PJL019', 14.19, '2025-11-25 13:24:00', '2025-11-25 14:10:00', 'PMN019', 'PGM004', 'D1049BD'),
('PJL020', 24.84, '2025-11-17 06:31:00', '2025-11-17 07:55:00', 'PMN020', 'PGM005', 'F1056BR'),
('PJL021', 12.98, '2025-11-19 04:59:00', '2025-11-19 05:44:00', 'PMN021', 'PGM006', 'B1063BY'),
('PJL022', 28.11, '2025-11-26 09:30:00', '2025-11-26 11:04:00', 'PMN022', 'PGM007', 'D1070BT'),
('PJL023', 23.52, '2025-11-25 17:25:00', '2025-11-25 18:46:00', 'PMN023', 'PGM008', 'F1077BX'),
('PJL024', 7.08, '2025-11-03 18:19:00', '2025-11-03 18:47:00', 'PMN024', 'PGM009', 'B1084BB'),
('PJL025', 20.65, '2025-11-02 06:00:00', '2025-11-02 07:07:00', 'PMN025', 'PGM010', 'D1007BD'),
('PJL026', 29.04, '2025-11-12 01:44:00', '2025-11-12 03:18:00', 'PMN026', 'PGM011', 'F1014BR'),
('PJL027', 34.12, '2025-11-10 09:03:00', '2025-11-10 10:52:00', 'PMN027', 'PGM012', 'B1021BY'),
('PJL028', 7.91, '2025-11-15 05:31:00', '2025-11-15 05:59:00', 'PMN028', 'PGM013', 'D1028BT'),
('PJL029', 30.74, '2025-11-10 00:00:00', '2025-11-10 01:39:00', 'PMN029', 'PGM014', 'F1035BX'),
('PJL030', 25.02, '2025-11-13 13:10:00', '2025-11-13 14:31:00', 'PMN030', 'PGM015', 'B1042BB'),
('PJL031', 11.61, '2025-11-05 13:56:00', '2025-11-05 14:38:00', 'PMN031', 'PGM001', 'D1049BD'),
('PJL032', 13.6, '2025-11-12 04:54:00', '2025-11-12 05:42:00', 'PMN032', 'PGM002', 'F1056BR'),
('PJL033', 17.63, '2025-11-20 02:18:00', '2025-11-20 03:16:00', 'PMN033', 'PGM003', 'B1063BY'),
('PJL034', 23.8, '2025-11-21 21:41:00', '2025-11-21 23:03:00', 'PMN034', 'PGM004', 'D1070BT'),
('PJL035', 20.62, '2025-11-02 11:36:00', '2025-11-02 12:43:00', 'PMN035', 'PGM005', 'F1077BX'),
('PJL036', 32.09, '2025-11-15 06:20:00', '2025-11-15 08:06:00', 'PMN036', 'PGM006', 'B1084BB'),
('PJL037', 15.92, '2025-11-04 18:29:00', '2025-11-04 19:19:00', 'PMN037', 'PGM007', 'D1007BD'),
('PJL038', 6.17, '2025-11-20 09:49:00', '2025-11-20 10:16:00', 'PMN038', 'PGM008', 'F1014BR'),
('PJL039', 26.42, '2025-11-27 17:55:00', '2025-11-27 19:27:00', 'PMN039', 'PGM009', 'B1021BY'),
('PJL040', 32.83, '2025-11-20 12:16:00', '2025-11-20 14:02:00', 'PMN040', 'PGM010', 'D1028BT'),
('PJL041', 32.23, '2025-11-15 23:00:00', '2025-11-16 00:46:00', 'PMN041', 'PGM011', 'F1035BX'),
('PJL042', 9.75, '2025-11-07 03:30:00', '2025-11-07 04:03:00', 'PMN042', 'PGM012', 'B1042BB'),
('PJL043', 11.33, '2025-11-26 12:07:00', '2025-11-26 12:45:00', 'PMN043', 'PGM013', 'D1049BD'),
('PJL044', 15.13, '2025-11-28 18:57:00', '2025-11-28 19:46:00', 'PMN044', 'PGM014', 'F1056BR'),
('PJL045', 34.66, '2025-11-05 05:30:00', '2025-11-05 07:24:00', 'PMN045', 'PGM015', 'B1063BY'),
('PJL046', 28.22, '2025-11-11 03:16:00', '2025-11-11 04:51:00', 'PMN046', 'PGM001', 'D1070BT'),
('PJL047', 36.53, '2025-11-11 07:30:00', '2025-11-11 09:31:00', 'PMN047', 'PGM002', 'F1077BX'),
('PJL048', 36.93, '2025-11-08 01:08:00', '2025-11-08 03:12:00', 'PMN048', 'PGM003', 'B1084BB'),
('PJL049', 10.73, '2025-11-07 16:53:00', '2025-11-07 17:34:00', 'PMN049', 'PGM004', 'D1007BD'),
('PJL050', 24.75, '2025-11-06 13:46:00', '2025-11-06 15:08:00', 'PMN050', 'PGM005', 'F1014BR');


INSERT INTO Pembayaran (IdPembayaran, JumlahPembayaran, JenisPembayaran, StatusPembayaran, IdPerjalanan) VALUES
('PBR001', 227892.5, 'TRANSFERBANK', 'Completed', 'PJL001'),
('PBR002', 223317.5, 'Cash', 'Completed', 'PJL002'),
('PBR003', 200400.0, 'TRANSFERBANK', 'Completed', 'PJL003'),
('PBR004', 164675.0, 'Cash', 'Completed', 'PJL004'),
('PBR005', 91250.0, 'GOPAY', 'Completed', 'PJL005'),
('PBR006', 111575.0, 'DANA', 'Completed', 'PJL006'),
('PBR007', 190150.0, 'GOPAY', 'Completed', 'PJL007'),
('PBR008', 230205.0, 'Cash', 'Completed', 'PJL008'),
('PBR009', 153675.0, 'DANA', 'Completed', 'PJL009'),
('PBR010', 214000.0, 'DANA', 'Completed', 'PJL010'),
('PBR011', 266925.0, 'TRANSFERBANK', 'Completed', 'PJL011'),
('PBR012', 62375.0, 'TRANSFERBANK', 'Completed', 'PJL012'),
('PBR013', 271700.0, 'DANA', 'Completed', 'PJL013'),
('PBR014', 204950.0, 'GOPAY', 'Completed', 'PJL014'),
('PBR015', 240725.0, 'TRANSFERBANK', 'Completed', 'PJL015'),
('PBR016', 230575.0, 'TRANSFERBANK', 'Completed', 'PJL016'),
('PBR017', 216625.0, 'DANA', 'Completed', 'PJL017'),
('PBR018', 230205.0, 'GOPAY', 'Completed', 'PJL018'),
('PBR019', 118425.0, 'DANA', 'Completed', 'PJL019'),
('PBR020', 196300.0, 'DANA', 'Completed', 'PJL020'),
('PBR021', 105350.0, 'Cash', 'Completed', 'PJL021'),
('PBR022', 220825.0, 'Cash', 'Completed', 'PJL022'),
('PBR023', 186900.0, 'TRANSFERBANK', 'Completed', 'PJL023'),
('PBR024', 63400.0, 'DANA', 'Completed', 'PJL024'),
('PBR025', 162875.0, 'Cash', 'Completed', 'PJL025'),
('PBR026', 229980.0, 'TRANSFERBANK', 'Completed', 'PJL026'),
('PBR027', 264900.0, 'Cash', 'Completed', 'PJL027'),
('PBR028', 69725.0, 'TRANSFERBANK', 'Completed', 'PJL028'),
('PBR029', 242050.0, 'DANA', 'Completed', 'PJL029'),
('PBR030', 197650.0, 'TRANSFERBANK', 'Completed', 'PJL030'),
('PBR031', 97075.0, 'DANA', 'Completed', 'PJL031'),
('PBR032', 112000.0, 'TRANSFERBANK', 'Completed', 'PJL032'),
('PBR033', 142225.0, 'Cash', 'Completed', 'PJL033'),
('PBR034', 189650.0, 'GOPAY', 'Completed', 'PJL034'),
('PBR035', 162650.0, 'GOPAY', 'Completed', 'PJL035'),
('PBR036', 255725.0, 'Cash', 'Completed', 'PJL036'),
('PBR037', 131400.0, 'TRANSFERBANK', 'Completed', 'PJL037'),
('PBR038', 56675.0, 'GOPAY', 'Completed', 'PJL038'),
('PBR039', 209150.0, 'TRANSFERBANK', 'Completed', 'PJL039'),
('PBR040', 257225.0, 'TRANSFERBANK', 'Completed', 'PJL040'),
('PBR041', 252725.0, 'Cash', 'Completed', 'PJL041'),
('PBR042', 82125.0, 'TRANSFERBANK', 'Completed', 'PJL042'),
('PBR043', 94975.0, 'Cash', 'Completed', 'PJL043'),
('PBR044', 128475.0, 'TRANSFERBANK', 'Completed', 'PJL044'),
('PBR045', 268950.0, 'GOPAY', 'Completed', 'PJL045'),
('PBR046', 220600.0, 'Cash', 'Completed', 'PJL046'),
('PBR047', 284975.0, 'TRANSFERBANK', 'Completed', 'PJL047'),
('PBR048', 287975.0, 'DANA', 'Completed', 'PJL048'),
('PBR049', 89975.0, 'TRANSFERBANK', 'Completed', 'PJL049'),
('PBR050', 196075.0, 'DANA', 'Completed', 'PJL050');


INSERT INTO SilverBirdArmada
(NomorPolisi, Warna, Tarif, FasilitasPremium) VALUES
('D1007BD', 'Hitam', 150000, 'Leather Seat, WiFi'),
('F1014BR', 'Hitam', 145000, 'Leather Seat'),
('B1021BY', 'Hitam', 155000, 'Leather Seat, WiFi, Charger'),
('D1028BT', 'Hitam', 148000, 'Leather Seat'),
('F1035BX', 'Hitam', 150000, 'Leather Seat, Air Purifier');

INSERT INTO BluebirdArmada
(NomorPolisi, Warna, Tarif, TipeLayanan, MaksPenumpang) VALUES
('B1042BB', 'Biru', 7000, 'Regular', 4),
('D1049BD', 'Biru', 7200, 'Regular', 4),
('F1056BR', 'Biru', 7500, 'Executive', 4),
('B1063BY', 'Biru', 7000, 'Regular', 4),
('D1070BT', 'Biru', 7800, 'Executive', 4),
('F1077BX', 'Biru', 7600, 'Executive', 4);

INSERT INTO BigBirdArmada
(NomorPolisi, Warna, TarifHarian, KapasitasPenumpang, JenisKendaraan) VALUES
('B1084BB', 'Putih', 2500000, 12, 'HiAce'),
('D1007BD', 'Putih', 2800000, 20, 'Medium Bus'),
('F1014BR', 'Putih', 3200000, 30, 'Large Bus');

INSERT INTO Penugasan 
(NomorPolisi, IdPengemudi, TanggalPenugasan, StatusPenugasan) VALUES
('D1007BD', 'PGM001', '2025-11-15 06:00:00', 'COMPLETED'),
('F1014BR', 'PGM002', '2025-11-05 06:00:00', 'COMPLETED'),
('B1021BY', 'PGM003', '2025-11-29 06:00:00', 'COMPLETED'),
('D1028BT', 'PGM004', '2025-11-11 06:00:00', 'COMPLETED'),
('F1035BX', 'PGM005', '2025-11-18 06:00:00', 'ONTRIP'), 
('B1042BB', 'PGM006', '2025-11-24 06:00:00', 'COMPLETED'),
('D1049BD', 'PGM007', '2025-11-12 06:00:00', 'COMPLETED'),
('F1056BR', 'PGM008', '2025-11-23 06:00:00', 'COMPLETED'),
('B1063BY', 'PGM009', '2025-11-11 06:00:00', 'ONTRIP'), 
('D1070BT', 'PGM010', '2025-11-11 06:00:00', 'COMPLETED'),
('D1007BD', 'PGM010', '2025-11-02 06:00:00', 'COMPLETED'),
('F1014BR', 'PGM014', '2025-11-29 06:00:00', 'COMPLETED'),
('B1021BY', 'PGM015', '2025-11-02 06:00:00', 'COMPLETED'),
('D1028BT', 'PGM001', '2025-11-07 06:00:00', 'COMPLETED'),
('F1035BX', 'PGM002', '2025-11-11 06:00:00', 'COMPLETED'),
('B1084BB', 'PGM013', '2025-11-15 08:00:00', 'CANCELLED'),
('F1077BX', 'PGM011', '2025-11-18 09:00:00', 'CANCELLED'),
('D1049BD', 'PGM013', '2025-11-26 10:00:00', 'COMPLETED'),
('F1056BR', 'PGM014', '2025-11-28 11:00:00', 'COMPLETED'),
('B1063BY', 'PGM015', '2025-11-05 12:00:00', 'COMPLETED');