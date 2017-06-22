#!/usr/bin/python

import os
import definitions


def root_path():
    return os.path.dirname(os.path.abspath(__file__))


def createListFileName(folder):
    listFlename = os.path.join(definitions.PROJECT_PATH, folder, '_list_files.txt')
    return listFlename


def generateFilesList(folder):
    listFileName = os.path.join(definitions.PROJECT_PATH, folder, '_list_files.txt')
    with open(listFileName, "r") as ins:
        array = []
        for line in ins:
            shortline = line.strip('\n')
            array.append(shortline)
        return  array


if __name__ == "__main__":
    print "exec path = " + definitions.ROOT_DIR
    print "project path = " + definitions.PROJECT_PATH
    listFiles = generateFilesList('data')
    print "files in PROJECT_PATH/data/_list_files.txt:"
    print listFiles
