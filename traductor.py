instrucciones = {                                  # Diccionario/todas las instrucciones type R - I - J 
    "add": ["R","000000","100000"],                # instruccion R: opcode, funct
    "addu":  ["R","000000","100001"],              # instruccion I: opcode
    "sub":  ["R","000000","100010" ],              # instruccion J: opcode
    "subu":  ["R","000000", "100011"],
    "and":  ["R","000000", "100100"],
    "or":  ["R","000000", "100101"],
    "nor":  ["R","000000", "100111"],
    "sll":  ["R","000000", "000000"],
    "srl":  ["R","000000", "000010"],
    "sra":  ["R","000000", "000011"],
    "slt":  ["R","000000", "101010"],
    "sltu":  ["R","000000", "101011"],
    "mult":  ["R","000000", "011000"],
    "multu":  ["R","000000", "011001"],
    "div":  ["R","000000", "011010"],
    "divu":  ["R","000000", "011011"],
    "mfhi":  ["R","000000", "010000"],
    "mflo":  ["R","000000", "010010"],
    "jr":  ["R","000000", "001000"],

    "addi":["I" , "001000"], 
    "addiu": ["I", "001001"], 
    "andi": ["I", "001100"], 
    "beq": ["I", "000100"], 
    "bne": ["I", "000101"],
    "lbu": ["I", "100100"], 
    "lhu": ["I", "100101"], 
    "ll":[ "I", "110000"], 
    "lui": ["I", "001111"], 
    "lw": ["I", "100011"],
    "ori": ["I", "001101"], 
    "slti": ["I", "001101"], 
    "sltiu": ["I", "001011"], 
    "sb":["I", "101000"], 
    "sc": ["I", "111000"], 
    "sh": ["I", "101001"], 
    "sw": ["I", "101011"], 

    "j":[ "J", "000010"], 
    "jal":[ "J", "000011"]
}

registros = {
    '$0': 0,   '$at': 1,   '$v0': 2,   '$v1': 3,            #Diccionario/enumeracion de los registros
    '$a0': 4,   '$a1': 5,   '$a2': 6,   '$a3': 7,
    '$t0': 8,   '$t1': 9,   '$t2': 10,  '$t3': 11,
    '$t4': 12,  '$t5': 13,  '$t6': 14,  '$t7': 15,
    '$s0': 16,  '$s1': 17,  '$s2': 18,  '$s3': 19,
    '$s4': 20,  '$s5': 21,  '$s6': 22,  '$s7': 23,
    '$t8': 24,  '$t9': 25,  '$k0': 26,  '$k1': 27,
    '$gp': 28,  '$sp': 29,  '$fp': 30,  '$ra': 31
}

etiquetas = {}

direccionEntera = None 
pc = 0

def convertirHexBinario(num):
    if (num[0:2] == "0x"):
        resultado = "{0:026b}".format(int(num[2::], 16))  #forma una cadena de 26 bits
    else:
        resultado = "{0:026b}".format(int(num, 10))

    return str(resultado)

def getITipoParametro(segundoParametro):
    inmediate = ""
    registro = ""
    i = 0
    while(i < len(segundoParametro) and segundoParametro[i] != "("): #ejemplo sw $s1, 12($s2)
        inmediate += segundoParametro[i]                             #como todo son cadenas de texto toma el 1 y luego 2 es decir 
        i += 1                                                       #inmediate = "12"
    if(segundoParametro[i] == "("):
        i += 1
        while(i < len(segundoParametro) and segundoParametro[i] != ")"): #guarda registro = "$s2"
            registro += segundoParametro[i]
            i += 1
        if(segundoParametro[i] == ")"):
            return [inmediate, registro]  #restorna una lista
        
def complementoA_2(negativo):
    reverse = ""
    binario_y = str(bin(negativo)[2:].zfill(16))
   
    for i in range(len(binario_y)):
        if binario_y[i] == '1':
            reverse += '0'
        else:
            reverse += '1'

    numero_entero = int(reverse, 2)
    suma = numero_entero + 1
    final= str(bin(suma)[2:].zfill(16))

    return final  

