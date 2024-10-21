# SuiWallet Generator

SuiWallet Generator adalah aplikasi Python yang digunakan untuk menghasilkan wallet untuk berbagai blockchain, termasuk Ethereum (EVM), Sui, Solana, dan Aptos. Aplikasi ini menggunakan BIP39 dan BIP44 untuk menghasilkan alamat dan kunci privat.

## Fitur

- Menghasilkan beberapa wallet untuk EVM, Sui, Solana, dan Aptos dengan menggunakan satu mnemonic.
- Mengekspor data wallet ke dalam format Excel atau CSV.
- Menyimpan alamat, kunci privat, dan mnemonic dalam file teks.

## Struktur Data

Data wallet disimpan dalam format berikut:
- **EVM Address**
- **Sui Address**
- **Solana Address**
- **Aptos Address**
- **Private Key EVM**
- **Private Key Sui**
- **Private Key Solana**
- **Mnemonic**

## Prerequisites

Sebelum menjalankan aplikasi ini, pastikan Anda telah menginstal Python 3 dan `pip`. Anda juga perlu menginstal beberapa pustaka yang diperlukan. 

## Instalasi

1. Clone atau unduh repositori ini.
```bash
git clone https://github.com/winsnip/Tools/tree/main/Generate-Wallet.git
cd Generate-Wallet
```
2. Instal pustaka yang diperlukan dengan menggunakan `requirements.txt`.
```bash
pip install -r requirements.txt
```
3. Run.
```bash
python main.py
```

4. Linux
```bash
apt install -y python3.10-venv && rm -rf ~/wallet-generator && rm -rf Tools && git clone --no-checkout https://github.com/winsnip/Tools.git && cd Tools && git config core.sparseCheckout true && echo "Generate-Wallet/" >> .git/info/sparse-checkout && git checkout main && cd .. && rm -rf /root/Generate-Wallet && mv Tools/Generate-Wallet ~ && rm -rf Tools && cd ~/Generate-Wallet && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt && python3 main.py && deactivate
```
## Lisensi

MIT License. Silakan lihat file `LICENSE` untuk detail lebih lanjut.

## Kontribusi

Kontribusi sangat diterima! Jika Anda memiliki saran atau perbaikan, silakan buka issue atau buat pull request.

## Kontak

Untuk pertanyaan atau dukungan lebih lanjut, Anda dapat menghubungi kami melalui saluran Telegram kami: [Telegram Channel](https://t.me/winsnip).
