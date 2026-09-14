import socket
import threading
import time
import struct
import errno
import zlib
import os
import os.path
import random
from enum import IntEnum
from math import ceil

host_ip = None
default_host_port = 49132
choice = None
stat = False

class ConnectionState(IntEnum): # Stavy programu
    NEW = 1,
    CONNECTED = 2,
    TRANSFER = 3,
    XCHG_RECIEVED = 4,
    DIS_RECIEVED = 5,
    CLOSED = 6

class ConnectionRequestType(IntEnum): # Typy poziadaviek od pouzivatela
    connect = 1,
    send = 2,
    close = 3,
    exchange = 4,
    disconnect = 5

class FragmentType(IntEnum): # Typy fragmentov
    CON = 0,
    CON_ACK = 1,
    DATA = 2,
    ACK = 3,
    TEST = 4,
    TEST_ACK = 5
    XCHG = 6,
    XCHG_ACK = 7,
    DIS = 8,
    DIS_ACK = 9

class ThreadOptions: # Sluzobny typ pre thready

    def __init__(self):
        self.must_be_stopped = False # Priznak ukoncenia threadu
        self.thread_ended = None # Navratova hodnota

class ConnectionRequest: # Trieda poziadaviek od pouzivatela

    def __init__(self, _type, data = None):
        self.type = _type
        self.data = data

class Connection: # Trieda spojenia alebo otvoreneho socketu

    def getInfoText(self, text, start_with = '\n'): # Formatovane printovane s hlavickou socketu
        return start_with + '[' + ('Client' if not self.isServer else 'Server') + ' on ' + str(self.socket.getsockname()[1]) + ']: ' \
            + text + '\n---: '

    def __init__(self, host_port, dest_ip = None, dest_port = None, isServer = False):
        global host_ip
        global default_host_port
        self.host_port = host_port # Port, na ktorom pocuva socket
        self.dest_ip = dest_ip # Adresa ineho ucastnika komunikacie
        self.dest_port = dest_port # Port ineho ucastnika komunikacie
        self.isServer = isServer # Priznak toho, ci je socket serverovy
        self.state = ConnectionState.NEW # Stav spojenia
        self.request_queue = [] # Rad poziadaviek od pouzivatela
        self.keep_alive_thread = None # Objekt keep alive threadu
        self.keep_alive_options = None # Objekt nastaveni pre keep alive thread
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        while True:
            try:
                self.socket.bind((host_ip, self.host_port)) # Pokus o nastavenie portu
                break
            except socket.error as e:
                host_port = default_host_port # Port je obsadeny, pokus o nastavenie default portu
                default_host_port += 1
        print(self.getInfoText('Opened socket on port ' + str(self.socket.getsockname()[1])), end = '')
        t = threading.Thread(target = client if not isServer else server, args = [self])
        t.start() # Spustenie programu klienta alebo servera

    def popFirstRequest(self): # Vytiahnutie prvej poziadavky
        request = self.request_queue[0]
        self.request_queue = self.request_queue[1:]
        return request

    def disconnected(self): # Metoda stornovania atributov pri odpojeni
        print(self.getInfoText('Disconnected from '+ ('server ' if not self.isServer else 'client ') + self.dest_ip + ':' + str(self.dest_port)), end = '')
        self.socket.settimeout(None) 
        self.state = ConnectionState.NEW
        self.dest_ip = None
        self.dest_port = None

    def keep_alive_thread_start(self): # Startuje keep alive thread
        self.keep_alive_options = ThreadOptions()        
        self.keep_alive_thread = threading.Thread(target = keep_alive, args = [self])
        self.keep_alive_thread.start()
 
    def keep_alive_thread_stop(self): # Dava priznak ukoncenia keep alive threadu a caka na jeho zastavenie
        self.keep_alive_options.must_be_stopped = True
        self.keep_alive_thread.join()
        self.keep_alive_thread = None
        self.keep_alive_options = None
    
