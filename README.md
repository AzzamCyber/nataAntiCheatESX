# 🛡️ NATAKENSHI Anti Cheat for FiveM

<div align="center">

![Lua](https://img.shields.io/badge/Lua-000080?style=for-the-badge&logo=lua&logoColor=white)
![FiveM](https://img.shields.io/badge/FiveM-FF6600?style=for-the-badge&logo=serverfault&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Discord](https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white)

**Sistem Anti Cheat canggih untuk FiveM: Auto Ban, Deteksi Real-Time, dan Integrasi lengkap dengan Discord Notification.**

*Made with ❤️ by Natakenshi Developer (Azzam Codex)*

</div>

---

## ✨ Features

### 🚨 Cheat Protection
- **💣 Explosion Spam Detection:** Deteksi & auto-ban spam ledakan mencurigakan (RPG, fireworks, boat, plane, dsb).
- **🔫 Illegal Weapon Detection:** Blokir & ban senjata blacklisted (RPG, railgun, minigun).
- **🦸 Godmode & Invisible Player:** Deteksi player jadi kebal atau tidak terlihat.
- **🪧 Prop/Entity Spam:** Block prop/entity spam & kick otomatis.
- **🪙 Money/Job Injection:** Deteksi perubahan uang atau job by event abuse.
- **🎯 Aimbot & Rapid Fire:** Pendeteksian aksi auto/illegal shooting.
- **🎭 Emote Spam:** Blokir spam animasi & auto-ban.

### 🛡️ Ban & Admin Tools
- **⛔ Ban System:** Sistem ban player via database, detil alasan & ID, auto-expire control.
- **🔗 Discord Logging:** Semua ban & event abuse otomatis dikirim ke Discord webhook.
- **📝 Ban Info Message:** Player yang banned mendapat notifikasi lengkap reason & Discord server.
- **✅ Unban Command:** `/unbanatc steam:<id>` untuk admin unban player via chat/console.

### 🔧 Technical Highlights
- **🗄️ MySQL Integration:** Logging & aksi ban terhubung database server.
- **⚠️ Blocked Events:** Proteksi event trigger abuse (contoh: `esx:addMoney`, `giveWeapon`, dsb).
- **🔍 Real-Time Monitoring:** Tracker ledakan, emote, dan aktivitas cheat lain.

---

## 🚀 Quick Start

### Prerequisites
- **FiveM Server**
- **MySQL / MariaDB** + MySQL Async
- **Discord Webhook**

### Installation
1. Import tabel `bans` ke database server.
2. Edit `webhookURL` di script agar cocok dengan webhook Discord Anda.
3. Copy script ke folder resources server, daftarkan di `server.cfg`.
4. Jalankan server, fitur anti-cheat otomatis aktif.

---

## 📋 Usage

- Semua player terdeteksi cheat akan diban otomatis, log dikirim ke Discord.
- Admin/console dapat unban menggunakan:
/unbanatc steam:<steam_id>

text
Contoh: `/unbanatc steam:1100001122334455`

---

## 📝 Table Structure (bans)
Pastikan database memiliki tabel bans seperti berikut:
| Kolom     | Type      | Keterangan    |
|-----------|-----------|--------------|
| id        | int       | PRIMARY KEY  |
| name      | varchar   | Nama Player  |
| steam     | varchar   | Steam ID     |
| license   | varchar   | FiveM License|
| discord   | varchar   | Discord ID   |
| ip        | varchar   | Alamat IP    |
| reason    | text      | Alasan Ban   |
| bannedby  | varchar   | Pengban      |
| expire    | int/bool  | 0 = Permanent|
| bannedon  | int       | Timestamp    |

---

## 💡 Credits
Developed by **Natakenshi Developer**  
Open for contribution & feedback via Discord: [discord.gg/natakenshidevelopment](https://discord.gg/natakenshidevelopment)

## 📜 License
Bebas digunakan pribadi, dilarang diperjualbelikan tanpa izin developer asli.

---

Enjoy! 🚀
