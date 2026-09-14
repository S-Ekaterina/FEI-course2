import socket
import threading
import struct

class P2PNode:
    def __init__(self, listen_ip, listen_port, target_ip, target_port):

        self.listen_ip = listen_ip     # IP adresa na počúvanie prichádzajúcich správ
        self.listen_port = listen_port # Port na počúvanie prichádzajúcich správ
        self.target_ip = target_ip     # IP adresa cieľového uzla na odosielanie správ
        self.target_port = target_port # Port cieľového uzla na odosielanie správ

        # Vytvorim soket UDP
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        
        # Na počúvanie pripojte soket k zadanej IP a portu
        self.sock.bind((self.listen_ip, self.listen_port))

        self.running = True  # Príznak na ovládanie činnosti uzla

    def start(self):
        # Vytvorim a spustim vlákno na počúvanie prichádzajúcich správ
        threading.Thread(target=self.listen, daemon=True).start()

        # Spustim cyklu odosielania správy
        self.send_messages()

    def listen(self):
        while self.running:
            try:
                # Od odosielateľa dostávame dáta (až 1024 bajtov)
                data, addr = self.sock.recvfrom(1024)
                self.handle_message(data, addr)  # Spracovanie prijatej správy
            except Exception as e:
                print(f"Chyba pri prijímaní údajov: {e}")
                self.running = False  # Zastavenie uzla pri chybe

# Spracovanie prichádzajúcich správ
    def handle_message(self, data, addr):
        if len(data) < 4:
            print(f"\n[Prijaté nesprávne údaje z {addr}]")
            return

        # Rozbalenie hlavičku správy
        protocol_id, message_type, payload_length = struct.unpack('!BBH', data[:4])
        payload = data[4:]  # Užitočné zaťaženie

        if protocol_id != 0x01:
            print(f"\n[Bol prijatý neznámy protokolový paket z {addr}]")
            return

        # Kontrola, či sa dĺžka užitočného zaťaženia zhoduje s dĺžkou v hlavičke
        if len(payload) != payload_length:
            print(f"\n[Nesprávna dĺžka údajov od {addr}]")
            return

        if message_type == 0x01:
            # Spracovanie textovej správy
            message = payload.decode('utf-8')
            print(f"\n[Správa prijatá od {addr}]: {message}")
            # Odosiela sa potvrdenie
            ack_packet = self.build_packet(0x02, b'ACK')
            self.sock.sendto(ack_packet, addr)
        elif message_type == 0x02:
            # Spracovanie potvrdenia
            print(f"\n[Prijaté potvrdenie od {addr}]")
        else:
            print(f"\n[Neznámy typ správy od {addr}]")

# Cyklus používateľských správ
    def send_messages(self):
        while self.running:
            message = input("Zadajte správu (alebo 'exit' pre ukončenie): ")
            if message.lower() == 'exit':
                self.running = False
                break
            # Preveďte správu na bajty a vytvorte paket
            payload = message.encode('utf-8')
            packet = self.build_packet(0x01, payload)
            self.sock.sendto(packet, (self.target_ip, self.target_port))
            print(f"[Správa bola odoslaná na adresu {self.target_ip}:{self.target_port}]")

# Vytvorenie paketu na odoslanie pomocou protokolu
    def build_packet(self, message_type, payload):
        protocol_id = 0x01  # ID protokolu
        payload_length = len(payload)
        # Zbaliť hlavičku
        header = struct.pack('!BBH', protocol_id, message_type, payload_length)
        return header + payload

# Zastavenie uzla
    def stop(self):
        self.running = False
        self.sock.close()  # Správne zatvorenie zásuvky

if __name__ == "__main__":
    listen_ip = '127.0.0.1'
    listen_port = 5001
    target_ip = '127.0.0.1'
    target_port = 5000

    # Vytvorim a spustim uzol P2P
    node = P2PNode(listen_ip, listen_port, target_ip, target_port)
    try:
        node.start()
    except KeyboardInterrupt:
        node.stop()