def keep_alive(connection): # Metoda keep-alive
    if connection.isServer:
            connection.socket.settimeout(50.0) # Nastavime casovac pri roli serveru

    # Pokial hlavny thread nedal prikazu zastavenia
    while not connection.keep_alive_options.must_be_stopped: 

        if not connection.isServer: # V rezime klienta
            test_fragment = struct.pack('B', FragmentType.TEST)
            data = send(connection, test_fragment, [FragmentType.TEST_ACK, FragmentType.XCHG, FragmentType.DIS], 15.0, 3) # Odoslanie TEST fragmentu
            
            if data is not None: # Bola dostana odpoved
                fragment_type = struct.unpack('B', data[:1])[0]
                if fragment_type == FragmentType.TEST_ACK: # Potvrdenie spojenia
                    if stat: print(connection.getInfoText('Keep-alive message. Server is active'), end = '')
                    time.sleep(5) # Cakame 5s pred opakovanim poslania TEST
                elif (fragment_type == FragmentType.XCHG) or (fragment_type == FragmentType.DIS):
                    connection.keep_alive_options.thread_ended = data
                    # V pripade dostania sprav XCHG a DIS od serveru
                    return
            else: # Nebola dostana odpoved
                print(connection.getInfoText('Connection with server ' + connection.dest_ip + ':' + str(connection.dest_port) + ' was failed. Server does not response.'), end = '')
                connection.disconnected() # Odpojenie
                return
        else: # V rezime servera
            try:
                data = connection.socket.recv(1500)
            except socket.timeout as e: # V pripade, ze server nedostava ziadnu spravu 50s
                print(connection.getInfoText('Client stopped sending keep-alive signals, disconnecting from client'), end = '')
                connection.disconnected() # Odpojenie
                return
            fragment_type = struct.unpack('B', data[:1])[0]
            if fragment_type == FragmentType.TEST:
                if stat: print(connection.getInfoText('Keep-alive message. Connection with client is active'), end = '')
                test_ack = struct.pack('B', FragmentType.TEST_ACK)
                try:
                    # Odpoved na TEST
                    connection.socket.sendto(test_ack, (connection.dest_ip, connection.dest_port))
                except OSError as os_err: # Nie je mozne odoslat odpoved, spojenie prerusene
                    connection.disconnected() # Odpojenie
                    return
            else: # Dostane ine data ako TEST, ukoncenie vlakna
                connection.keep_alive_options.thread_ended = data
                break
    if connection.isServer: # Odstranime timeout
        connection.socket.settimeout(None)

# Fragmentuje a posiela serveru subor alebo text
def fragment_and_transfer(connection, is_file_transfer, payload, fragment_size):
    fragments_count = 0
    fragment = None
    symbols_count = 0
    source = None
    if is_file_transfer: # Ak posielame subor
        while payload[len(payload) - 1] == os.path.sep:
            payload, _ = os.path.split(payload) # Odstranime separator na konci cesty k suboru
        source = open(payload, 'rb') # Otvorime subor na citanie bajtov
        file_size = os.path.getsize(payload) # Zistime rozmer subora
        fragments_count = ceil(file_size / fragment_size) # Zistime pocet fragmentov
        print(connection.getInfoText('A file ' + payload + ' will be sended to ' + connection.dest_ip + ':' + str(connection.dest_port) + '\nSize of file: ' + str(file_size) + ' bytes\nCount of fragments: ' + str(fragments_count + 1)), end = '')
        payload = os.path.basename(payload) # Zistime nazov subora
        symbols_count = len(payload) # Pocet symbolov v nazve subora
        # Formovanie fragmentu
        fragment = struct.pack('!BIIB', FragmentType.DATA, 0, fragments_count, symbols_count)
        fragment += payload.encode('utf-8') # Pridame nazov suboru
        fragment += struct.pack('!I', zlib.crc32(fragment)) # Kontrolna suma
    else: # Posielame text
        fragments_count = ceil(len(payload)/ fragment_size) # Zistime pocet fragmentov
        print(connection.getInfoText('A message will be sended to ' + connection.dest_ip + ':' + str(connection.dest_port) + '\nSize of message: ' + str(len(payload)) + ' bytes\nCount of fragments: ' + str(fragments_count + 1)), end = '')
        source = payload.encode('utf-8') # Kodujeme text do bajtov
        payload = None
        # Formovanie fragmentu
        fragment = struct.pack('!BIIB', FragmentType.DATA, 0, fragments_count, 0) 
        fragment += struct.pack('!I', zlib.crc32(fragment))

    curr_fragment = 0
    bytes_sended = 0
    error_fragment = random.randint(1, fragments_count)
    while curr_fragment <= fragments_count: # Pokial neodosleme vsetky fragmenty
        if curr_fragment != 0: # Ak neinicializacny fragment
            if is_file_transfer:
                payload = source.read(fragment_size) # Nacitavanie fragmenta subora
            else: # Nacitavanie fragmenta textu
                region_start = (curr_fragment - 1) * fragment_size 
                payload = source[region_start : region_start + fragment_size]
            # Formovanie fragmentu 
            fragment = struct.pack('!BI', FragmentType.DATA, curr_fragment)
            fragment += payload 
            fragment += struct.pack('!I', zlib.crc32(fragment))
            bytes_sended += len(payload)
        if curr_fragment == error_fragment: # Simulacia chyby
            error_fragment = fragment + struct.pack('!I', 4294967295) # ff ff ff ff na koniec
            response = send(connection, error_fragment, [FragmentType.ACK], 15.0, 1, curr_fragment)
        response = send(connection, fragment, [FragmentType.ACK], 15.0, 3, curr_fragment) # Poslanie
        if response is None: # Neprisla odpoved po troch pokusoch
            return (False, curr_fragment, bytes_sended)
        curr_fragment += 1
    return (True, curr_fragment, bytes_sended)

