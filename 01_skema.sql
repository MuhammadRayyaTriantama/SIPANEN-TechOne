
CREATE DATABASE IF NOT EXISTS sipanen
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE sipanen;

CREATE TABLE kabupaten (
    id_kabupaten INT AUTO_INCREMENT PRIMARY KEY,
    nama_kabupaten VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE komoditas (
    id_komoditas INT AUTO_INCREMENT PRIMARY KEY,
    nama_komoditas VARCHAR(100) NOT NULL UNIQUE,
    satuan VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE jenis_sensor (
    id_jenis_sensor INT AUTO_INCREMENT PRIMARY KEY,
    nama_jenis_sensor VARCHAR(100) NOT NULL UNIQUE,
    satuan VARCHAR(30)
) ENGINE=InnoDB;

CREATE TABLE pengguna (
    id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    peran VARCHAR(30) NOT NULL,
    id_kabupaten INT NULL,
    CONSTRAINT fk_pengguna_kabupaten
        FOREIGN KEY (id_kabupaten)
        REFERENCES kabupaten(id_kabupaten)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE lahan (
    id_lahan INT AUTO_INCREMENT PRIMARY KEY,
    nama_lahan VARCHAR(100) NOT NULL,
    luas_hektar DECIMAL(10,2) NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    id_kabupaten INT NOT NULL,
    id_pengguna INT NOT NULL,
    CHECK (luas_hektar > 0),
    CHECK (latitude BETWEEN -90 AND 90),
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

CREATE TABLE titik_sensor (
    id_titik_sensor INT AUTO_INCREMENT PRIMARY KEY,
    nama_titik VARCHAR(100) NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    id_lahan INT NOT NULL,
    CHECK (latitude BETWEEN -90 AND 90),
    CHECK (longitude BETWEEN -180 AND 180),
    CONSTRAINT fk_titik_sensor_lahan
        FOREIGN KEY (id_lahan)
        REFERENCES lahan(id_lahan)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE sensor (
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    kode_sensor VARCHAR(50) NOT NULL UNIQUE,
    tanggal_pasang DATE NOT NULL,
    status VARCHAR(30) NOT NULL,
    id_titik_sensor INT NOT NULL,
    id_jenis_sensor INT NOT NULL,
    CONSTRAINT fk_sensor_titik
        FOREIGN KEY (id_titik_sensor)
        REFERENCES titik_sensor(id_titik_sensor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_sensor_jenis
        FOREIGN KEY (id_jenis_sensor)
        REFERENCES jenis_sensor(id_jenis_sensor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE pembacaan_sensor (
    id_pembacaan INT AUTO_INCREMENT PRIMARY KEY,
    waktu_baca DATETIME NOT NULL,
    nilai_angka DECIMAL(12,4) NULL,
    nilai_teks VARCHAR(100) NULL,
    id_sensor INT NOT NULL,
    CHECK (
        (nilai_angka IS NOT NULL AND nilai_teks IS NULL)
        OR
        (nilai_angka IS NULL AND nilai_teks IS NOT NULL)
    ),
    CONSTRAINT fk_pembacaan_sensor
        FOREIGN KEY (id_sensor)
        REFERENCES sensor(id_sensor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE panen (
    id_panen INT AUTO_INCREMENT PRIMARY KEY,
    tanggal_panen DATE NOT NULL,
    jumlah_kg DECIMAL(12,2) NOT NULL,
    id_lahan INT NOT NULL,
    id_komoditas INT NOT NULL,
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

CREATE TABLE harga_komoditas (
    id_harga INT AUTO_INCREMENT PRIMARY KEY,
    tanggal DATE NOT NULL,
    harga_per_kg DECIMAL(14,2) NOT NULL,
    id_komoditas INT NOT NULL,
    id_kabupaten INT NOT NULL,
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

CREATE TABLE estimasi_harga (
    id_estimasi INT AUTO_INCREMENT PRIMARY KEY,
    tanggal_estimasi DATE NOT NULL,
    harga_estimasi DECIMAL(14,2) NOT NULL,
    arah_perubahan VARCHAR(20) NOT NULL,
    id_komoditas INT NOT NULL,
    id_kabupaten INT NOT NULL,
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

CREATE TABLE prediksi_panen (
    id_prediksi INT AUTO_INCREMENT PRIMARY KEY,
    tanggal_prediksi DATE NOT NULL,
    estimasi_hasil_kg DECIMAL(12,2) NOT NULL,
    tingkat_risiko VARCHAR(30) NOT NULL,
    id_lahan INT NOT NULL,
    id_komoditas INT NOT NULL,
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

CREATE TABLE peringatan_dini (
    id_peringatan INT AUTO_INCREMENT PRIMARY KEY,
    waktu_peringatan DATETIME NOT NULL,
    pesan VARCHAR(255) NOT NULL,
    id_prediksi INT NOT NULL,
    CONSTRAINT fk_peringatan_prediksi
        FOREIGN KEY (id_prediksi)
        REFERENCES prediksi_panen(id_prediksi)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;
