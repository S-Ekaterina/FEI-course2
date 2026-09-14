import socket
import threading
import struct
import os
import time
import zlib
import math
import random

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

        self.running = True                   # Príznak na ovládanie činnosti uzla
        self.ack_received = threading.Event() # Udalosť na synchronizáciu na čakanie na potvrdenia (ACK)

        self.keep_alive_interval = 5      # Interval medzi odosielaním udržiavacích správ
        self.keep_alive_timeout = 15      # Čakacia doba, kým bude spojenie vyhlásené za stratené
        self.last_heartbeat = time.time() # Čas posledného prijatého udržiavania

        self.received_fragments = set()   # Ukladá počty prijatých fragmentov
        self.expected_fragments = None    # Počet očakávaných fragmentov
        self.start_time = None            # Čas začiatku prenosu

        self.missed_heartbeats = 0        # Počítadlo zmeškanych heartbeat
        self.max_missed_heartbeats = 3    # Maximálne vynechanych heartbeat
        self.retransmit_fragments = set() # Veľa chýbajúcich fragmentov
        self.start_time = time.time()
        self.name_file = 'received_file'
        self.simulate_errors = False
        

    # Spustenie uzla:
    def start(self):
        threading.Thread(target=self.listen, daemon=True).start()     # Stream na počúvanie prichádzajúcich správ
        threading.Thread(target=self.keep_alive, daemon=True).start() # Stream poslať keep-alive
        self.send()                                          # Hlavný cyklus odosielania správy

    # Počúvanie a spracovanie správ:
    def listen(self):
        while self.running:
            try:
                data, addr = self.sock.recvfrom(1024)     # Neustále počúva prichádzajúce správy
                self.handle_message(data, addr)           # Prijíma dáta zo zásuvky
            except Exception as e:
                print(f"\033[31mChyba pri prijimani udajov: {e}\033[0m")
                #self.running = False   
                continue                   # Zastavenie uzla pri chybe

    # Spracovanie prichádzajúcich správ:
    def handle_message(self, data, addr):
        #data = self.simulate_error(data)
        if data is None:
            return

        Poskodene = False
        if len(data) < 11:
            print(f"\033[31m[Prijate nespravne udaje z {addr}]\033[0m")
            return

        # Analyzuje hlavičku správy
        message_type, seq_num, crc, payload_length = struct.unpack('!BHII', data[:11])
        payload = data[11:]

        # Integrita údajov sa kontroluje pomocou CRC32
        computed_crc = zlib.crc32(payload)
        if computed_crc != crc: # Ak sú dáta poškodené, odošle sa NACK
            print(f"[Poskodene udaje z {addr}, vyzadujuce opatovny prenos]")
            Poskodene = True
            nack_packet = self.build_packet(KEEPALIVE, seq_num, b'')
            self.sock.sendto(nack_packet, addr)
            return

        # Spracovaných typov správ
        if message_type == SYN:    # Po prijatí údajov sa odošle potvrdenie (ACK)
            try:
                decoded_message = payload.decode('utf-8')
            except UnicodeDecodeError:
                print("[Binarny obsah, nedokazem dekodovat]")
                ack_packet = self.build_packet(ACK, seq_num, b'')
                self.sock.sendto(ack_packet, addr)
                return

            cislo1 = int(decoded_message[0]) + 2
            cislo2 = int(decoded_message[1]) + cislo1
            strt = decoded_message[2:cislo1]
            end = decoded_message[cislo1:cislo2]
            mess = decoded_message[cislo2:]
            #print(strt, end)

            if strt == '1' and end != '1':
                self.start_time = time.time()

            if Poskodene == False:
                print(f"[Prijaty fragment {strt}/{end} z {addr}]: \033[33m{mess}\033[0m :ok")
            else:
                print(f"[Prijaty fragment {strt}/{end} z {addr}]: \033[33m{mess}\033[0m :poskodeny")

            with open("received_file", "ab") as f:
                f.write(payload)
            if seq_num not in self.received_fragments:
                self.received_fragments.add(seq_num)
            ack_packet = self.build_packet(ACK, seq_num, b'')
            self.sock.sendto(ack_packet, addr)

            if seq_num in self.retransmit_fragments:
                self.retransmit_fragments.remove(seq_num)
            if strt == end and strt != '1':
                print(f"[Subor ulozeny: {os.path.abspath(self.name_file)}, Velkost: {os.path.getsize(self.name_file)} bajtov]")
                print(f"[Prenos dokonceny za {time.time() - self.start_time:.2f} sekund]")

        elif message_type == ACK:  # Pri prijatí ACK sa čakanie na potvrdenie vynuluje
            print(f"[Prijate ACK pre {seq_num} od {addr}]")
            self.ack_received.set()

        elif message_type == FIN:  # Aktualizuje sa čas posledného udržiavania
            self.missed_heartbeats = 0
            # print(f"[Keep-Alive prijate od {addr}]")

        elif message_type == KEEPALIVE:  # Keď sa prijme NACK, odošle sa znova
            print(f"[Prijate NACK pre {seq_num}, opakovany prenos]")
            if seq_num not in self.retransmit_fragments:
                self.retransmit_fragments.add(seq_num)

    # Odosielanie správ:
    def send(self):
        # print("Zadajte spravu alebo 'file:<path>' ('size:<?>' na zmenu velkosti, 'exit' na ukoncenie): ")
        print("\033[34mCo chces spravit?\033[0m")
        print("1. Odoslat spravu")
        print("2. Odoslat subor")
        print("3. Vymenit velkost fragmentu")
        print("4. Zacat/skoncit simulaciu chyb")
        print("5. Nastavit miesto, kam sa subor ulozi po prijati")
        print("6. Ukoncit spojenie")
        seq_num = 0
        while self.running:
            message = input("\033[34mChcem spravit \033[0m")
            if message == '1':                           # V opačnom prípade sa text odošle
                message = input("\033[34mNapiste spravu: \033[0m")
                self.send_message(seq_num, message)
                seq_num += 1

            elif message == '2': # Ak je to súbor, odošle sa jeho obsah
                file_path = input("\033[34mSubor: \033[0m")
                if os.path.isfile(file_path):
                    self.send_file(file_path, seq_num)
                else:
                    print("[Subor sa nenasiel]")

            elif message == '3':
                try:
                    new_size = int(input(f"\033[34mVelkost fragmentu je {self.fragment_size}. Zadaj novu: \033[0m"))
                    if new_size > 0 and new_size <= 1024:
                        self.fragment_size = new_size
                        print(f"[Velkost fragmentu je nastavena na {self.fragment_size} bajtov]")
                    else:
                        print("\033[31m[Neplatna velkost fragmentu]\033[0m")
                except ValueError:
                    print("\033[31m[Chyba: Zadajte platne cislo]\033[0m")
                continue

            elif message == '4':
                self.simulate_errors = not self.simulate_errors
                if self.simulate_errors:
                    print(f"\033[34m[Prebehne simulacia chyb – stratenych alebo nespravnych fragmentov]\033[0m")
                else:
                    print(f"\033[34m[Simulacia chyb skoncena]\033[0m")

            elif message == '5':
                self.name_file = input("Subor ulozi po prijati v: ")

            elif message == '6':
                self.stop()

    # Odoslanie časti údajov:
    def send_fragment(self, message_type, seq_num, payload):
        crc = zlib.crc32(payload)
        # Vygeneruje sa hlavička a kompletný balík
        header = struct.pack('!BHII', message_type, seq_num, crc, len(payload))
        packet = header + payload
        # Balík je odoslaný
        if self.simulate_errors:
            error_type = random.choice(['none', 'corrupt', 'lost'])
            if error_type == 'corrupt':
                corrupted_payload = bytearray(payload)
                #print(corrupted_payload)
                if len(corrupted_payload) > 0:
                    random_index = random.randint(0, len(corrupted_payload) - 1)
                    corrupted_payload[random_index] = random.randint(0, 255)
                corrupted_packet = header + bytes(corrupted_payload)
                self.sock.sendto(corrupted_packet, (self.target_ip, self.target_port))
            elif error_type == 'none':
                self.sock.sendto(packet, (self.target_ip, self.target_port))
        else:
            self.sock.sendto(packet, (self.target_ip, self.target_port))
        
        # Čaká sa na ACK
        if message_type == SYN:
            self.ack_received.clear()
            # Ak nie je prijaté žiadne ACK, fragment sa odošle znova
            for attempt in range(5):
                if self.ack_received.wait(timeout=5):
                    return # ok
                print(f"[Opakovany prenos fragmentu {seq_num}, pokus {attempt + 1}]")
                self.sock.sendto(packet, (self.target_ip, self.target_port))
            print(f"[Neuspesna prenos fragmentu {seq_num}]")
            self.retransmit_fragments.add(seq_num)

    def send_message(self, seq_num, payload):
        size = len(payload)
        print(f"[Prenos spravy: {payload}]")
        print(f"[Velkost spravy: {size} bajtov, Velkost fragmentu: {self.fragment_size} bajtov]")
        if size <= self.fragment_size:
            payload = '1111' + payload
            sprava = payload.encode('utf-8')
            self.send_fragment(SYN, seq_num, sprava.upper())
            return
        else:
            self.start_time = time.time()
            self.expected_fragments = set()
            casti = math.ceil(size / self.fragment_size)
            print(f"Odosielanie spravy po castiach [{casti}]:")
            cast = 1
            for i in range(0, len(payload), self.fragment_size):
                chunk = payload[i:i + self.fragment_size]
                print(f"[Prenos {cast}/{casti} casti, Velkost: {len(chunk)} bajtov]")
                self.ack_received.clear()  # Resetovať blok čakania ACK
                cislo1 = len(str(cast))
                cislo2 = len(str(casti))
                #print(cislo1, cislo2, cast, casti)
                chunk = str(cislo1) + str(cislo2) + str(cast) + str(casti) + chunk
                sprava = chunk.encode('utf-8')
                self.send_fragment(SYN, seq_num, sprava.upper())
                self.expected_fragments.add(seq_num)

                # Čakáme na potvrdenie aktuálneho fragmentu
                if not self.ack_received.wait(timeout=5):  # Potvrdenie očakávame do 5 sekúnd
                    print(f"[Neuspesna prenos fragmentu {seq_num}, opakovany prenos]")
                    # Znova odoslať, ak nie je potvrdenie
                    for attempt in range(5):
                        self.send_fragment(SYN, seq_num, chunk)
                        if self.ack_received.wait(timeout=5):  # Opäť čakáme na potvrdenie
                            break
                        print(f"[Opakovany prenos fragmentu {seq_num}, pokus {attempt + 1}]")
                    else:
                        print(f"\033[31m[Fragment {seq_num} sa nepodarilo preniest]\033[0m")
                        return
                seq_num += 1
                cast += 1
        print("\033[92m[Prenos spravy je dokonceny]\033[0m")


    # Odošle súbor po častiach:
    def send_file(self, file_path, start_seq_num):
        #self.expected_fragments = set()
        size = os.path.getsize(file_path)
        print(f"[Prenos suboru: {os.path.basename(file_path)}]")
        print(f"[Velkost suboru: {size} bajtov, Velkost fragmentu: {self.fragment_size} bajtov]")
        
        if size <= self.fragment_size:  # Ak sa súbor zmestí do jedného fragmentu
            with open(file_path, 'rb') as file:
                chunk = file.read()  # Čítanie celého súboru
                chunk = '1111'.encode() + chunk
                self.send_fragment(SYN, start_seq_num, chunk)  # Odoslať ako jednu správu
            print("\033[92m[Prenos suboru je dokonceny]\033[0m")
            return
        
        else:  # Ak je súbor väčší, rozdeľte ho na časti
            self.expected_fragments = set()
            self.start_time = time.time()
            seq_num = start_seq_num
            casti = math.ceil(size / self.fragment_size)
            print(f"Odosielanie suboru po castiach [{casti}]:")
            cast = 1

            with open(file_path, 'rb') as file:
                while chunk := file.read(self.fragment_size):  # Rozdelenie súboru na časti
                    print(f"[Prenos {cast}/{casti} casti, Velkost: {len(chunk)} bajtov]")
                    self.ack_received.clear()  # Resetovať blok čakania ACK
                    cislo1 = len(str(cast))
                    cislo2 = len(str(casti))
                    #print(cislo1, cislo2, cast, casti)
                    chunk = str(cislo1).encode() + str(cislo2).encode() + str(cast).encode() + str(casti).encode() + chunk
                    self.send_fragment(SYN, seq_num, chunk)
                    self.expected_fragments.add(seq_num)

                    # Čakáme na potvrdenie aktuálneho fragmentu
                    if not self.ack_received.wait(timeout=5):  # Potvrdenie očakávame do 5 sekúnd
                        print(f"[Neuspesna prenos fragmentu {seq_num}, opakovany prenos]")
                        # Znova odoslať, ak nie je potvrdenie
                        for attempt in range(5):
                            self.send_fragment(SYN, seq_num, chunk)
                            if self.ack_received.wait(timeout=5):  # Opäť čakáme na potvrdenie
                                break
                            print(f"[Opakovany prenos fragmentu {seq_num}, pokus {attempt + 1}]")
                        else:
                            print(f"\033[31m[Fragment {seq_num} sa nepodarilo preniest]\033[0m")
                            return
                    seq_num += 1
                    cast += 1

            #missing_fragments = self.expected_fragments - self.received_fragments
            #if missing_fragments:
            #    print(f"[Opatovny prenos {len(missing_fragments)} fragmentov]")
            #   for seq_num in sorted(missing_fragments):
            #       self.resend_fragment(seq_num, file_path)

        print("\033[92m[Prenos suboru je dokonceny]\033[0m")

    # Podporuje pripojenie:
    def keep_alive(self):
        while self.running:
            time.sleep(self.keep_alive_interval)
            self.send_fragment(FIN, 0, b'') # Keep-alive sa posiela pravidelne
            self.missed_heartbeats += 1
            # Ak nepríde žiadna odpoveď príliš dlho, spojenie sa považuje za stratené
            if self.missed_heartbeats >= self.max_missed_heartbeats:
                print("[Spojenie sa stratilo. Pokus o obnovenie...]")
                for _ in range(self.max_missed_heartbeats):
                    self.send_fragment(FIN, 0, b'')  # Posielanie heartbeat
                    time.sleep(self.keep_alive_interval)
                    if self.missed_heartbeats == 0:
                        print("[Spojenie obnovene]")

                        for seq_num in sorted(self.retransmit_fragments):
                            print(f"[Opatovny prenos fragmentu {seq_num}]")
                            self.resend_fragment(seq_num)
                        self.retransmit_fragments.clear()
                        break
                else:
                    print("\033[31m[Nepodarilo sa obnovit spojenie]\033[0m")
                    self.running = False
                    return

    # Opätovné odosielanie chýbajúcich fragmentov
    def resend_fragment(self, seq_num, file_path):
        with open(file_path, "rb") as f:
            f.seek(seq_num * self.fragment_size)
            chunk = f.read(self.fragment_size)
            self.send_fragment(SYN, seq_num, chunk)

    # Tvorba balíkov:
    def build_packet(self, message_type, seq_num, payload):
        crc = zlib.crc32(payload)
        header = struct.pack('!BHII', message_type, seq_num, crc, len(payload))
        # Univerzálna metóda na zostavovanie balíkov s hlavičkou a dátami

        return header + payload
    
    '''# Simulovať chyby
    def simulate_error(self, packet):
        if self.simulate_errors:
            # 50% pravdepodobnosť pre každý balík
            error_type = random.choice(['none', 'corrupt', 'lost'])
            if error_type == 'corrupt':
                # Poškodíme dáta (napríklad zmeníme 1 bajt v pakete)
                corrupted_packet = bytearray(packet)
                corrupted_packet[random.randint(0, len(corrupted_packet)-1)] = random.randint(0, 255)
                print(f"\033[31m[Chyba: poškodený balík]\033[0m")
                return bytes(corrupted_packet)
            elif error_type == 'lost':
                # Strata paketov (údaje jednoducho nevraciame)
                print(f"\033[31m[Chyba: Strata paketov]\033[0m")
                return None
        return packet'''

    # Zastavenie uzla:
    def stop(self):
        self.running = False # Príznak na ovládanie činnosti uzla
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