def client(connection): # Rezim klienta

    connection.keep_alive_thread = None
    connection.keep_alive_options = None
    is_file_transfer = None
    payload = None
    fragment_size = None
    
    while True:

        if connection.state == ConnectionState.CLOSED: # Ak socket je zatvoreny, ukoncime sa
            return

        if connection.state != ConnectionState.TRANSFER: # Nie transfer, pocuvame vstup od pouzivatela

            if connection.state == ConnectionState.CONNECTED: # Ak je spojeny, teda aj keep-alive

                if connection.keep_alive_thread is None: # Keep-alive vlakno nie je vytvorene
                    connection.keep_alive_thread_start()
                elif connection.keep_alive_options.thread_ended is not None:
                    # Keep-alive sa ukoncil a ma navratovu hodnotu
                    fragment_type = struct.unpack('B', connection.keep_alive_options.thread_ended[:1])[0]
                    if fragment_type == FragmentType.XCHG: # Server poslal XCHG
                        connection.state = ConnectionState.XCHG_RECIEVED
                        send_response(connection, FragmentType.XCHG_ACK) 
                    elif fragment_type == FragmentType.DIS: # Server poslal DIS
                        connection.state = ConnectionState.DIS_RECIEVED
                        connection.socket.settimeout(50.0)
                        send_response(connection, FragmentType.DIS_ACK)
                    connection.keep_alive_thread = None
                    connection.keep_alive_options = None
                    continue            
            
            elif connection.state == ConnectionState.XCHG_RECIEVED: # Dostal ziadost o vymene roli
                response = connection.socket.recv(1500) # Pocuvame na spravy
                fragment_type = struct.unpack('!B', response[0 : 1])[0]
                if fragment_type == FragmentType.XCHG: # Znovu posleme XCHG_ACK
                    send_response(connection, FragmentType.XCHG_ACK)
                elif fragment_type == FragmentType.TEST: 
                    # Server sa stal klientom a kontroluje spojenie
                    connection.state = ConnectionState.CONNECTED
                    connection.isServer = True
                    print(connection.getInfoText('Switching to server'), end = '')
                    t = threading.Thread(target = server, args = [connection])
                    t.start() # Zmena roli na server
                    return
                continue
            elif connection.state == ConnectionState.DIS_RECIEVED: # Dostal spravu o odpojeni
                try:
                    response = connection.socket.recv(1500) # Pocuvame spravy od servera
                except socket.timeout as e: # Ak server neposiela DIS_ACK viac ako 50 sekund
                    connection.disconnected() # Odpojenie
                fragment_type = struct.unpack('!B', response[0 : 1])[0]
                if fragment_type == FragmentType.DIS: # Znovu posleme DIS_ACK
                    send_response(connection, FragmentType.DIS_ACK)
                elif fragment_type == FragmentType.DIS_ACK: # Priznak ukoncenia spojenia
                    connection.disconnected() # Odpojenie
                continue

            if len(connection.request_queue) > 0: # Ak v zozname je poziadavka od pouzivatela
                request = connection.popFirstRequest() # Dostaneme ju

                if (request.type == ConnectionRequestType.connect) and (connection.state == ConnectionState.NEW): # Poziadavka o pripojenie
                    connection.dest_ip = request.data[0]
                    connection.dest_port = request.data[1]
                    connection_fragment = struct.pack('B', FragmentType.CON)
                    data = send(connection, connection_fragment, [FragmentType.CON_ACK], 25.0, 3)

                    if data is None: # Ziadna odpoved na pripojenie
                        print(connection.getInfoText('Cannot connect to ' + connection.dest_ip + ':' + str(connection.dest_port) + '. Server does not response'), end = '')
                        connection.dest_ip = None
                        connection.dest_port = None
                    else: # Uspesne pripojenie
                        print(connection.getInfoText('Connected to ' + connection.dest_ip + ':' + str(connection.dest_port)), end = '')
                        connection.state = ConnectionState.CONNECTED 
                        connection.keep_alive_thread = None
                        connection.keep_alive_options = None

                elif (request.type == ConnectionRequestType.send) and (connection.state == ConnectionState.CONNECTED): # Poziadavka na poslanie dat
                    is_file_transfer = request.data[0]
                    payload = request.data[1]
                    fragment_size = request.data[2]

                    connection.keep_alive_thread_stop() # Ukoncujeme keep-alive vlakno
                    connection.state = ConnectionState.TRANSFER

                elif ((request.type == ConnectionRequestType.exchange) or (request.type == ConnectionRequestType.disconnect)) and (connection.state == ConnectionState.CONNECTED): # Poziadavka o vymene roli alebo odpojeni
                    response = send_xchg_dis_request(connection, is_dis_request = True if request.type == ConnectionRequestType.disconnect else False) # Odosleme ziadost
                    
                    if request.type == ConnectionRequestType.exchange: # Ak proces zmeny roli
                        if response is not None: # Dostali potvrdenie
                            connection.isServer = True
                            print(connection.getInfoText('Switching to server'), end = '')
                            t = threading.Thread(target = server, args = [connection])
                            t.start() # Zmena roli na server
                            return
                        else: print(connection.getInfoText('Server on ' + connection.dest_ip + ':' + str(connection.dest_port) + ' does not response to exchange roles request.'), end = '') # Nedostali odpoved od servera na zmenu roli
                    else: # Ak proces odpojenia
                        # Posleme priznak ukoncenia spojenia
                        send_response(connection, FragmentType.DIS_ACK) 
                        connection.disconnected() # Odpojenie

        else: # Transfer, posielame data
            succefuly, fragments_sended, bytes_sended = fragment_and_transfer(connection, is_file_transfer, payload, fragment_size) # Fragmentovat a poslat data
            if succefuly: # Uspesne odoslanie dat
                print(connection.getInfoText('Succefully transfer data to ' + connection.dest_ip + ':' + str(connection.dest_port) + '\nTotal bytes sended: ' + str(bytes_sended) + '\nTotal fragments sended: ' + str(fragments_sended)), end = '')
            else: # Neuspesne odoslanie
                print(connection.getInfoText('Failed to transfer data to ' + connection.dest_ip + ':' + str(connection.dest_port) + '\nTotal bytes sended: ' + str(bytes_sended) + '\nTotal fragments sended: ' + str(fragments_sended)), end = '')
            connection.state = ConnectionState.CONNECTED

