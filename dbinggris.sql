-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 26 Bulan Mei 2022 pada 15.54
-- Versi server: 10.4.22-MariaDB
-- Versi PHP: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `dbinggris`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCountSiswa` (IN `level_id` INT, IN `pengajar_id` INT, OUT `total` INT)  BEGIN
SELECT COUNT(id_siswa) INTO total FROM siswa WHERE id_pengajar = pengajar_id  AND id_level = level_id;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getStatusPengajar` (`pengajar_id` INT(11)) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
DECLARE status VARCHAR(255);
CALL getCountSiswa(1,1,@total_b);
CALL getCountSiswa(2,1,@total_i);
CALL getCountSiswa(3,1,@total_p);
IF @total_b >= (@total_i + @total_p) THEN
SET status = 'Pengajar Intern';
ELSEIF @total_i >= (@total_b + @total_p) THEN
SET status = 'Pengajar Muda';
ELSEIF @total_p >= (@total_b + @total_i) THEN
SET status = 'Pengajar Pro';
END IF;
RETURN status;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `level`
--

CREATE TABLE `level` (
  `id_level` int(11) NOT NULL,
  `level` enum('Beginner','Intermediate','Professional') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `level`
--

INSERT INTO `level` (`id_level`, `level`) VALUES
(1, 'Beginner'),
(2, 'Intermediate'),
(3, 'Professional');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengajar`
--

CREATE TABLE `pengajar` (
  `id_pengajar` int(11) NOT NULL,
  `nama_pengajar` varchar(30) NOT NULL,
  `level_pengajar` enum('Pengajar Intern','Pengajar Muda','Pengajar Pro') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `pengajar`
--

INSERT INTO `pengajar` (`id_pengajar`, `nama_pengajar`, `level_pengajar`) VALUES
(201, 'Ghilman', NULL),
(202, 'Hadyan', NULL),
(203, 'Iqlima', NULL),
(204, 'Ziyad', NULL);

--
-- Trigger `pengajar`
--
DELIMITER $$
CREATE TRIGGER `before_delete_pengajar` BEFORE DELETE ON `pengajar` FOR EACH ROW UPDATE siswa SET id_pengajar = NULL WHERE id_pengajar = old.id_pengajar
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `siswa`
--

CREATE TABLE `siswa` (
  `id_siswa` int(3) NOT NULL,
  `nama_siswa` varchar(30) NOT NULL,
  `status` enum('Aktif','Tidak Aktif') DEFAULT NULL,
  `id_level` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `siswa`
--

INSERT INTO `siswa` (`id_siswa`, `nama_siswa`, `status`, `id_level`) VALUES
(101, 'Bayu', 'Aktif', 1),
(102, 'Alma', 'Aktif', 1),
(103, 'Sugeng', 'Tidak Aktif', 1),
(104, 'Susi', 'Tidak Aktif', 2),
(105, 'Jarjit', 'Aktif', 2),
(106, 'Udin', 'Aktif', 3),
(107, 'Abdul', 'Aktif', 3),
(108, 'Lala', 'Tidak Aktif', 3),
(109, 'Lili', 'Aktif', 3),
(110, 'Cahya', 'Tidak Aktif', 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `ujian`
--

CREATE TABLE `ujian` (
  `id_ujian` int(11) NOT NULL,
  `tgl_ujian` date DEFAULT NULL,
  `id_siswa` int(11) DEFAULT NULL,
  `id_pengajar` int(11) DEFAULT NULL,
  `id_level` int(11) DEFAULT NULL,
  `harga` enum('30000','50000') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `ujian`
--

INSERT INTO `ujian` (`id_ujian`, `tgl_ujian`, `id_siswa`, `id_pengajar`, `id_level`, `harga`) VALUES
(1, '2022-05-26', 101, 201, 1, '30000'),
(2, '2022-05-26', 102, 201, 2, '30000'),
(3, '2022-05-26', 103, 201, 3, '50000');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vw_kartu_siswa`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vw_kartu_siswa` (
`id_siswa` int(3)
,`nama_siswa` varchar(30)
,`status` enum('Aktif','Tidak Aktif')
,`level` enum('Beginner','Intermediate','Professional')
);

-- --------------------------------------------------------

--
-- Struktur untuk view `vw_kartu_siswa`
--
DROP TABLE IF EXISTS `vw_kartu_siswa`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_kartu_siswa`  AS SELECT `siswa`.`id_siswa` AS `id_siswa`, `siswa`.`nama_siswa` AS `nama_siswa`, `siswa`.`status` AS `status`, `level`.`level` AS `level` FROM (`siswa` join `level` on(`siswa`.`id_level` = `level`.`id_level`)) WHERE `siswa`.`status` = 'Aktif' ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `level`
--
ALTER TABLE `level`
  ADD PRIMARY KEY (`id_level`);

--
-- Indeks untuk tabel `pengajar`
--
ALTER TABLE `pengajar`
  ADD PRIMARY KEY (`id_pengajar`);

--
-- Indeks untuk tabel `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id_siswa`),
  ADD KEY `id_level` (`id_level`);

--
-- Indeks untuk tabel `ujian`
--
ALTER TABLE `ujian`
  ADD PRIMARY KEY (`id_ujian`),
  ADD KEY `id_siswa` (`id_siswa`),
  ADD KEY `id_pengajar` (`id_pengajar`),
  ADD KEY `id_level` (`id_level`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `level`
--
ALTER TABLE `level`
  MODIFY `id_level` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `ujian`
--
ALTER TABLE `ujian`
  MODIFY `id_ujian` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `siswa`
--
ALTER TABLE `siswa`
  ADD CONSTRAINT `siswa_ibfk_1` FOREIGN KEY (`id_level`) REFERENCES `level` (`id_level`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `ujian`
--
ALTER TABLE `ujian`
  ADD CONSTRAINT `ujian_ibfk_1` FOREIGN KEY (`id_siswa`) REFERENCES `siswa` (`id_siswa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ujian_ibfk_2` FOREIGN KEY (`id_pengajar`) REFERENCES `pengajar` (`id_pengajar`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ujian_ibfk_3` FOREIGN KEY (`id_level`) REFERENCES `level` (`id_level`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
