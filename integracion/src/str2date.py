#tramsforma la fecha en un objeto del tipo fecha
class fecha(object):
    year
    month
    day
    hour
    minute
    second
    def fecha(self, datestring):
        #las fechas segun la documentacion de codelco tiene las fechas con el 
        #formato segun los siguientes ejemplos
        #Sun Aug  2 07:30:40.582843 1998
        #Sun Aug  2 07:30:40.565471 1998
        #Tue Mar 31 21:01:11.336050 2009
        
        re = '([\w]{3})[ ]([\w]{3})[ ](){2}:(){2}:(){2}:(){2}\.(){6}[ ](){4}'