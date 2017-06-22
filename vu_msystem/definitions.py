import os

ROOT_DIR = os.path.dirname(os.path.abspath(__file__)) # This is your Project Root
CONFIG_PATH = os.path.join(ROOT_DIR, 'configuration.conf')
PROJECT_PATH_without_abspath = os.path.join(os.path.dirname( __file__ ), '..')
PROJECT_PATH = os.path.abspath(os.path.join(os.path.dirname( __file__ ), '..'))
FILES_LIST_NAME = '_msystem_files.txt'
FOLDER_IP = 'ip'
FOLDER_SOURCE = 'src_v'
FOLDER_TB = 'testbench'