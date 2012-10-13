'''
Created on 03/06/2012
@author: leonardo
Expresiones regulares de la información que se necesita extraer en el documento de codelco
'''
import re

'''ppick y spick que es el muestro en donde aparece el maximo de la onda
s y p
example:
P_pick                = 1238
S_pick                = 1500
'''

P_pick_rgx = re.compile(r'''
                        P_pick[ ]*=.*\n
                        ''', re.VERBOSE)
S_pick_rgx = re.compile(r'''
                        S_pick[ ]*=.*\n
                        ''', re.VERBOSE)

'patrones que validan las ondas p y s'
validP_rgx = re.compile(r'''
                        valid_P[ ]*=.*\n
                        ''', re.VERBOSE)

'patrones que validan las ondas p y s'
validS_rgx = re.compile(r'''
                        valid_S[ ]*=.*\n
                        ''', re.VERBOSE)
'patrones que validan las ondas p y s'
validSP_rgx = re.compile(r'''
                        valid_SP[ ]*=.*\n
                        ''', re.VERBOSE)

"patron de tiempo, por ejemplo 't_time                = Sun Apr 10 02:27:04.183596 2011'"
t_time_rgx = re.compile(r'''
                        t_time[ ]{16}=.*\n
                        '''
                        , re.VERBOSE)

'patron de tv_usec'
tv_usec_rgx = re.compile(r'''
                         tv_usec[ ]{8}=        #inicio comun
                         [ ]*[0-9]*[ ]*
                         '''
                         , re.VERBOSE)

origin_time_rgx = re.compile(r'''
                             \norigin_time[ ]*=.*\n
                              ''', re.VERBOSE)

p_time_rgx = re.compile(r'''
                        p_time[ ]{16}=.*\n
                        '''
                        , re.VERBOSE)

s_time_rgx = re.compile(r'''
                        s_time[ ]{16}=.*\n
                        '''
                        , re.VERBOSE)

sampling_rate_rgx = re.compile(
                               r'''
                               hardware_sampling_rate[ ]*=        #inicio comun
                               [ ]*[0-9]*.[0-9]*[ ]*\n
                               '''
                               , re.VERBOSE)
trigger_position_rgx = re.compile(
                                  r'''
                                  TriggerPosition[ ]*=        #inicio comun
                                  [ ]*[0-9]*[ ]*\n
                                  '''
                                  , re.VERBOSE)
site_id_rgx = re.compile(
                           r'''
                           site_id[ ]*=
                           [ ]*[0-9]*[ ]*\n
                           '''
                           , re.VERBOSE)


alpha = re.compile('P_velocity[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')
beta = re.compile('S_velocity[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')
rho = re.compile('RockDensity[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')

x_coord_rgx = re.compile('X_coord[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')
y_coord_rgx = re.compile('Y_coord[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')
z_coord_rgx = re.compile('Z_coord[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')

LocX_rgx = re.compile('\nLocX[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')
LocY_rgx = re.compile('\nLocY[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')
LocZ_rgx = re.compile('\nLocZ[ ]*=[ ]*[ |-][0-9]*\.[0-9]*[ ]*')

def dataRgx(gs):
    if gs < 10:
        iniString = '[ ]+'
    else:
        iniString = ''
    dataMatch = re.compile( r' '
                            + iniString + str(gs) +
                            '''
                            [ ]+[0-9]+\\:
                            [ ]+
                            [ |-][0-9]+\.[0-9]+E[-|+][0-9]+
                            [ ]+
                            [ |-][0-9]+\.[0-9]+E[-|+][0-9]+
                            [ ]+
                            [ |-][0-9]+\.[0-9]+E[-|+][0-9]+
                            [ ]*\\n
                            ''',
                            re.VERBOSE)
    return dataMatch