def tipoR(instruccionEnPartes, informacionTipoInstruccion):           #por partes= cada parte de la instruccion
    global instrucciones, registros, etiquetas                        #instruccion traducida 1 = "opcode 000000"
    instruccionTraducida = []
    instruccionTraducida.append(informacionTipoInstruccion[1]) 
    
    if instruccionEnPartes[0] =="jr":

        rs = registros[instruccionEnPartes[1]] #se supone que guarda $ra == $rs

        instruccionTraducida.append(str(bin(rs)[2:].zfill(5))) #pasa a binario el registro 31
        instruccionTraducida.append("00000") #$rd
        instruccionTraducida.append("00000") #$rt
        instruccionTraducida.append("00000") #$shamt

    elif instruccionEnPartes[0] == 'sll' or instruccionEnPartes[0] == 'srl' or instruccionEnPartes[0] == 'sra':
        rd = registros[instruccionEnPartes[1][:-1]]  # $rd = $rt, no se toma el ultimo caracter
        rt = registros[instruccionEnPartes[1][:-1]]
        shamt =  convertirHexBinario(instruccionEnPartes[3]) #la cantidad de bits que se corre se pasa a bin
        shamt = shamt[21:26] #toma los 5 bits mas significativos

        instruccionTraducida.append("00000") #no hay $rs
        instruccionTraducida.append(str(bin(rt)[2:].zfill(5))) #convertir a bin $rd , $rt
        instruccionTraducida.append(str(bin(rd)[2:].zfill(5)))
        instruccionTraducida.append(shamt) #shamt

    elif  instruccionEnPartes[0] == 'mfhi' or instruccionEnPartes[0] == 'mflo':
        rd = registros[instruccionEnPartes[1]] #valor del registro con el trabajan $rd

        instruccionTraducida.append("00000") #$rs
        instruccionTraducida.append("00000") #$rt
        instruccionTraducida.append(str(bin(rd)[2:].zfill(5))) #$rd convertir a bin
        instruccionTraducida.append("00000") #shamt
    
    elif instruccionEnPartes[0] == 'div' or instruccionEnPartes[0] == 'divu' or instruccionEnPartes[0] == 'mult' or instruccionEnPartes[0] == 'multu':
        rs = registros[instruccionEnPartes[1][:-1]]
        rt = registros[instruccionEnPartes[2]]

        instruccionTraducida.append(str(bin(rs)[2:].zfill(5))) #$rs a bin
        instruccionTraducida.append(str(bin(rt)[2:].zfill(5))) #$rt a bin
        instruccionTraducida.append("00000") #$rd
        instruccionTraducida.append("00000") #shamt
    
    else:
        rd = registros[instruccionEnPartes[1][:-1]]
        rs = registros[instruccionEnPartes[2][:-1]]             #resto de instrucciones $rd = operacion($rs, $rt)
        rt = registros[instruccionEnPartes[3]]

        instruccionTraducida.append(str(bin(rs)[2:].zfill(5)))
        instruccionTraducida.append(str(bin(rt)[2:].zfill(5)))
        instruccionTraducida.append(str(bin(rd)[2:].zfill(5)))
        instruccionTraducida.append("00000") #shamt

    instruccionTraducida.append(informacionTipoInstruccion[2]) #a todos se les agrega al final funct

    return ''.join(instruccionTraducida) #devuelve la concatenacion 

def  tipoI(instruccionEnPartes, informacionTipoInstruccion):
    global instrucciones, registros, etiquetas, pc 
    instrucionesDosParametros = set(["lw", "lhu", "lbu", "ll", "sw", "sh", "sb", "sc"])
    instruccionTraducida = []
    instruccionTraducida.append(informacionTipoInstruccion[1]) #opcode de las tipo I
    inmediato = None
    positivo = 0

    if instruccionEnPartes[0] =="lui":
        rt = registros[instruccionEnPartes[1][:-1]]
        inmediato = convertirHexBinario(instruccionEnPartes[2]) #convierte el inmediato en bin
        inmediato = inmediato[10:26] #16 bits de el inmediato
        instruccionTraducida.append("00000") #$rs
        instruccionTraducida.append(str(bin(rt)[2:].zfill(5))) #$rt
        instruccionTraducida.append(inmediato) #inmediato traducido


    elif instruccionEnPartes[0] in instrucionesDosParametros:
        rt = registros[instruccionEnPartes[1][:-1]] #$registro de guardado $rt
        parametros = getITipoParametro(instruccionEnPartes[2]) #calcular ej: 8 -> inmediate ($s2 -> $rs)
        inmediato = convertirHexBinario(parametros[0]) #convierte inmediate a bin
        inmediato = inmediato[10:26] #toma los 16 mas significativos
        rs = registros[parametros[1]] #num ($Rs)

        instruccionTraducida.append(str(bin(rs)[2:].zfill(5))) # $rs
        instruccionTraducida.append(str(bin(rt)[2:].zfill(5))) # $rt
        instruccionTraducida.append(inmediato)        
        
    elif instruccionEnPartes[0] =="beq" or instruccionEnPartes[0] =="bne":
        rt = registros[instruccionEnPartes[1][:-1]]
        rs = registros[instruccionEnPartes[2][:-1]]
        
        if instruccionEnPartes[3] [0:2] == "0x":
            inmediato = convertirHexBinario(instruccionEnPartes[3])
            inmediato = inmediato[10:26] #toma los 16 del inmediato 
        else:
            pcSalto = etiquetas[instruccionEnPartes[3]]
            pcSalto = int(pcSalto, 16)
            #calcula a donde va saltar, saltos negativos? complemento a2?
            y = (pcSalto - pc - 4 )// 4

            if y < 0:
                positivo = -1 * y
                inmediato = complementoA_2(y)
            else:
                inmediato = convertirHexBinario(str(y))
                inmediato = inmediato[10:26]

        instruccionTraducida.append(str(bin(rs)[2:].zfill(5)))
        instruccionTraducida.append(str(bin(rt)[2:].zfill(5))) #concatenacion de los binarios 
        instruccionTraducida.append(inmediato)

    elif instruccionEnPartes[0] =="ori":
        rt = registros[instruccionEnPartes[1][:-1]]
        if len(instruccionEnPartes) == 3:
            inmediato = convertirHexBinario(instruccionEnPartes[2]) #convierte el inmediato en bin
            inmediato = inmediato[10:26] #16 bits de el inmediato
            instruccionTraducida.append("00000") #$rs
            instruccionTraducida.append(str(bin(rt)[2:].zfill(5))) #$rt
            instruccionTraducida.append(inmediato) #inmediato traducido

        elif len (instruccionEnPartes) == 4:
            rs = registros[instruccionEnPartes[2][:-1]]
            inmediato = convertirHexBinario(instruccionEnPartes[3]) #convierte el inmediato en bin
            inmediato = inmediato[10:26] #16 bits de el inmediato
            instruccionTraducida.append(str(bin(rs)[2:].zfill(5))) #$rs
            instruccionTraducida.append(str(bin(rt)[2:].zfill(5))) #$rt
            instruccionTraducida.append(inmediato) #inmediato traducido


    else:
        # algebraicas
       
        
        rt = registros[instruccionEnPartes[1][:-1]]
        rs = registros[instruccionEnPartes[2][:-1]]
        inmediato = convertirHexBinario(instruccionEnPartes[3])
        inmediato = inmediato[10:26]

        instruccionTraducida.append(str(bin(rs)[2:].zfill(5)))
        instruccionTraducida.append(str(bin(rt)[2:].zfill(5)))
        instruccionTraducida.append(inmediato)

    return ''.join(instruccionTraducida) #concatenacion completa

