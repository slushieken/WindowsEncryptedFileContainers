# WindowsEncryptedFileContainers

_BitLocker encrypted filesystem containers providing encryption for data at rest combined with automatic boot time mounting._

## Introduction

Windows Encrypted File Containers creates, manages, and mounts at boot individual BitLocker encrypted VHD or VHDX file containers, providing Confidentiality of data at rest.

These containers can then be copied/moved and mounted anywhere (locally on a file server, on a USB storage device plugged in to a laptop, or from a network file share) while maintaining both access and security (compliance) for the data contained within.

These mounted containers can further be unlocked, shared, and permissioned via Windows file sharing. And finally, using the scripts, can be set to automatically mount at boot (useful for a file server sharing them).

This gives isolation of confidential data from the storage media it is resting on (removing requirements for secure file shredding/wiping), as well isolating data in one container from another (avoidance of commingling).

## BitLocker provides decryption options using:
- Password with a Recovery Key
- Trusted Platform Module (TPM) (locking it to a device)
- Network Unlock

An NTFS file system is a required to mount containers automatically at boot. It would be possible however to manually mount containers in any way you need, on any OS that supports VHD mounting and BitLocker decryption.
