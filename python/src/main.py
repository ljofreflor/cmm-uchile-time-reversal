import importEvents
import os

#seleccionamos un documento especifico para transformalo en objeto event

pathFolder = os.path.dirname((os.path.abspath(__file__))) + '/../data sets'

# lista de archivos y directorios
files = os.listdir(pathFolder)

# consideramos el primer evento para hacer las pruebas de importar los atributos
# del documento al archivo nuevo

path = open(pathFolder + '/' + files[-1],'r')
text = path.read()
path.close()

# de este texto hay que seleccione los atributos necesarios para poblar de atri
# butos de los objetos event.
text = extractText(path[-1])
ev = importEvents.doc2event(text)

#impeccionamos el evento dado
print ev