def tipoJ(instruccionEnPartes, informacionTipoInstruccion):
    global etiquetas
    instruccionTraducida = []
    instruccionTraducida.append(informacionTipoInstruccion[1])
    if instruccionEnPartes[1] [0:2] == "0x":
        inmediato = convertirHexBinario(instruccionEnPartes[1])
    else:
        inmediato = etiquetas[instruccionEnPartes[1]]
        inmediato = convertirHexBinario(inmediato)
        
    inmediato = "00" + inmediato
    inmediato = inmediato[:24]
    instruccionTraducida.append(inmediato)

    return ''.join(instruccionTraducida)

def traducirInstruccion(instruccion):
    global instrucciones, etiquetas, pc 

    instruccionEnPartes = instruccion.split()
    instruccionTraducida = None

    if instruccionEnPartes[0] in instrucciones: #separa una linea de instruccion jr - $ra
        print("PC LLegada", pc)
        info = instrucciones[instruccionEnPartes[0]] #lista[opcode, shamt, funct]
        if info[0] == 'I':
            instruccionTraducida = tipoI(instruccionEnPartes, info) #info[opcode, funct]
        elif info[0] == 'R':
            instruccionTraducida = tipoR(instruccionEnPartes, info)
        elif info[0] == 'J':
            instruccionTraducida = tipoJ(instruccionEnPartes, info)
        pc += 4
    else:
        return None


    return instruccionTraducida


def lecturaEtiquetas():
    global etiquetas, direccionEntera
    direccion = None
    inmediato = None
    inmediato2 = None 
    direccionEntera = 0
    contador = 0
    with open('pruebas.txt', 'r') as archivo:
        lineas = archivo.readlines()
        #lee bien las lineas

    for indice in range(len(lineas)):
        lineLista = lineas[indice].split() #imprime solo lui y ori
        
        if lineLista[0].lower() == "lui" and inmediato is None:
            inmediato = lineLista[2][2::]
        elif lineLista[0].lower() == "ori" and inmediato2 is None:
            if len(lineLista) == 3:
                inmediato2 = lineLista[2][2::]
                direccion = inmediato + inmediato2
                direccionEntera = int(direccion, 16)
            elif len(lineLista) == 4:
                inmediato2 = lineLista[3][2::]
                direccion = inmediato + inmediato2
                direccionEntera = int(direccion, 16)
            contador += 1

        elif len(lineLista) > 1:
            contador += 1

        if len(lineLista) == 1:
            aux = contador + 1
            etiquetas[lineLista[0][:-1].lower()] = str(hex(int(direccionEntera + 4 * aux))) #toma bien las etiquetas
  


def main():
    global pc, direccionEntera
    inp_file = open('pruebas.txt', 'r')  # Abre el archivo de entrada para lectura
    out_file = open('output.txt', 'w')  # Abre un archivo de salida para escritura
    lecturaEtiquetas()
    
    linea = inp_file.readline()  # Lee una línea del archivo de entrada
    print('Traduciendo ...')
    pc = direccionEntera
    while linea:
        binario = traducirInstruccion(linea[:-1].lower())  # Convierte la línea a su representación en binario y hexadecimal
        out_file.write(linea[:-1] + '------>' + str(binario) + '\n')  # Escribe la línea original y su representación en el archivo de salida
        linea = inp_file.readline()  # Lee la siguiente línea del archivo de entrada
    print('FIN ...')
    print('Output en output.txt')
    inp_file.close()  # Cierra el archivo de entrada
    out_file.close()  # Cierra el archivo de salida


main()
