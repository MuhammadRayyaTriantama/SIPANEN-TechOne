-- 02_data.sql - Data contoh proyek SIPANEN
-- Jalankan setelah 01_skema.sql pada database sipanen yang tabelnya masih kosong.
-- Data ini bersifat fiktif untuk pengujian aplikasi dan query.

USE sipanen;

-- 1. Data wilayah
INSERT INTO kabupaten (id_kabupaten, nama_kabupaten) VALUES
(1, 'Sleman'),
(2, 'Bantul'),
(3, 'Kulon Progo'),
(4, 'Gunungkidul'),
(5, 'Kota Yogyakarta');

-- 2. Data komoditas
INSERT INTO komoditas (id_komoditas, nama_komoditas, satuan) VALUES
(1, 'Padi', 'kg'),
(2, 'Jagung', 'kg'),
(3, 'Cabai Merah', 'kg'),
(4, 'Kedelai', 'kg'),
(5, 'Bawang Merah', 'kg');

-- 3. Jenis sensor
INSERT INTO jenis_sensor (id_jenis_sensor, nama_jenis_sensor, satuan) VALUES
(1, 'Kelembapan Tanah', '%'),
(2, 'Suhu Tanah', 'derajat C'),
(3, 'pH Tanah', 'pH'),
(4, 'Curah Hujan', 'mm'),
(5, 'Kelembapan Udara', '%');

-- 4. Pengguna contoh
-- password_hash di bawah hanya nilai dummy untuk data latihan, bukan kredensial login produksi.
INSERT INTO pengguna (id_pengguna, nama, email, password_hash, peran, id_kabupaten) VALUES
(1, 'Administrator SIPANEN', 'admin@sipanen.local', 'DEMO_HASH_ADMIN', 'Admin', NULL),
(2, 'Budi Santoso', 'budi@sipanen.local', 'DEMO_HASH_BUDI', 'Petani', 1),
(3, 'Siti Aminah', 'siti@sipanen.local', 'DEMO_HASH_SITI', 'Petani', 2),
(4, 'Agus Prasetyo', 'agus@sipanen.local', 'DEMO_HASH_AGUS', 'Petani', 3),
(5, 'Rina Wulandari', 'rina@sipanen.local', 'DEMO_HASH_RINA', 'Petugas', 4);

-- 5. Data lahan
INSERT INTO lahan (id_lahan, nama_lahan, luas_hektar, latitude, longitude, id_kabupaten, id_pengguna) VALUES
(1, 'Sawah Ngaglik', 2.50, -7.7185000, 110.3552000, 1, 2),
(2, 'Lahan Padi Imogiri', 1.80, -7.9273000, 110.3831000, 2, 3),
(3, 'Kebun Cabai Wates', 1.20, -7.8586000, 110.1587000, 3, 4),
(4, 'Lahan Jagung Playen', 3.00, -7.9441000, 110.5583000, 4, 5),
(5, 'Sawah Gamping', 2.10, -7.7952000, 110.3268000, 1, 2);

-- 6. Titik sensor pada setiap lahan
INSERT INTO titik_sensor (id_titik_sensor, nama_titik, latitude, longitude, id_lahan) VALUES
(1, 'Titik Sensor Ngaglik A', -7.7186000, 110.3553000, 1),
(2, 'Titik Sensor Imogiri A', -7.9274000, 110.3832000, 2),
(3, 'Titik Sensor Wates A', -7.8587000, 110.1588000, 3),
(4, 'Titik Sensor Playen A', -7.9442000, 110.5584000, 4),
(5, 'Titik Sensor Gamping A', -7.7953000, 110.3269000, 5);

-- 7. Sensor yang dipasang pada titik sensor
INSERT INTO sensor (id_sensor, kode_sensor, tanggal_pasang, status, id_titik_sensor, id_jenis_sensor) VALUES
(1, 'SNS-SLM-001', '2026-09-10', 'Aktif', 1, 1),
(2, 'SNS-BTL-001', '2026-09-12', 'Aktif', 2, 2),
(3, 'SNS-KP-001', '2026-09-15', 'Aktif', 3, 3),
(4, 'SNS-GK-001', '2026-09-18', 'Aktif', 4, 4),
(5, 'SNS-SLM-002', '2026-09-20', 'Aktif', 5, 5);

