import geosensor

class event(object):
    
    '''Clase que define un evento sismico'''    
    
    '''constructor de la clase'''
    def __init__(self, name,alpha, beta, rho, LocR, origin_time, error):
        self.name = name;
        self.count = 0;
        self.alpha = alpha;
        self.beta = beta;
        self.beta_est = beta;
        self.rho = rho;
        self.LocR = LocR;
        self.LocR_est = LocR;
        self.origin_time = origin_time;
        self.origin_time_est = origin_time;
        self.first_time = origin_time;
        self.last_time = origin_time;
        self.err = error;
        
    def addSeismogram(self,seismogram):
        self.seismogram.add(seismogram)       
        
    
        
       
    