def send_xchg_dis_request(connection, is_dis_request = False): # Odosiela ziadost o vymenu roli

    if connection.keep_alive_thread is not None:
        connection.keep_alive_thread_stop() # Zastavi keep-alive thread
    request = struct.pack('!B', FragmentType.DIS if is_dis_request else FragmentType.XCHG)
    response = send(connection, request, [FragmentType.DIS_ACK if is_dis_request else FragmentType.XCHG_ACK], 25.0, 3)
    return response # Vrati odpoved

# Metoda poslania fragmentov zo zadanym poctom opakovani v pripade neodpovedi v case timeout
def send(connection, fragment, excpected_types, timeout, attempts, fragment_number = None):
    global stat
    connection.socket.settimeout(timeout) # Nastavujeme hodnotu casovaca
    current_attempt = 0
    fragment_types = { 0 : 'CON', 1 : 'CON_ACK', 2 : 'DATA', 3 : 'ACK', 4 : 'TEST', 5 : 'TEST_ACK', 6 : 'XCHG', 7 : 'XCHG_ACK', 8 : 'DIS', 9 : 'DIS_ACK' }

    while current_attempt < attempts: # Pokial nevyprsane pokusy
        fragment_type = struct.unpack('!B', fragment[0 : 1])[0]
        fragment_number = None
        if fragment_type == FragmentType.DATA:
            fragment_number = struct.unpack('!I', fragment[1 : 5])[0]
        # Vypis typu fragmentu a cisla pokusu jeho odoslania
        if stat: print(connection.getInfoText('Sending ' + fragment_types[fragment_type] + (' fragment number ' + str(fragment_number) if fragment_number is not None else '') + ' to ' + connection.dest_ip + ':' + str(connection.dest_port) + '. Attempt: ' + str(current_attempt + 1)), end = '')
        try:
            connection.socket.sendto(fragment, (connection.dest_ip, connection.dest_port))
        except OSError as os_err: # Nie je mozne odoslat odpoved, spojenie prerusene
            return None
        try: 
            data = connection.socket.recv(1500) # Pokus o dostanie odpovedi
            fragment_type = struct.unpack('B', data[:1])[0]
            if fragment_type in excpected_types: # Ak bol dostany taky typ fragmentu, ktory bol cakany
                connection.socket.settimeout(None)
                return data # Vratime prijatu odpoved
            else: current_attempt += 1 # Ak nie, tak opakujeme pokus
        except socket.timeout as e: # V pripade vyprsania casovaca prejdeme na dalsi pokus
            current_attempt += 1
    connection.socket.settimeout(None)
    return None # V pripade nedostania poziadovanej odpovedi