-- 8. Pembacaan sensor. Setiap baris mengisi nilai_angka atau nilai_teks, tidak keduanya.
INSERT INTO pembacaan_sensor (id_pembacaan, waktu_baca, nilai_angka, nilai_teks, id_sensor) VALUES
(1, '2026-11-20 07:00:00', 68.5000, NULL, 1),
(2, '2026-11-20 12:00:00', 64.2000, NULL, 1),
(3, '2026-11-20 07:15:00', 27.3000, NULL, 2),
(4, '2026-11-20 12:15:00', 29.1000, NULL, 2),
(5, '2026-11-20 07:30:00', 6.4000, NULL, 3),
(6, '2026-11-20 12:30:00', 6.2000, NULL, 3),
(7, '2026-11-20 08:00:00', 12.5000, NULL, 4),
(8, '2026-11-20 13:00:00', 3.2000, NULL, 4),
(9, '2026-11-20 08:15:00', 76.0000, NULL, 5),
(10, '2026-11-20 13:15:00', 71.5000, NULL, 5);

-- 9. Riwayat panen (minimal 8 baris)
INSERT INTO panen (id_panen, tanggal_panen, jumlah_kg, id_lahan, id_komoditas) VALUES
(1, '2026-08-10', 5200.00, 1, 1),
(2, '2026-08-18', 3650.00, 2, 1),
(3, '2026-09-05', 2100.00, 3, 3),
(4, '2026-09-14', 4800.00, 4, 2),
(5, '2026-09-25', 4300.00, 5, 1),
(6, '2026-10-08', 950.00, 3, 5),
(7, '2026-10-16', 1750.00, 4, 2),
(8, '2026-10-28', 1250.00, 2, 4);

-- 10. Harga komoditas aktual per wilayah
INSERT INTO harga_komoditas (id_harga, tanggal, harga_per_kg, id_komoditas, id_kabupaten) VALUES
(1, '2026-11-20', 6800.00, 1, 1),
(2, '2026-11-20', 5200.00, 2, 2),
(3, '2026-11-20', 28500.00, 3, 3),
(4, '2026-11-20', 11500.00, 4, 4),
(5, '2026-11-20', 24000.00, 5, 1);

-- 11. Estimasi harga komoditas
INSERT INTO estimasi_harga (id_estimasi, tanggal_estimasi, harga_estimasi, arah_perubahan, id_komoditas, id_kabupaten) VALUES
(1, '2026-11-27', 7000.00, 'Naik', 1, 1),
(2, '2026-11-27', 5100.00, 'Turun', 2, 2),
(3, '2026-11-27', 30000.00, 'Naik', 3, 3),
(4, '2026-11-27', 11500.00, 'Stabil', 4, 4),
(5, '2026-11-27', 25000.00, 'Naik', 5, 1);

-- 12. Prediksi hasil panen dan tingkat risiko
INSERT INTO prediksi_panen (id_prediksi, tanggal_prediksi, estimasi_hasil_kg, tingkat_risiko, id_lahan, id_komoditas) VALUES
(1, '2026-12-10', 5400.00, 'Rendah', 1, 1),
(2, '2026-12-12', 3400.00, 'Sedang', 2, 1),
(3, '2026-12-15', 1800.00, 'Tinggi', 3, 3),
(4, '2026-12-18', 4600.00, 'Sedang', 4, 2),
(5, '2026-12-20', 4450.00, 'Rendah', 5, 1);

-- 13. Peringatan dini yang terkait dengan prediksi panen
INSERT INTO peringatan_dini (id_peringatan, waktu_peringatan, pesan, id_prediksi) VALUES
(1, '2026-11-21 08:00:00', 'Kondisi lahan Ngaglik terpantau stabil.', 1),
(2, '2026-11-21 08:15:00', 'Perhatikan kelembapan lahan Imogiri.', 2),
(3, '2026-11-21 08:30:00', 'Risiko tinggi: periksa kondisi kebun cabai Wates.', 3),
(4, '2026-11-21 08:45:00', 'Pantau curah hujan pada lahan Playen.', 4),
(5, '2026-11-21 09:00:00', 'Kondisi sawah Gamping relatif aman.', 5);
