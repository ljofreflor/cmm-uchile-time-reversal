import unittest

import str2date

class TesttimeReversal(unittest.TestCase):
    # prueba de que se extrae correctamente la informacion de la fecha en la 
    # extraccion del documento
    days = 'Mon|Tue|Wed|Thu|Fri|Sat|Sun'
    months = 'Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec'
    
    def teststr2date(self):        
        msj1 = 'No no coincide la extraccion de la fecha' 
        msj2 = 'El programa da fechas con valores fuera de los permitidos'   
        
        #strings de pruebas    
        str = 'Tue Mar 31 21:01:11.336050 2009'    
        tuple = ('Tue', 'Mar', 31, 21, 1, 11.336050, 2009)
        self.assertEqual(tuple, str2date(str), msj1)

# lanzar los test       
if __name__ == '__main__':
    unittest.main()
        