def send_response(connection, fragment_type): # Metoda poslania odpovedi
    response = struct.pack('!B', fragment_type) # Balime podla formatu odpovedi
    try:
        connection.socket.sendto(response, (connection.dest_ip, connection.dest_port))
    except OSError as os_err: # Nie je mozne odoslat odpoved, spojenie prerusene
        connection.disconnected() # Odpojenie
  
def timer_print(text, time_on_ask, options): # Vypisuje zadany text zadany pocet sekund

    print('\n')
    while time_on_ask != 0:
        if options.must_be_stopped == True: return # Priznak zastavenia threadu
        print((connection.getInfoText(text, '\r') + ' ' + str(time_on_ask) + ' seconds remaining' + ' [y, n]: ').replace('\n---:', ''), end = '')
        time.sleep(1)
        time_on_ask -= 1
    print('\n')
    options.thread_ended = True # Priznak ukoncenia threadu

# Pocuva odpoved pouzivatela a spusti vypisovanie textu, limitovane casom
def user_ask(text, time_on_ask): 
    global choice
    options = ThreadOptions()
    t = threading.Thread(target = timer_print, args = [text, time_on_ask, options])
    t.start() 
    while (choice is None) and (not options.thread_ended):
        time.sleep(0)
    options.must_be_stopped = True
    t.join()
    if options.thread_ended is None:
        if choice == 'y': return True
        else: return False
    else: return False
    
# Kontroluje prijaty fragment na chyby a posiela potvrdenie    
def check_crc_send_ack(connection, fragment): 
    recieved_crc = struct.unpack('!I', fragment[len(fragment) - 4 : len(fragment)])[0] # Prijate crc
    crc = zlib.crc32(fragment[0 : len(fragment) - 4]) # Spocitane na strane servera crc
    data_length = len(fragment[5 : len(fragment) - 4]) # Dlzka datovej casti
    if recieved_crc == crc: # Ak fragment bol prenieseny bez chyb
        fragment_number = struct.unpack('!I', fragment[1 : 5])[0]
        if stat: print(connection.getInfoText('Recieved fragment number ' + str(fragment_number) + ' from ' + connection.dest_ip + ':' + str(connection.dest_port) + '\n' + str(data_length) + ' bytes recieved'), end = '')
        ack_fragment = struct.pack('B', FragmentType.ACK)
        try: # Poslanie odpovedi
            connection.socket.sendto(ack_fragment, (connection.dest_ip, connection.dest_port))
        except OSError as e: # Nie je mozne odoslat odpoved, spojenie prerusene
            print(connection.getInfoText('Cannot send ACK response'), end = '')
            connection.disconnected() # Odpojenie
            return False
        return True
    else: # Fragment bol prenieseny z chybou
        if stat: print(connection.getInfoText('Fragment from ' + connection.dest_ip + ':' + str(connection.dest_port) + ' was recieved with error'), end = '')
        return False

def check_first_fragment(connection, fragment): # Analyza incializacneho datoveho fragmentu
    file_name = None
    fragments_count = struct.unpack('!I', fragment[5 : 9])[0] # Zistenie celkoveho poctu fragmentov
    file_name_symbols_count = struct.unpack('!B', fragment[9 : 10])[0] #Pocet symbolov v nazve suborov
    text = 'Starting recieving '
    if file_name_symbols_count > 0: # Ak sa prenasa subor, tak zistime jeho nazov
        file_name = fragment[10 : 10 + file_name_symbols_count].decode('utf-8') 
        text += 'file ' + file_name
    else: text += 'message'
    connection.socket.settimeout(50.0) # Nastavenie casovaca pri transfere dat
    print(connection.getInfoText(text + ' from ' + connection.dest_ip + ':' + str(connection.dest_port) + ' with total number of fragments of ' + str(fragments_count)), end = '')
    return (fragments_count, file_name)

