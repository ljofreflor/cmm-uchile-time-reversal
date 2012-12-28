'''
importar un archivo con un evento sismico a un objeto del tipo event
'''
import re
import evento
import numpy

def doc2event(texto):
    #la informacion del documento de los sismogramas se pueden dividir en los 
    #siguientes tipos:
    #1. indices: valores que van relacionados a un valos especifico en asociado
    # a un indice especifico.
    #2. valores flotantes: Mediciones duras
    #3. valores flotantes con correccion para el usuario
    #4. mediciones de los campos de velocidad o aceleracion
    
    # hacemos la busqueda del patron dentro del documento y este nos devolvera 
    #una lista de variables las cuales puedes ser almacenadas en el objeto event
    #y tambien en el objeto geosensor. Tambien es relevante ver que existen atri
    #butos que tienen un parentesis que da informacion, por ejemplo:
    # (in user system:       -0.000000)
    
    atributos = re.findall('\n(.+?)[ ]+=[ ]+(.+?)', texto)
    
    # para todos estos atributos eliminamos los textos 
    # (in user system:       -0.000000)
    
        
    med = re.findall('(\d+)[ ]+(\d+):[ ]+(.+E.+)[ ]+(.+E.+)[ ]+(.+E.+)', texto)
    #convertir el conjunto de datos a un array
    med = numpy.array(map(lambda x:map(float,x),med)) 
    
    #instanciar una clase evento
    ev = evento()
    
    #agregamos al evento los atributos, el primer elemento de la tupla es el 
    #nombre del atributo, y el segundo elemento es el valor del atributo. De 
    #esta manera se agregan uno por uno los atributos a el objeto evento.
    
    for ii in atributos:
        nombre, valor = ii
        # los primeros atributos del evento hasta best_location son atributos 
        # del evento mismo, los demas son correspondientes a cada uno de los
        # sismografos de forma independiete.
        try:
            #try integer
            setattr(ev.__class__, nombre, int(valor))
        except ValueError:            
            try:
                # Para extraer de un flotante aparece la particularidad de que 
                # este puede estar seguido por el texto 
                if re.match('.*\(in user system:[]+-[.]+\)', valor):
                    valor = re.findall('(.*)\(in user system:[]+-[.]+\)',valor)
                elif re.match('.*\(in user system:[]+-[.]+\)', valor):
                    valor = re.findall('(.*)\(in user system:[]+-[.]+\)',valor)
                setattr(ev.__class__, nombre, float(valor))
            except ValueError:
                #usar el string para almacenar la informacion
                setattr(ev.__class__, nombre, valor)
                
    #despues de agregar la informacion es posible agregar los sensores. Cada 
    #evento consta de una lista de sensores    
    geosensores = []
    
        
    # con el objeto poblado de informacion retornamos
    return ev