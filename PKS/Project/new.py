import socket
import threading
import struct
import os
import time
import zlib

# Farby "\033[92m..\033[0m" - zeleny, "\033[34m..\033[0m" - modry,
# "\033[31m..\033[0m" - cerveny, "\033[33m..\033[0m" - zlty

SYN = 0x01        # Kód pre dáta
ACK = 0x02        # Kód pre potvrdenie
FIN = 0x03        # Kód na ukončenie spojenia
KEEPALIVE = 0x04  # Kód pre keep-alive

class P2PNode:
    def __init__(self, listen_ip, listen_port, target_ip, target_port):

        self.listen_ip = listen_ip     # IP adresa na počúvanie prichádzajúcich správ
        self.listen_port = listen_port # Port na počúvanie prichádzajúcich správ
        self.target_ip = target_ip     # IP adresa cieľového uzla na odosielanie správ
        self.target_port = target_port # Port cieľového uzla na odosielanie správ
        self.fragment_size = 512       # Počiatočná veľkosť fragmentu

        # Vytvorim soket UDP
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # Na počúvanie pripojte soket k zadanej IP a portu
        self.sock.bind((self.listen_ip, self.listen_port))

        self.running = True            # Príznak na ovládanie činnosti uzla
        self.missed_heartbeats = 0     # Počítadlo zmeškanych heartbeat
        self.keep_alive_interval = 5
        self.pripojenie = False

    # Spustenie uzla:
    def start(self):
        threading.Thread(target=self.listen, daemon=True).start()     # Stream na počúvanie prichádzajúcich správ
        threading.Thread(target=self.keep_alive, daemon=True).start() # Stream poslať keep-alive
        self.Send()
        

    # Počúvanie a spracovanie správ:
    def listen(self):
        while self.running:
            try:
                data, addr = self.sock.recvfrom(1024)  # Neustále počúva prichádzajúce správy
                self.handle_message(data, addr)
            except Exception as e:
                print(f"\033[31mChyba pri prijimani udajov: {e}\033[0m")
                self.running = False
                break                                  # Zastavenie uzla pri chybe

    # Podporuje pripojenie:
    def keep_alive(self):
        time.sleep(self.keep_alive_interval)
        while self.running:
            # Posielajte udržiavanie nažive každých 5 sekúnd
            print("ok")
            self.send_packet(KEEPALIVE, 0, b'')
            self.missed_heartbeats += 1
            if self.missed_heartbeats > 3:
                print("\033[31mSpojenie stratené! Uzol neodpovedá.\033[0m")
                self.running = False
            time.sleep(5)

    # Spracovanie prichádzajúcich správ:
    def handle_message(self, data, addr):
        if len(data) < 11:  # Kontrola minimálnej veľkosti správy
            print(f"\033[31mOd {addr} bola prijata neplatna sprava\033[0m")
            return

        # Analyzuje hlavičku správy
        message_type, seq_num, crc, payload_length = struct.unpack('!BHII', data[:11])
        payload = data[11:]  # Získanie užitočného zaťaženia

        # Kontrola integrity správy (CRC32)
        if zlib.crc32(payload) != crc:
            print(f"\033[31mPrijate poškodene udaje z {addr}\033[0m")
            return

        # Spracovaných typov správ
        if message_type == SYN:
            print(f"Prijata sprava od {addr}: \033[33m{payload.decode('utf-8')}\033[0m")
            self.send_packet(ACK, seq_num, b'')  # Odosielanie ACK

        elif message_type == ACK:
            print(f"Potvrdenie (ACK) prijate od {addr}")


        elif message_type == FIN:
            print(f"\033[36mPrijate dokoncenie pripojenia (FIN) od {addr}\033[0m")
            self.running = False  # Ukoncim spojenie

        elif message_type == KEEPALIVE:
            print("doslo")
            self.pripojenie = True
            self.missed_heartbeats = 0  # Vynulovanie počítadla zmeškaných signálov
            #print(f"Prijate keep-alive od {addr}")
            

    # Tvorba balíkov:
    def send_packet(self, message_type, seq_num, payload):
        crc = zlib.crc32(payload)  # Рассчитываем CRC
        # Univerzálna metóda na zostavovanie balíkov s hlavičkou a dátami
        header = struct.pack('!BHII', message_type, seq_num, crc, len(payload))
        packet = header + payload
        self.sock.sendto(packet, (self.target_ip, self.target_port))

    def Send(self):
        print("Nadväzuje sa spojenie.... Ctrl+C pre ukončenie programu")
        while self.pripojenie == False:
            time.sleep(self.keep_alive_interval)
            print(self.pripojenie)
            if self.pripojenie == True:
                break
        print("\033[92mSpojenie nadviazane!\033[0m")
        print("")
        print("\033[34mCo chces spravit?\033[0m")
        print("1. Odoslat spravu")
        print("2. Odoslat subor")
        print("3. Vymenit velkost fragmentu")
        print("4. Simulacia chyb")
        print("5. Ukoncit spojenie")
        prikaz = input("\033[34mChcem spravit \033[0m")
        while prikaz != '5':
            if prikaz == '1':
                message = input("Zadajte spravu: ")
                self.send_packet(SYN, 0, message.encode('utf-8'))
            elif prikaz == '2':
                print("Sprava")
            elif prikaz == '3':
                print("Sprava")
            elif prikaz == '4':
                print("Sprava")
            prikaz = input("\033[34mChcem spravit \033[0m")
        self.running = False
    
    # Zastavenie uzla:
    def stop(self):
        self.running = False
        self.sock.close()
        print("\033[36mSpojenie ukoncene.\033[0m")


# Hlavny program:
if __name__ == "__main__":
    listen_ip = '127.0.0.1' # IP adresa na počúvanie
    listen_port = 5000      # Port na počúvanie
    target_ip = '127.0.0.1' # IP adresa cieľového uzla
    target_port = 5001      # Port cieľového uzla

    node = P2PNode(listen_ip, listen_port, target_ip, target_port)
    try:
        node.start()
    except KeyboardInterrupt:
        node.stop()
