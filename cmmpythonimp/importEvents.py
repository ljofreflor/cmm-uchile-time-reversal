'''
importar un archivo con un evento sismico a un objeto del tipo event
'''
import os
import re
import evento

def doc2event(path):
    #almacenar el texto del archivo en una variable
    actualFolderPath = os.path.abspath(__file__) 
    file = open(path,'r')
    text = file.read()
    file.close()
    
    #con el texto ya almacenado consideramos todas las variables que podemos 
    #rescatar del mismo todas las variables que necesitemos. Para ello usaremos 
    #los mismos nombres de variables en la clase 'event' que los que se usan en
    #el documento de codelco.
    
    #toda variable que este dentro de un salto de linea y un signo igual es una 
    #variable que se puede obtener de forma directa del documento.
    
    patron = '\n*='
    
    #hacemos la busqueda del patron dentro del documento y este nos devolvera 
    #una lista de variables las cuales puedes ser almacenadas en el objeto event
    #y tambien en el objeto geosensor.
    
    
