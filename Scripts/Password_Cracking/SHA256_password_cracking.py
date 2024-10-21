from pwn import *
import sys

if len(sys.argv) != 2:
    print("invalid arguments!")
    print(">> {} <sha256sum>".format(sys.argv[0]))
    exit(1)
wanted_hash = sys.argv[1]
password_file= "rockyou.txt"
attempts=1

with log.progress("Attempting to back: {}!\n".format(wanted_hash)) as p:
    with open(password_file,"r",encoding='latin-1') as password_list:
        for password in password_list:
            password = password.strip("\n").encode("latin-1")
            password_hash = sha256sumhex(password)
            p.status("[{}] {} == {}".format(attempts, password.decode('latin-1'), password_hash))
            if wanted_hash  == password_hash:
                p.success("Password hash found after {} attempts! Passowrd  {} hashes to {}!".format(attempts,password.decode("latin1"), password_hash))
                exit()
            attempts += 1
        p.failure("Password Hash not found: ")