# Uklada prijate data do suborov
def save_info(connection, recieved_data, recieved_count, file_name, message_recieved):
    out = None
    if file_name is not None: # Ak bol prijaty subor
        out = open(file_name, 'wb')
        out.write(recieved_data) # Ulozi subor
        print(connection.getInfoText('Succefully recieved file from ' + connection.dest_ip + ':' + str(connection.dest_port) + '\nTotal bytes recieved: ' + str(len(recieved_data)) + '\nTotal fragments recieved: ' + str(recieved_count) + '\n' + file_name + ' was saved in ' + os.path.abspath(file_name)), end = '')
    else: # Ak bola prijata textova sprava
        message = str(recieved_data, encoding = 'utf-8')
        file_name = 'message-' + str(message_recieved) + '.txt'
        out = open(file_name, 'w')
        out.write(message) # Ulozi do txt suboru
        print(connection.getInfoText('Succefully recieved message from ' + connection.dest_ip + ':' + str(connection.dest_port) + '\nTotal bytes recieved: ' + str(len(recieved_data)) + '\nTotal fragments recieved: ' + str(recieved_count) + '\n' + message + ' was saved in ' + os.path.abspath(file_name)), end = '')
    out.close()

def server(connection): # Rezim servera
    global choice
    connection.keep_alive_thread = None
    connection.keep_alive_options = None
    file_name = None
    recieved_data = None # Buffer prijatych dat
    fragments_count = None # Pocet fragmentov v ramci jedneho prenosu
    recieved_count = 0 # Pocet prijatych fragmentov
    message_recieved = 0 # Pocet vsetkych prijatych sprav

    while True:

        if connection.state == ConnectionState.CLOSED: # Ak socket je zatvoreny, ukoncime sa
            return

        if connection.state != ConnectionState.CONNECTED: # Pocuvame na vstup, nie keep-alive
            try: 
                data, client_address = connection.socket.recvfrom(1500)
            except socket.timeout as e: # Vyprsanie casovaca
                if connection.state == ConnectionState.XCHG_RECIEVED:
                    # Ked dostali ziadost o vymene roli a nedostavame od klienta data viac ako 20s
                    # Prepneme sa na klienta
                    connection.state = ConnectionState.CONNECTED
                    connection.socket.settimeout(None)
                    connection.isServer = False
                    print(connection.getInfoText('Switching to client'), end = '')
                    t = threading.Thread(target = client, args = [connection])
                    t.start() # Zmena roli na server
                    return
                else: # V inych pripadoch spojenie je prerusene, odpajame sa
                    connection.disconnected()
                    file_name = None
                    recieved_data = None
                    fragments_count = None
                    recieved_count = 0    
            fragment_type = struct.unpack('B', data[:1])[0] # Zistenie typu prijateho fragmentu

            if fragment_type == FragmentType.CON: # Ziadost o pripojeni

                if connection.state == ConnectionState.NEW: # Ak nebol pripojeny server
                    _choice = user_ask('Would you like to allow ' + client_address[0] + ':' + str(client_address[1]) + ' to connect?', 10) # Pytame sa pouzivatela
                    choice = None
                    if _choice: # Povolene pripojenie
                        connection.dest_ip = client_address[0]
                        connection.dest_port = client_address[1]
                        connection.state = ConnectionState.CONNECTED
                        connection.keep_alive_thread = None
                        connection.keep_alive_options = None
                        print(connection.getInfoText('Connected to ' + connection.dest_ip + ':' + str(connection.dest_port)), end = '')
                        con_ack_fragment = struct.pack('B', FragmentType.CON_ACK)
                        try: # Posielame akceptaciu pripojenia
                            connection.socket.sendto(con_ack_fragment, client_address)
                        except OSError as os_err: # Nie je mozne odoslat odpoved, spojenie prerusene
                            print(connection.getInfoText('Error on connection to ' + connection.dest_ip + ':' + str(connection.dest_port)), end = '')
                            connection.dest_ip = None
                            connection.dest_port = None
                            connection.state = ConnectionState.NEW

                else: # Klient nedostal CON_ACK
                    con_ack_fragment = struct.pack('B', FragmentType.CON_ACK)
                    try: # Znovu ho posleme
                        connection.socket.sendto(con_ack_fragment, client_address)
                    except OSError as os_err: # Nie je mozne odoslat odpoved, spojenie prerusene
                        print(connection.getInfoText('Error on connection to ' + connection.dest_ip + ':' + str(connection.dest_port)), end = '')
                        connection.dest_ip = None
                        connection.dest_port = None
                        connection.state = ConnectionState.NEW
            
            elif (fragment_type == FragmentType.DATA) and (connection.state == ConnectionState.TRANSFER): # Dostal datovy fragment
                if (check_crc_send_ack(connection, data)): # Kontrolujeme na chyby
                    fragment_number = struct.unpack('!I', data[1 : 5])[0]
                    if fragment_number == 0: # Inicializacny fragment
                        # Zistime celkovy pocet fragmentov a pripadne nazov subora
                        fragments_count, file_name = check_first_fragment(connection, data)  
                    elif fragment_number == recieved_count + 1: # Ak dostavame dalsi v poradi fragment
                        recieved_count += 1
                        if recieved_data is None:
                            recieved_data = bytes()
                        recieved_data += data[5 : len(data) - 4] # Zapiseme data v buffer
            elif (fragment_type == FragmentType.TEST) and (connection.state == ConnectionState.TRANSFER): # Dostavame TEST od klienta, prenos je ukonceny
                connection.state = ConnectionState.CONNECTED
                if recieved_count == fragments_count: # Ak server dostal vsetky fragmenty bez chyb
                    if file_name is None: message_recieved += 1
                    t = threading.Thread(target = save_info, args = [connection, recieved_data, recieved_count + 1, file_name, message_recieved])
                    t.start() # Spustime zapis dat do subora v inom vlakne
                else: print(connection.getInfoText('Failed on recieving data from ' + connection.dest_ip + ':' + str(connection.dest_port)), end = '')
                connection.socket.settimeout(None)
                file_name = None
                recieved_data = None
                fragments_count = None
                recieved_count = 0            
            elif (fragment_type == FragmentType.XCHG) and (connection.state == ConnectionState.XCHG_RECIEVED): # Dostavame XCHG od klienta
                send_response(connection, FragmentType.XCHG_ACK) # Posleme akceptacnu odpoved
            elif connection.state == ConnectionState.DIS_RECIEVED: # Dostali ziadost o odpojenie
                if fragment_type == FragmentType.DIS: # Klient nedostal DIS_ACK
                    send_response(connection, FragmentType.DIS_ACK) # Posleme ho znovu
                elif fragment_type == FragmentType.DIS_ACK: # Ukoncenie spojenia
                    connection.disconnected() 
        
        else: # Stav aktivneho spojenia, pocuvame na keep-alive
            if connection.keep_alive_thread is None: # Vlakno keep-alive nie je vytvorene
                connection.keep_alive_thread_start() # Vytvorime ho
            elif connection.keep_alive_options.thread_ended is not None: # Keep-alive bol ukonceny
                data = connection.keep_alive_options.thread_ended # Zistime navratovu hodnotu
                connection.keep_alive_thread = None
                connection.keep_alive_options = None
                fragment_type = struct.unpack('B', data[:1])[0]
                if fragment_type == FragmentType.DATA: # Zaciatok posielania dat
                    connection.state = ConnectionState.TRANSFER
                    if (check_crc_send_ack(connection, data)): # Kontrolujeme fragment
                        fragment_number = struct.unpack('I', data[1 : 5])[0]
                        if fragment_number == 0: # Inicializacny fragment
                            fragments_count, file_name = check_first_fragment(connection, data)     
                elif fragment_type == FragmentType.XCHG: # Poziadavka o vymenu roli od klienta
                    connection.state = ConnectionState.XCHG_RECIEVED
                    send_response(connection, FragmentType.XCHG_ACK) # Posleme odpoved
                    # Nastaveny casovac na automaticke prepnutie roli
                    connection.socket.settimeout(20.0) 
                elif fragment_type == FragmentType.DIS: # Sprava o zaciatku odpojenia klienta
                    connection.state = ConnectionState.DIS_RECIEVED
                    # Nastaveny casovac na automaticke odpojenie
                    connection.socket.settimeout(50.0)
                    send_response(connection, FragmentType.DIS_ACK) # Posleme odpoved
                continue
            if len(connection.request_queue) > 0: # Pocuvame na vstup, ak je spojenie (v pripade serveru)
                request = connection.popFirstRequest() # Vyberame poziadavku
            
                if (request.type == ConnectionRequestType.exchange) or (request.type == ConnectionRequestType.disconnect): # Poziadavka o zmene roli alebo odpojeni
                    response = send_xchg_dis_request(connection, is_dis_request = True if request.type == ConnectionRequestType.disconnect else False) # Posleme poziadavku

                    if request.type == ConnectionRequestType.exchange: # Ak proces zmeny roli
                        if response is not None: # Mame potvrdenie od klienta
                            connection.isServer = False
                            print(connection.getInfoText('Switching to client'), end = '')
                            t = threading.Thread(target = client, args = [connection])
                            t.start() # Zmena roli na klient
                            return
                        else: print(connection.getInfoText('Client on ' + connection.dest_ip + ':' + str(connection.dest_port) + ' does not response to exchange roles request.'), end = '')
                    else: # Ak proces odpojenia
                        send_response(connection, FragmentType.DIS_ACK) # Posleme priznak ukoncenia spojenia
                        connection.disconnected()
        
            
