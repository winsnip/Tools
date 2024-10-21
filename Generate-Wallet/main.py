from bip_utils import Bip39SeedGenerator, Bip44Coins, Bip44
from mnemonic import Mnemonic
from hdwallet import BIP44HDWallet
from hdwallet.cryptocurrencies import EthereumMainnet
from hdwallet.derivations import BIP44Derivation
import pandas as pd

def display_welcome_message():
    logo = r"""
██     ██ ██ ███    ██ ███████ ███    ██ ██ ██████  
██     ██ ██ ████   ██ ██      ████   ██ ██ ██   ██ 
██  █  ██ ██ ██ ██  ██ ███████ ██ ██  ██ ██ ██████  
██ ███ ██ ██ ██  ██ ██      ██ ██  ██ ██ ██ ██      
 ███ ███  ██ ██   ████ ███████ ██   ████ ██ ██      
"""
    print(logo)
    print("Wallet Generator")
    print("Join our Telegram channel: https://t.me/winsnip")

class Suiwallet:
    def __init__(self, mnemonic: str, password='') -> None:
        self.mnemonic: str = mnemonic.strip()
        self.password = password
        self.pk_prefix = 'suiprivkey'
        self.ed25519_schema = '00'

    def get_address_pk(self, pk_with_prefix=True):
        seed_bytes = Bip39SeedGenerator(self.mnemonic).Generate(self.password)
        bip44_mst_ctx = Bip44.FromSeed(seed_bytes, Bip44Coins.SUI).DeriveDefaultPath()
        address = bip44_mst_ctx.PublicKey().ToAddress()
        pk = bip44_mst_ctx.PrivateKey().Raw().ToHex()

        if pk_with_prefix:
            pk_bytes_with_schema = bytes.fromhex(f'{self.ed25519_schema}{pk}')
            pk = f'{self.pk_prefix}{pk_bytes_with_schema.hex()}'

        return address, pk

def generate_evm_wallet(mnemonic: str):
    bip44_hdwallet: BIP44HDWallet = BIP44HDWallet(cryptocurrency=EthereumMainnet)
    bip44_hdwallet.from_mnemonic(mnemonic=mnemonic, language="english", passphrase=None)
    bip44_hdwallet.clean_derivation()

    bip44_derivation: BIP44Derivation = BIP44Derivation(cryptocurrency=EthereumMainnet, account=0, change=False, address=0)
    bip44_hdwallet.from_path(path=bip44_derivation)
    address = bip44_hdwallet.address()
    private_key = bip44_hdwallet.private_key()

    return address, private_key

def generate_solana_wallet(mnemonic: str):
    seed_bytes = Bip39SeedGenerator(mnemonic).Generate()
    bip44_mst_ctx = Bip44.FromSeed(seed_bytes, Bip44Coins.SOLANA).DeriveDefaultPath()
    address = bip44_mst_ctx.PublicKey().ToAddress()
    private_key = bip44_mst_ctx.PrivateKey().Raw().ToHex()
    return address, private_key

def generate_aptos_wallet(mnemonic: str):
    seed_bytes = Bip39SeedGenerator(mnemonic).Generate()
    bip44_mst_ctx = Bip44.FromSeed(seed_bytes, Bip44Coins.APTOS).DeriveDefaultPath()
    address = bip44_mst_ctx.PublicKey().ToAddress()
    private_key = bip44_mst_ctx.PrivateKey().Raw().ToHex()
    return address, private_key

def generate_wallets():
    display_welcome_message()
    
    num_wallets = int(input("Berapa banyak wallet yang ingin dihasilkan? "))

    wallet_data = []

    for i in range(num_wallets):
        m = Mnemonic(language='english')
        mnemonic = m.generate()
        print(f'\nGenerated Mnemonic {i+1}: {mnemonic}\n')

        evm_address, evm_private_key = generate_evm_wallet(mnemonic)
        print(f'EVM Address: {evm_address}')
        print(f'EVM Private Key: {evm_private_key}\n')

        sui_wallet = Suiwallet(mnemonic)
        sui_address, sui_private_key = sui_wallet.get_address_pk()
        print(f'Sui Address: {sui_address}')
        print(f'Sui Private Key: {sui_private_key}\n')

        solana_address, solana_private_key = generate_solana_wallet(mnemonic)
        print(f'Solana Address: {solana_address}')
        print(f'Solana Private Key: {solana_private_key}\n')

        aptos_address, aptos_private_key = generate_aptos_wallet(mnemonic)
        print(f'Aptos Address: {aptos_address}')
        print(f'Aptos Private Key: {aptos_private_key}\n')

        wallet_data.append({
            'EVM Address': evm_address,
            'Sui Address': sui_address,
            'Solana Address': solana_address,
            'Aptos Address': aptos_address,
            'Private Key EVM': evm_private_key,
            'Private Key Sui': sui_private_key,
            'Private Key Solana': solana_private_key,
            'Private Key Aptos': aptos_private_key,
            'Mnemonic': mnemonic
        })

    df = pd.DataFrame(wallet_data)
    df.to_excel("wallets.xlsx", index=False)
    print("Wallet data saved to wallets.xlsx")


if __name__ == '__main__':
    generate_wallets()
