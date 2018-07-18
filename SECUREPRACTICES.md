SECURITY DO'S and DON'TS
===

When using this tool maintaining good security hygiene is a requirement. After all, any secure implementation is only as strong as the weakest link.

Since not everyone has the time to become security experts, I have included a small section to help you avoid some common security issues.

## Do Not:
- ### Mix the passwords or recovery keys within the data they are securing.
  Passwords must always be separated from the secure data and always handled out-of-band. It also goes without saying if the only place you have stored your keys is inside the container, once the container is locked your keys (and the data) are lost forever.

- ### Store the passwords or recovery keys on the same media as the secure data.
    If the key is in clear text sitting on the same media as the encrypted container, it is trivial to mount the media on another system, and further unlock the container using the provided keys sitting next to it.

- ### Use TPM unless you know what your doing.
    TPM ties your decryption to one device. That's very convenient right up until you can no longer boot your device, your device is lost, or it is destroyed. Make sure you understand the tradeoffs with TPM before using it.

## Do
- ### Re-key with a new password any passwords or recovery keys that have become compromised (exposed).
    If you find you have unintentionally shared your passwords/keys, you need to re-encrypt with new ones immediately.

- ### Re-key with a new password at some frequency.
    As time goes by, your risk of accidental and unknown exposure of security keys and passwords goes up. Therefore re-passwording your resources at some frequency where feasible should be part of your strategy.

- ### Remember to back up and provide redundancies.
    Encrypted data is particularly sensitive to data corruption since you can't recover encrypted data in part. A corrupted disk sector without disk redundant backing (ie RAID) can be fatal. So always provide redundancies such as RAID or near-time duplication of data if you cannot lose it.
    
    Also remember to use backups in case of catastrophic data loss or just to recover from a mistaken file deletion. Remember that encrypted data is nearly impossible to recover if damaged or deleted.