if __name__ == '__main__':

    connections = {} # Slovnik spojeni

    host_ip = input('Enter host ip address: ')
    print('Starting host ' + host_ip)
    print('---: ', end = '')
    
    while True:
        command = input() # Zadanie prikazu pouzivatela
        if command == 'exit': os._exit(0) # Prikaz ukoncenia programu
        command = command.lower().split(' ')

        if command[0] == 'open': # Prikaz otvorenia socketu
            host_port = 0
            if len(command) > 2:
                host_port = int(command[2])
            else:
                host_port = default_host_port
                default_host_port += 1
            if (connections.get(host_port, None) is None):
                connection = Connection(host_port, isServer = True if command[1] == 'server' else False) # Vytvarame objekt spojenia
                connections[host_port] = connection
            else: print('Cannot open socket on port', host_port, '\n---: ', end = '')
        elif command[0] == 'connect': # Prikaz na pripojenie
            splitted = command[1].split(':')
            server_address = (splitted[0], int(splitted[1]))
            host_port = int(command[2])
            if (connections.get(host_port, None) != None) and (not connections[host_port].isServer) and (connections[host_port].state == ConnectionState.NEW): 
                # Ak existuje nepripojeny klientovy socket zo zadanym portom
                connections[host_port].request_queue.append(ConnectionRequest(ConnectionRequestType.connect, server_address))
            else: print('No opened clients sockets with port', host_port, '\n---: ', end = '')
        elif command[0] == 'send': # Prikaz poslania dat serveru
            is_file_transfer = True if command[1] == 'file' else False
            name = input('\nEnter ' + ('file path and name' if is_file_transfer else 'text')  + ' to transfer: ')
            fragment_size = int(command[2])
            if fragment_size in range(1, 1463 + 1): # Overenie maximalnej dlzky datovej casti
                request = ConnectionRequest(ConnectionRequestType.send, (is_file_transfer, name, fragment_size))
                client_port = int(command[3])
                if (connections.get(client_port, None) != None) and (not connections[client_port].isServer) and (connections[client_port].state == ConnectionState.CONNECTED):
                    # Ak existuje pripojeny klientovy socket zo zadanym portom
                    connections[client_port].request_queue.append(request)
                else: print('No opened clients sockets with port', client_port, '\n---: ', end = '')
            else: print('Incorrect fragment size, must be in range [1; 1463]\n---: ', end = '')
        elif command[0] in ['y', 'n']: # Odpoved pri pripojeni
            choice = command[0] # Posuva sa do ineho threadu
        elif command[0] == 'stat': # Prikaz zobrazenia statistickych sprav
            stat = True
        elif (command[0] == 'exchange') or (command[0] == 'disconnect'):
            # Spracovanie prikazu vymeny roli a odpojenia
            host_port = int(command[1])
            if (connections.get(host_port, None) is not None) and (connections[host_port].state == ConnectionState.CONNECTED):
                # Ak existuje pripojeny socket zo zadanym portom
                connections[host_port].request_queue.append(ConnectionRequest(ConnectionRequestType.exchange if command[0] == 'exchange' else ConnectionRequestType.disconnect))
            else: print('No connections on port ' + command[1] + '\n---: ', end = '')
        elif (command[0] == 'close'): # Prikaz zatvorenia socketu
            host_port = int(command[1])
            if (connections.get(host_port, None) is not None):
                if (connections[host_port].state == ConnectionState.CONNECTED):
                    # Ak je pripojeny, tak najprv odpojime ho
                    connections[host_port].request_queue.append(ConnectionRequest(ConnectionRequestType.disconnect))
                    while connections[host_port].state != ConnectionState.NEW:
                        time.sleep(0)
                connections[host_port].state = ConnectionState.CLOSED
                connections[host_port].socket.detach()
                print('Closed socket on port ' + command[1] + '\n---: ', end = '')
            else: print('No connections on port ' + command[1] + '\n---: ', end = '')
        else: print('Unknown command\n---: ', end = '')