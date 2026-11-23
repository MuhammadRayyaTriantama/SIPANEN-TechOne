
-- ==========================================
-- SIPANEN - SKEMA DATABASE
-- PABW PERTEMUAN 20
-- ==========================================

CREATE DATABASE IF NOT EXISTS sipanen
DEFAULT CHARACTER SET utf8mb4;

USE sipanen;

-- 1. TABEL KABUPATEN
CREATE TABLE kabupaten (
    id_kabupaten INT AUTO_INCREMENT,
    nama_kabupaten VARCHAR(100) NOT NULL,

    PRIMARY KEY (id_kabupaten),
    CONSTRAINT uq_kabupaten_nama
        UNIQUE (nama_kabupaten)
) ENGINE=InnoDB;

-- 2. TABEL KOMODITAS
CREATE TABLE komoditas (
    id_komoditas INT AUTO_INCREMENT,
    nama_komoditas VARCHAR(100) NOT NULL,
    satuan VARCHAR(30) NOT NULL,

    PRIMARY KEY (id_komoditas),
    CONSTRAINT uq_komoditas_nama
        UNIQUE (nama_komoditas)
) ENGINE=InnoDB;

-- 3. TABEL PENGGUNA
CREATE TABLE pengguna (
    id_pengguna INT AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    peran VARCHAR(50) NOT NULL,
    id_kabupaten INT NOT NULL,

    PRIMARY KEY (id_pengguna),
    CONSTRAINT uq_pengguna_email
        UNIQUE (email),

    CONSTRAINT fk_pengguna_kabupaten
        FOREIGN KEY (id_kabupaten)
        REFERENCES kabupaten(id_kabupaten)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. TABEL LAHAN
CREATE TABLE lahan (
    id_lahan INT AUTO_INCREMENT,
    nama_lahan VARCHAR(100) NOT NULL,
    luas_hektar DECIMAL(12,2) NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    id_kabupaten INT NOT NULL,
    id_pengguna INT NOT NULL,

    PRIMARY KEY (id_lahan),

    CONSTRAINT chk_lahan_luas
        CHECK (luas_hektar > 0),

    CONSTRAINT chk_lahan_latitude
        CHECK (latitude BETWEEN -90 AND 90),

    CONSTRAINT chk_lahan_longitude
        CHECK (longitude BETWEEN -180 AND 180),

    CONSTRAINT fk_lahan_kabupaten
        FOREIGN KEY (id_kabupaten)
        REFERENCES kabupaten(id_kabupaten)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_lahan_pengguna
        FOREIGN KEY (id_pengguna)
        REFERENCES pengguna(id_pengguna)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. TABEL HARGA KOMODITAS
CREATE TABLE harga_komoditas (
    id_harga INT AUTO_INCREMENT,
    tanggal DATE NOT NULL,
    harga_per_kg DECIMAL(15,2) NOT NULL,
    id_komoditas INT NOT NULL,
    id_kabupaten INT NOT NULL,

    PRIMARY KEY (id_harga),

    CONSTRAINT chk_harga_per_kg
        CHECK (harga_per_kg >= 0),

    CONSTRAINT fk_harga_komoditas
        FOREIGN KEY (id_komoditas)
        REFERENCES komoditas(id_komoditas)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_harga_kabupaten
        FOREIGN KEY (id_kabupaten)
        REFERENCES kabupaten(id_kabupaten)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. TABEL ESTIMASI HARGA
CREATE TABLE estimasi_harga (
    id_estimasi INT AUTO_INCREMENT,
    tanggal_estimasi DATE NOT NULL,
    harga_estimasi DECIMAL(15,2) NOT NULL,
    arah_perubahan VARCHAR(50) NOT NULL,
    id_komoditas INT NOT NULL,
    id_kabupaten INT NOT NULL,

    PRIMARY KEY (id_estimasi),

    CONSTRAINT chk_estimasi_harga
        CHECK (harga_estimasi >= 0),

    CONSTRAINT fk_estimasi_komoditas
        FOREIGN KEY (id_komoditas)
        REFERENCES komoditas(id_komoditas)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_estimasi_kabupaten
        FOREIGN KEY (id_kabupaten)
        REFERENCES kabupaten(id_kabupaten)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. TABEL SENSOR
CREATE TABLE sensor (
    id_sensor INT AUTO_INCREMENT,
    kode_sensor VARCHAR(50) NOT NULL,
    tanggal_pasang DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    id_lahan INT NOT NULL,

    PRIMARY KEY (id_sensor),

    CONSTRAINT uq_sensor_kode
        UNIQUE (kode_sensor),

    CONSTRAINT fk_sensor_lahan
        FOREIGN KEY (id_lahan)
        REFERENCES lahan(id_lahan)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. TABEL PANEN
CREATE TABLE panen (
    id_panen INT AUTO_INCREMENT,
    tanggal_panen DATE NOT NULL,
    jumlah_kg DECIMAL(12,2) NOT NULL,
    id_lahan INT NOT NULL,
    id_komoditas INT NOT NULL,

    PRIMARY KEY (id_panen),

    CONSTRAINT chk_panen_jumlah
        CHECK (jumlah_kg >= 0),

    CONSTRAINT fk_panen_lahan
        FOREIGN KEY (id_lahan)
        REFERENCES lahan(id_lahan)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_panen_komoditas
        FOREIGN KEY (id_komoditas)
        REFERENCES komoditas(id_komoditas)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. TABEL PEMBACAAN SENSOR
CREATE TABLE pembacaan_sensor (
    id_pembacaan INT AUTO_INCREMENT,
    waktu_baca DATETIME NOT NULL,
    kelembapan_tanah DECIMAL(5,2) NOT NULL,
    ph_tanah DECIMAL(4,2) NOT NULL,
    suhu DECIMAL(5,2) NOT NULL,
    kelembapan_udara DECIMAL(5,2) NOT NULL,
    cuaca VARCHAR(100) NOT NULL,
    id_sensor INT NOT NULL,

    PRIMARY KEY (id_pembacaan),

    CONSTRAINT chk_ph_tanah
        CHECK (ph_tanah BETWEEN 0 AND 14),

    CONSTRAINT chk_kelembapan_tanah
        CHECK (kelembapan_tanah BETWEEN 0 AND 100),

    CONSTRAINT chk_kelembapan_udara
        CHECK (kelembapan_udara BETWEEN 0 AND 100),

    CONSTRAINT fk_pembacaan_sensor
        FOREIGN KEY (id_sensor)
        REFERENCES sensor(id_sensor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. TABEL PREDIKSI PANEN
CREATE TABLE prediksi_panen (
    id_prediksi INT AUTO_INCREMENT,
    tanggal_prediksi DATE NOT NULL,
    estimasi_hasil_kg DECIMAL(12,2) NOT NULL,
    tingkat_risiko VARCHAR(50) NOT NULL,
    id_lahan INT NOT NULL,
    id_komoditas INT NOT NULL,

    PRIMARY KEY (id_prediksi),

    CONSTRAINT chk_estimasi_hasil
        CHECK (estimasi_hasil_kg >= 0),

    CONSTRAINT fk_prediksi_lahan
        FOREIGN KEY (id_lahan)
        REFERENCES lahan(id_lahan)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_prediksi_komoditas
        FOREIGN KEY (id_komoditas)
        REFERENCES komoditas(id_komoditas)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 11. TABEL PERINGATAN DINI
CREATE TABLE peringatan_dini (
    id_peringatan INT AUTO_INCREMENT,
    waktu_peringatan DATETIME NOT NULL,
    pesan TEXT NOT NULL,
    id_prediksi INT NOT NULL,

    PRIMARY KEY (id_peringatan),

    CONSTRAINT fk_peringatan_prediksi
        FOREIGN KEY (id_prediksi)
        REFERENCES prediksi_panen(id_prediksi)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;
