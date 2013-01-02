# se puede iterar por sobre los archivos de tal manera de que se generen
# automaticamete los patrones y no tener que definirlos manualmente. Eso quiere
# decir tener la capacidad de mandar todos el archivo completo a un objeto
# matlab.
import os
import shutil
import patterns
import re

# Ruta en la que se encuentran los archivos entregados por codelco, estos a su
# vez se encuentran en una posicion relativa a la posicion de este archivo en
# la path
pathFolder = os.path.dirname((os.path.abspath(__file__))) + '/../data sets'

# lista de archivos y directorios
files = os.listdir(pathFolder)

# eliminar todos los directorios y conservar los archivos
for i in files:
    if os.path.isdir(pathFolder + '/' + i):
        shutil.rmtree(pathFolder + '/' + i)

# Lista con los nombres de cada uno de los archivos
filesNamesList = os.listdir(pathFolder)


# Para todo archivo en la carpeta, extraiga su informacion
for fileName in filesNamesList:

    #abrir archivo el i-esimo archivo, almacenar su contenido y cerrarlo
    fileHandle = open(pathFolder + '/' + fileName, 'r')
    text = fileHandle.read()
    fileHandle.close()

    #crear una nueva carpeta con el nombre del archivo y en la misma ruta
    #del archivo
    folderPath = pathFolder + '/' + fileName + ' FOLDER'



    #Si la ruta ya esta siendo utilizada por una carpeta
    if os.path.exists(folderPath):
        'eliminar la carpeta para evitar conflictos'
        shutil.rmtree(folderPath)

    # crear una carpeta en donde almacenar los archivos
    os.mkdir(folderPath)

    # despues de creada la carpeta se genera un archivo con el nombre del
    # evento
    nameFile = open(folderPath + '/' + 'name.txt', 'w')
    nameFile.write(fileName)
    nameFile.close()
    # todos los geosensores, hay que saber cuantos geosensores existen en el
    # documento, para ello vemos el patron en la variable text, ngs es la variable
    # que contiene el n'umero de geosensores de un evento.

    ngs = len(re.findall(r" trigger ", text))

    for gs in range(ngs):

        #patron con las mediciones enumeradas por sensor
        dataMatch = patterns.dataRgx(gs)

        #extraer la lista de los datos
        listData = dataMatch.findall(text)

        #sensores con indice menor a  se debe hacer una correcion a
        #la numeracion
        if gs < 10:
            cero = '0'
        else:
            cero = ''

        #Un archivo para cada conjunto de datos de las mediciones
        newFilePath = cero + str(gs) + "sismogram" + ".txt"

        #Nombre del archivo almacenado en la ruta de la carpeta con el nombre
        #del evento
        newFile = open(folderPath + r'//' + newFilePath, 'w')

        #almacenar la lista y reemplazar el : por nada para que haga
        #conflictos con matlab
        for data in listData:
            newFile.write(data.replace(":", ""))

        #luego de llenar el documento con los datos se cierra el archivo
        newFile.close()

    #fin de llenado de los archivos de datos

    #Extraccion de la informacion de los archivos, cada uno de estos parametros son
    # necesarios como imput del modelo.
    '----------------------- t_time -----------------------'
    't_time, inicio del buffer en segundos'
    ttimelist = patterns.t_time_rgx.findall(text)
    filettime = open(folderPath + r'//' + 't_time.txt', 'w')

    'write in the file all match and close'
    for ttime in ttimelist:
        filettime.write(ttime.replace(":", " "))
    filettime.close()

    '----------------------S_pick--------------------------'
    S_picklist = patterns.S_pick_rgx.findall(text)
    fileS_pick = open(folderPath + r'//' + 'S_pick.txt', 'w')

    'write in the file all match and close'
    for S_pick in S_picklist:
        fileS_pick.write(S_pick.replace("=", " "))
    fileS_pick.close()
    '----------------------P_pick--------------------------'
    P_picklist = patterns.P_pick_rgx.findall(text)
    fileP_pick = open(folderPath + r'//' + 'P_pick.txt', 'w')

    'write in the file all match and close'
    for P_pick in P_picklist:
        fileP_pick.write(P_pick.replace("=", " "))
    fileP_pick.close()
    '''----------------------validSP--------------------------'''
    validSPlist = patterns.validSP_rgx.findall(text)
    filevalidSP = open(folderPath + r'//' + 'validSP.txt', 'w')

    'write in the file all match and close'
    for validSP in validSPlist:
        filevalidSP.write(validSP.replace("=", " "))
    filevalidSP.close()
    '''----------------------Site----------------------------'''
    site_id_list = patterns.site_id_rgx.findall(text)
    file_site_id = open(folderPath + r'//' + 'site_id.txt', 'w')

    'write in the file all match and close'
    for site_id in site_id_list:
        file_site_id.write(site_id.replace("=", " "))
    file_site_id.close()

    '----------------------validS--------------------------'
    validSlist = patterns.validS_rgx.findall(text)
    filevalidS = open(folderPath + r'//' + 'validS.txt', 'w')
    'write in the file all match and close'
    for validS in validSlist:
        filevalidS.write(validS.replace("=", " "))
    filevalidS.close()
    '----------------------validP--------------------------'
    validPlist = patterns.validP_rgx.findall(text)
    filevalidP = open(folderPath + r'//' + 'validP.txt', 'w')
    'write in the file all match and close'
    for validP in validPlist:
        filevalidP.write(validP.replace("=", " "))
    filevalidP.close()
    'tiempo de llegada de la onda p'
    p_time = patterns.p_time_rgx.findall(text)
    file_p_time = open(folderPath + r'//' + 'p_time.txt', 'w')
    for i in p_time:
        file_p_time.write(i.replace(":", " "))
    file_p_time.close()
    'tiempo de llegada de la onda s'
    s_time = patterns.s_time_rgx.findall(text)
    file_s_time = open(folderPath + r'//' + 's_time.txt', 'w')
    for i in s_time:
        file_s_time.write(i.replace(":", " "))
    file_s_time.close()
    'TriggerPosition para cortar la senal'
    TriggerPosition = patterns.trigger_position_rgx.findall(text)
    file_TriggerPosition = open(folderPath + r'//' + 'TriggerPosition.txt', 'w')
    for i in TriggerPosition:
        file_TriggerPosition.write(i)
    file_TriggerPosition.close()
    'coordenada r0 = (x, y, z) de los sensores'
    X_coord = patterns.x_coord_rgx.findall(text)
    Y_coord = patterns.y_coord_rgx.findall(text)
    Z_coord = patterns.z_coord_rgx.findall(text)
    file_R_coord = open(folderPath + r'//' + 'R_coord.txt', 'w')
    'generar una lista con tuplas para almacenar las coordenadas'
    for i in range(len(X_coord)):
        X_coord[i] = X_coord[i].replace('X_coord',"").replace(" ","").replace("=","")
        Y_coord[i] = Y_coord[i].replace('Y_coord',"").replace(" ","").replace("=","")
        Z_coord[i] = Z_coord[i].replace('Z_coord',"").replace(" ","").replace("=","")
        'guardar en el archivo'
        file_R_coord.write(X_coord[i] + "\t" + Y_coord[i] + "\t" + Z_coord[i] + "\n")
    file_R_coord.close()
    'guardas la lista con las frecuencias de muestreo'
    sampling_rate = patterns.sampling_rate_rgx.findall(text)
    file_sampling_rate = open(folderPath + r'//' + 'hardware_sampling_rate.txt', 'w')
    for i in sampling_rate:
        file_sampling_rate.write(i.replace("=", " "))
    file_sampling_rate.close()
    'finalmente construir el archivo con los datos del modelo'
    file_model = open(folderPath + r'//' + 'model.txt', 'w')
    alpha = patterns.alpha.findall(text)
    file_model.write(alpha[0] + '\n')
    beta = patterns.beta.findall(text)
    file_model.write(beta[0] + '\n')
    rho = patterns.rho.findall(text)
    file_model.write(rho[0] + '\n')
    origin_time = patterns.origin_time_rgx.findall(text)
    # el patron de tiempo de origen hay que solamente considerar los segundos
    origin_time = re.findall(r":[0-9]*\.[0-9]* ", origin_time[0])[0].replace(":", " ")
    file_model.write('origin_time                    = ' + origin_time + '\n')
    LocX = patterns.LocX_rgx.findall(text)
    file_model.write(LocX[0])
    LocY = patterns.LocY_rgx.findall(text)
    file_model.write(LocY[0])
    LocZ = patterns.LocZ_rgx.findall(text)
    file_model.write(LocZ[0])
    file_model.close()
