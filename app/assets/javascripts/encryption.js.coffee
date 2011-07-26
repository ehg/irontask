#= require pidcrypt/aes_cbc
window.encrypt = (plaintext, key) ->
		aes = new pidCrypt.AES.CBC()
		aes.encryptText plaintext, key, {nBits: 256}

window.decrypt = (ciphertext, key) ->
		aes = new pidCrypt.AES.CBC()
		aes.decryptText ciphertext, key, {nBits: 256}
