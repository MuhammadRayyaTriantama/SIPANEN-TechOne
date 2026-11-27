-- 03_query.sql - Query contoh proyek SIPANEN
-- Jalankan setelah 01_skema.sql dan 02_data.sql berhasil dijalankan.
-- Setiap bagian mencatat pertanyaan bisnis, fitur, dan jumlah baris hasil
-- berdasarkan data contoh yang ada di 02_data.sql.

USE sipanen;
-- 1. Pertanyaan bisnis: Lahan apa saja yang terdaftar, berada di kabupaten
--    mana, dan siapa pengguna/petani yang bertanggung jawab?
-- Halaman/fitur: Daftar lahan pertanian.
-- Teknik: INNER JOIN 3 tabel (lahan, kabupaten, pengguna).
-- Jumlah hasil pada data contoh: 5 baris.
SELECT
    l.nama_lahan,
    l.luas_hektar,
    k.nama_kabupaten,
    p.nama AS nama_penanggung_jawab
FROM lahan AS l
INNER JOIN kabupaten AS k
    ON l.id_kabupaten = k.id_kabupaten
INNER JOIN pengguna AS p
    ON l.id_pengguna = p.id_pengguna
ORDER BY k.nama_kabupaten, l.nama_lahan;

-- 2. Pertanyaan bisnis: Kabupaten mana yang belum memiliki lahan terdaftar?
-- Halaman/fitur: Ringkasan sebaran wilayah pertanian.
-- Teknik: LEFT JOIN dengan IS NULL.
-- Jumlah hasil pada data contoh: 1 baris (Kota Yogyakarta).
SELECT
    k.id_kabupaten,
    k.nama_kabupaten
FROM kabupaten AS k
LEFT JOIN lahan AS l
    ON k.id_kabupaten = l.id_kabupaten
WHERE l.id_lahan IS NULL;

-- 3. Pertanyaan bisnis: Komoditas apa yang total hasil panennya lebih dari
--    4.000 kg?
-- Halaman/fitur: Ringkasan hasil panen per komoditas.
-- Teknik: JOIN, GROUP BY, SUM, dan HAVING.
-- Jumlah hasil pada data contoh: 2 baris (Padi dan Jagung).
SELECT
    k.nama_komoditas,
    SUM(p.jumlah_kg) AS total_panen_kg
FROM panen AS p
INNER JOIN komoditas AS k
    ON p.id_komoditas = k.id_komoditas
GROUP BY k.id_komoditas, k.nama_komoditas
HAVING SUM(p.jumlah_kg) > 4000
ORDER BY total_panen_kg DESC;

-- 4. Pertanyaan bisnis: Lahan mana yang prediksi hasil panennya di atas
--    rata-rata seluruh prediksi?
-- Halaman/fitur: Daftar prediksi hasil panen.
-- Teknik: Subquery untuk menghitung rata-rata prediksi.
-- Jumlah hasil pada data contoh: 3 baris.
SELECT
    l.nama_lahan,
    pp.estimasi_hasil_kg,
    pp.tingkat_risiko
FROM prediksi_panen AS pp
INNER JOIN lahan AS l
    ON pp.id_lahan = l.id_lahan
WHERE pp.estimasi_hasil_kg > (
    SELECT AVG(estimasi_hasil_kg)
    FROM prediksi_panen
)
ORDER BY pp.estimasi_hasil_kg DESC;

-- 5. Pertanyaan bisnis: Berapa rata-rata hasil pembacaan untuk setiap sensor
--    dan jenis sensor yang digunakan?
-- Halaman/fitur: Pemantauan kondisi lahan dari sensor.
-- Teknik: JOIN 3 tabel dan GROUP BY.
-- Jumlah hasil pada data contoh: 5 baris.
SELECT
    s.kode_sensor,
    js.nama_jenis_sensor,
    js.satuan,
    ROUND(AVG(ps.nilai_angka), 2) AS rata_rata_pembacaan
FROM sensor AS s
INNER JOIN jenis_sensor AS js
    ON s.id_jenis_sensor = js.id_jenis_sensor
INNER JOIN pembacaan_sensor AS ps
    ON s.id_sensor = ps.id_sensor
GROUP BY s.id_sensor, s.kode_sensor, js.nama_jenis_sensor, js.satuan
ORDER BY s.kode_sensor;

-- 6. Pertanyaan bisnis: Bagaimana perbandingan harga komoditas saat ini
--    dengan estimasi harga berikutnya di setiap kabupaten?
-- Halaman/fitur: Informasi harga dan estimasi harga komoditas.
-- Teknik: JOIN 4 tabel.
-- Jumlah hasil pada data contoh: 5 baris.
SELECT
    k.nama_komoditas,
    kab.nama_kabupaten,
    h.harga_per_kg AS harga_saat_ini,
    e.harga_estimasi,
    e.arah_perubahan,
    h.tanggal AS tanggal_harga,
    e.tanggal_estimasi
FROM harga_komoditas AS h
INNER JOIN estimasi_harga AS e
    ON h.id_komoditas = e.id_komoditas
   AND h.id_kabupaten = e.id_kabupaten
INNER JOIN komoditas AS k
    ON h.id_komoditas = k.id_komoditas
INNER JOIN kabupaten AS kab
    ON h.id_kabupaten = kab.id_kabupaten
ORDER BY kab.nama_kabupaten, k.nama_komoditas;
